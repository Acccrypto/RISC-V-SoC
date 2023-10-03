`timescale 1 ns/100 ps
// Version: 2022.2 2022.2.0.10


module GLITCHLESS_MUX_GLITCHLESS_MUX_0_PF_NGMUX(
       CLK0,
       CLK1,
       SEL,
       CLK_OUT
    );
input  CLK0;
input  CLK1;
input  SEL;
output CLK_OUT;

    wire Y_I_NGMUX_net;
    
    ICB_NGMUX #( .NGMUX_MODE(1'b0) )  I_NGMUX (.SEL(SEL), .CLK0(CLK0), 
        .CLK1(CLK1), .Y(Y_I_NGMUX_net));
    CLKINT I_CLKINT (.A(Y_I_NGMUX_net), .Y(CLK_OUT));
    
endmodule
