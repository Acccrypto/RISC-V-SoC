///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: network_bf_in.v
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

module network_bf_in 
    #(parameter data_width = 23) (
    input                        clk, rst,
    input      [1:0]             sel_a_0, sel_a_1, sel_a_2, sel_a_3,
    input      [data_width-1:0]  q0, q1, q2, q3,
    output reg [data_width-1:0]  u0, v0, u1, v1
    );
   
    reg [1:0] sel_a_0_tmp, sel_a_1_tmp, sel_a_2_tmp, sel_a_3_tmp;
    
    always @(posedge clk) begin
        if(!rst) begin
            sel_a_0_tmp    <=    0;
            sel_a_1_tmp    <=    0;
            sel_a_2_tmp    <=    0;
            sel_a_3_tmp    <=    0;
        end
        else begin
            sel_a_0_tmp    <=    sel_a_0;
            sel_a_1_tmp    <=    sel_a_1;
            sel_a_2_tmp    <=    sel_a_2;
            sel_a_3_tmp    <=    sel_a_3;
        end
    end
   
   always@(*) begin
        u0 = 23'b0;
        v0 = 23'b0;
        u1 = 23'b0;
        v1 = 23'b0;
        case(sel_a_0_tmp)
            2'b00: u0 = q0; 
            2'b01: v0 = q0;
            2'b10: u1 = q0;
            2'b11: v1 = q0;
            default:;
        endcase
        
        case(sel_a_1_tmp)
            2'b00: u0 = q1;
            2'b01: v0 = q1;
            2'b10: u1 = q1;
            2'b11: v1 = q1;
            default:;
        endcase
        
        case(sel_a_2_tmp)
            2'b000: u0 = q2;
            2'b001: v0 = q2;
            2'b010: u1 = q2;
            2'b011: v1 = q2;
            default:;
        endcase   
        
        case(sel_a_3_tmp)
            2'b00: u0 = q3;
            2'b01: v0 = q3;
            2'b10: u1 = q3;
            2'b11: v1 = q3;
            default:;
        endcase 
    end  

endmodule

