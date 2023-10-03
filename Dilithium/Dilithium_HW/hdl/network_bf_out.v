///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: network_bf_out.v
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

module network_bf_out 
    #(parameter data_width = 23) (
    input                       clk,
    input      [2:0]            sel,
    input      [data_width-1:0] bf_0_upper, bf_0_lower, bf_1_upper, bf_1_lower,
    input      [1:0]            sel_a_0, sel_a_1, sel_a_2, sel_a_3,
    output reg [data_width-1:0] d0, d1, d2, d3
    );
    
    wire [1:0] sel_a_0_reg1, sel_a_1_reg1, sel_a_2_reg1, sel_a_3_reg1;
    wire [1:0] sel_a_0_reg2, sel_a_1_reg2, sel_a_2_reg2, sel_a_3_reg2;
    wire [1:0] sel_a_0_out, sel_a_1_out, sel_a_2_out, sel_a_3_out;
    
    delay #(.WIDTH(8), .DELAY(4)) delay_0 (
        .clk(clk), 
        .din({ sel_a_0, sel_a_1, sel_a_2, sel_a_3 }),
        .dout({ sel_a_0_reg1, sel_a_1_reg1, sel_a_2_reg1, sel_a_3_reg1 })      
    );
    
    delay #(.WIDTH(8), .DELAY(3)) delay_1 (
        .clk(clk), 
        .din({ sel_a_0_reg1, sel_a_1_reg1, sel_a_2_reg1, sel_a_3_reg1 }),
        .dout({ sel_a_0_reg2, sel_a_1_reg2, sel_a_2_reg2, sel_a_3_reg2 })      
    );
    
    assign { sel_a_0_out, sel_a_1_out, sel_a_2_out, sel_a_3_out } = (sel[1] & sel[2])? { sel_a_0_reg1, sel_a_1_reg1, sel_a_2_reg1, sel_a_3_reg1 } :
           (sel[0] | sel[1] | sel[2])? { sel_a_0_reg2, sel_a_1_reg2, sel_a_2_reg2, sel_a_3_reg2 } : { sel_a_0, sel_a_1, sel_a_2, sel_a_3 };
                   
    always@(*) begin
        case(sel_a_0_out)
            2'b00: d0 = bf_0_lower;
            2'b01: d0 = bf_0_upper;
            2'b10: d0 = bf_1_lower;
            2'b11: d0 = bf_1_upper;
            default:;
        endcase
    end
    
    always@(*) begin
        case(sel_a_1_out)
            2'b00: d1 = bf_0_lower;
            2'b01: d1 = bf_0_upper;
            2'b10: d1 = bf_1_lower;
            2'b11: d1 = bf_1_upper;
            default:;
        endcase
    end    
    
    always@(*) begin
        case(sel_a_2_out)
            2'b00: d2 = bf_0_lower;
            2'b01: d2 = bf_0_upper;
            2'b10: d2 = bf_1_lower;
            2'b11: d2 = bf_1_upper;
            default:;
        endcase
    end                       

    always@(*) begin
        case(sel_a_3_out)
            2'b00: d3 = bf_0_lower;
            2'b01: d3 = bf_0_upper;
            2'b10: d3 = bf_1_lower;
            2'b11: d3 = bf_1_upper;
            default:;
        endcase
    end

endmodule

