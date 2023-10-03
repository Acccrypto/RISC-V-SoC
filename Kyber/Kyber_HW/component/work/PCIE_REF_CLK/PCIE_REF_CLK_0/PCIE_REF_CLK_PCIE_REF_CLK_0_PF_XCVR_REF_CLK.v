`timescale 1 ns/100 ps
// Version: 2022.2 2022.2.0.10


module PCIE_REF_CLK_PCIE_REF_CLK_0_PF_XCVR_REF_CLK(
       REF_CLK_PAD_P,
       REF_CLK_PAD_N,
       REF_CLK
    );
input  REF_CLK_PAD_P;
input  REF_CLK_PAD_N;
output REF_CLK;

    wire GND_net, VCC_net;
    
    XCVR_REF_CLK #( .CLKBUF_DUALCLK1_MODE(2'b11), .CLKBUF_DUALCLK1_ENTERM(2'b00)
        , .CLKBUF_DUALCLK0_MODE(2'b11), .CLKBUF_DUALCLK0_ENTERM(2'b00)
        , .CLKBUF_DUALCLK1_EN_HYST(1'b0), .CLKBUF_DUALCLK0_EN_HYST(1'b0)
        , .CLKBUF_CLKBUF_EN_RDIFF(1'b1), .CLKBUF_CLKBUF_EN_UDRIVE_N(1'b0)
        , .CLKBUF_CLKBUF_EN_UDRIVE_P(1'b0), .CLKBUF_CLKBUF_EN_PULLUP(1'b0)
        , .CLKBUF_CLKBUF_EN_APAD(1'b0) )  I_IO (.Y({nc0, nc1}), .PAD_P(
        REF_CLK_PAD_P), .PAD_N(REF_CLK_PAD_N), .REFCLK_0(REF_CLK), 
        .REFCLK_1());
    VCC vcc_inst (.Y(VCC_net));
    GND gnd_inst (.Y(GND_net));
    
endmodule
