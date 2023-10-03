`timescale 1 ns/100 ps
// Version: 


module ICB_NGMUX(
       SEL,
       CLK0,
       CLK1,
       Y
    )
/* synthesis black_box

*/
/* synthesis black_box black_box_pad ="" */
 ;
input  SEL;
input  CLK0;
input  CLK1;
output Y;
parameter NGMUX_MODE = 'h0;
parameter CLK0_SOURCE_SEL = 'h0;
parameter CLK1_SOURCE_SEL = 'h0;

endmodule
