///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: conflict_free_memory_map.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::PolarFireSoC> <Die::MPFS250T_ES> <Package::FCVG484>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>

module conflict_free_memory_map(
    input            clk, rst,
    input      [6:0] old_address_0,
    input      [6:0] old_address_1,
    input      [6:0] old_address_2,
    input      [6:0] old_address_3,
    // bank address for read
    output reg [4:0] new_address_0,
    output reg [4:0] new_address_1,
    output reg [4:0] new_address_2,
    output reg [4:0] new_address_3,

    //bank index
    output reg [1:0] bank_number_0,
    output reg [1:0] bank_number_1,
    output reg [1:0] bank_number_2,
    output reg [1:0] bank_number_3
);
    
    wire [4:0] new_address_0_tmp;
    wire [4:0] new_address_1_tmp;
    wire [4:0] new_address_2_tmp;
    wire [4:0] new_address_3_tmp;
     
    assign new_address_0_tmp = old_address_0[6:2];    
    assign new_address_1_tmp = old_address_1[6:2];
    assign new_address_2_tmp = old_address_2[6:2];
    assign new_address_3_tmp = old_address_3[6:2];    
    
    wire [1:0] bank_number_0_tmp;
    wire [1:0] bank_number_1_tmp;
    wire [1:0] bank_number_2_tmp;
    wire [1:0] bank_number_3_tmp;                                                         
    
    assign bank_number_0_tmp = { old_address_0[6] ^ old_address_0[5] ^ old_address_0[4] ^ old_address_0[3] ^ old_address_0[2], 1'b0 } + old_address_0[1:0];
    assign bank_number_1_tmp = { old_address_1[6] ^ old_address_1[5] ^ old_address_1[4] ^ old_address_1[3] ^ old_address_1[2], 1'b0 } + old_address_1[1:0];      
    assign bank_number_2_tmp = { old_address_2[6] ^ old_address_2[5] ^ old_address_2[4] ^ old_address_2[3] ^ old_address_2[2], 1'b0 } + old_address_2[1:0];  
    assign bank_number_3_tmp = { old_address_3[6] ^ old_address_3[5] ^ old_address_3[4] ^ old_address_3[3] ^ old_address_3[2], 1'b0 } + old_address_3[1:0];    
    
    always @(posedge clk) begin
        if(!rst) begin
            bank_number_0    <=    0;
            bank_number_1    <=    0;
            bank_number_2    <=    0;
            bank_number_3    <=    0;
            new_address_0    <=    0;
            new_address_1    <=    0;
            new_address_2    <=    0;
            new_address_3    <=    0;
        end
        else begin
            bank_number_0    <=    bank_number_0_tmp;
            bank_number_1    <=    bank_number_1_tmp;
            bank_number_2    <=    bank_number_2_tmp;
            bank_number_3    <=    bank_number_3_tmp;
            new_address_0    <=    new_address_0_tmp;
            new_address_1    <=    new_address_1_tmp;
            new_address_2    <=    new_address_2_tmp;
            new_address_3    <=    new_address_3_tmp;
        end
    end

endmodule

