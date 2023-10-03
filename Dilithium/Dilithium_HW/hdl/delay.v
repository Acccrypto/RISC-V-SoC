///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: delay.v
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

module delay
#(
    parameter WIDTH = 1,
    parameter DELAY = 1
)
(
    input  wire clk,
    input  wire [WIDTH-1:0] din,
    output wire [WIDTH-1:0] dout
);

    reg [WIDTH-1:0] level_buf [1:DELAY+1];

    wire [WIDTH-1:0] level [0:DELAY];

    assign level[0] = din;

    integer j;
    initial begin
        for (j = 1; j <= DELAY; j = j + 1)
            level_buf[j] = {WIDTH{1'b0}};
    end

    genvar i;
    generate
        for (i=0; i < DELAY; i=i+1) begin: gen_delay
            always @(posedge clk) begin
                level_buf[i+1] <= level[i];
            end
            assign level[i+1] = level_buf[i+1];
        end
    endgenerate

    assign dout = level[DELAY];

endmodule

