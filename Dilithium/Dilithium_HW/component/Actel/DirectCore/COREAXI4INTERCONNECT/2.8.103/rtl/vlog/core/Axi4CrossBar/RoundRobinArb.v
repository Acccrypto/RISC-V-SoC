`timescale 1ns / 1ns
///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: MICROSEMI
//
// IP Core: COREAXI4INTERCONNECT
//
//  Description  : The AMBA AXI4 Interconnect core connects one or more AXI memory-mapped master devices to one or
//                 more memory-mapped slave devices. The AMBA AXI protocol supports high-performance, high-frequency
//                 system designs.
//
//     Abstract  : This file contains a Round Round Arbitrator for a configurable 
//                 number of requestors.
//
//  COPYRIGHT 2017 BY MICROSEMI 
//  THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
//  FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
//  MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
//  NO BACK-UP OF THE FILE SHOULD BE MADE. 
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

module caxi4interconnect_RoundRobinArb (
						// global signals
						sysClk,
						sysReset,

						requestor,
						arbEnable,					
						grant,
						grantEnc,
						grantValid
				   
					  );


//===================================================
// Parameter Declarations
//===================================================

	parameter N = 2;							// defines number bits for requestors/grants
	parameter N_WIDTH = 1;						// defines number bits for number of requestors/grants
	
	parameter HI_FREQ 			= 0;			// increases freq of operation at cost of added latency
	
	
	//===============================================
	// Memory Map - Word addressing
	//===============================================
	localparam STATUS_WORD 		= 5'h00;

	
//============================================================================
// I/O Declarations
//============================================================================

	input sysClk;									// system clock
	input sysReset;									// system reset - synchronse to sysClk - active high
	
	
	input 	[N-1:0]	requestor;						// requestors to be arbitrated between
	input			arbEnable;						// Indictaes when an arbitration should be performs among requestors
	
	output 	[N-1:0] grant;							// winner of arbitration will have grant bit set - available 1 clock tick after
													// arbEnable asserted.
	output	[N_WIDTH-1:0]	grantEnc;				// encoded version of grant which is one-hot.

	output			grantValid;						// asserted when grant is valid
//============================================================================
// Local Declarationes
//============================================================================

 reg [N-1:0]		grant;
 wire [N-1:0]		d_grant;
 
 reg [N_WIDTH-1:0]	grantEnc;				// encoded version of grant which is one-hot.

 reg			grantValid;			

 reg [N-1:0]	priorityMask;					// mask to remove winner and lower requestors
 
 reg [N-1:0]	requestorMasked;				// requestor has "granted" masked out when arbEnable asserted (as source will still be driving last request

 wire [N-1:0] 	reqMasked, mask_higher_pri_reqs, grantMasked;
 wire [N-1:0]	unmask_higher_pri_reqs, grantUnmasked;
 wire			no_req_masked;

 
//===============================================================================================
// Convert 16-bit one-hot to 4-bit binary
//===============================================================================================
function [4:0] fnc_hot2enc
    (
      input [31:0]  oneHot
    );
	begin
      fnc_hot2enc[0] = |(oneHot & 32'b10101010101010101010101010101010);
      fnc_hot2enc[1] = |(oneHot & 32'b11001100110011001100110011001100);
      fnc_hot2enc[2] = |(oneHot & 32'b11110000111100001111000011110000);
      fnc_hot2enc[3] = |(oneHot & 32'b11111111000000001111111100000000);
      fnc_hot2enc[4] = |(oneHot & 32'b11111111111111110000000000000000);
	end
endfunction	

 
//==================================================================================
// Mask out granted request when grantValid asserted as source still driving request
//===================================================================================
generate
	if ( HI_FREQ == 1 )
		begin

			always @(posedge sysClk or negedge sysReset)
				begin
				    if(~sysReset)
					  requestorMasked <= 0;
					else if ( grantValid )
					  requestorMasked <= { requestor & ( ~( grant ) ) };
					else 														// handle fact we have add pipeline stage - about to set grantValid
					  requestorMasked <= { requestor & ( ~( d_grant ) ) };	// mask out questor selected in case arbEnable asserted
																				// immediately
				end
		end
	else
		begin
			always @( * )
				begin
					requestorMasked <= { requestor & ( ~( grant & { N{grantValid} } ) ) };
				end		

		end

endgenerate



//==============================================================================
// Simple priority arbitration for masked portion
//==============================================================================
assign reqMasked = requestorMasked & priorityMask;
assign mask_higher_pri_reqs[N-1:1] = mask_higher_pri_reqs[N-2: 0] | reqMasked[N-2:0] ;
assign mask_higher_pri_reqs[0] = 1'b0;

assign grantMasked[N-1:0] = reqMasked[N-1:0] & ~mask_higher_pri_reqs[N-1:0];

//=================================================================================
// Simple priority arbitration for unmasked portion
//=================================================================================
assign unmask_higher_pri_reqs[N-1:1] = unmask_higher_pri_reqs[N-2:0] | requestorMasked[N-2:0];
assign unmask_higher_pri_reqs[0] = 1'b0;
assign grantUnmasked[N-1:0] = requestorMasked[N-1:0] & ~unmask_higher_pri_reqs[N-1:0];

//===================================================================================
// Use grant_masked if there is any there, otherwise use grant_unmasked.
// Coded as AND / OR rather than mux to make synthesis easier.
//===================================================================================
assign no_req_masked = ~( |reqMasked );

assign	d_grant = ( { N{ no_req_masked } } & grantUnmasked ) | grantMasked;

always @(posedge sysClk or negedge sysReset )
begin
	if ( !sysReset )
		begin
		
			grantEnc <= 0;			// encode one-hot 

			grant 		<=  { 1'b1, { N-1{1'b0} } };		// default to highest requestorMasked granted - 0 is next
			grantValid	<= 1'b0;

		end
	else if (arbEnable | ~grantValid)						// arb no grantValid or arbEnable asserted to indicate finished with last request
		begin
			grant 		<= d_grant;
			grantEnc 	<= fnc_hot2enc ( d_grant );			// encode one-hot - used to help with timing closure

			grantValid	<= |(requestorMasked);
		end
		
end

//===================================================================================
// Update priority mask to remove winner and lower requesters
//===================================================================================
always @ (posedge sysClk or negedge sysReset ) 
begin
	if (!sysReset) 
		begin
			priorityMask <= { N{1'b1} };		// initialise that requestorMasked[0] has priority
		end 
	else 
		begin
			if ( arbEnable )
				begin
					if ( |reqMasked ) 
						begin // Which arbiter was used?
							priorityMask <= mask_higher_pri_reqs;
						end 
					else 
						begin
							if ( |requestorMasked )  
								begin 		// Only update if there's a req
									priorityMask <= unmask_higher_pri_reqs;
								end 
						end
				end
		end
		
end



endmodule // caxi4interconnect_RoundRobinArb.v
