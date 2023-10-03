`timescale 1 ns/100 ps
// Version: 2022.2 2022.2.0.10


module TRANSMIT_PLL_TRANSMIT_PLL_0_PF_TX_PLL(
       REF_CLK,
       PLL_LOCK,
       LOCK,
       BIT_CLK,
       CLK_125,
       REF_CLK_TO_LANE
    );
input  REF_CLK;
output PLL_LOCK;
output LOCK;
output BIT_CLK;
output CLK_125;
output REF_CLK_TO_LANE;

    wire gnd_net, vcc_net;
    
    VCC vcc_inst (.Y(vcc_net));
    TX_PLL #( .DATA_RATE(5000.0), .CTRL_FOUTAUXDIV2_SEL(1'b1), .SERDES_SSMOD_SSMOD_DISABLE_SSCG(1'b1)
        , .CTRL_BWSEL(1'b0), .CTRL_VBGREF_SEL(1'b0), .CTRL_FBDIV_SEL(2'b0)
        , .CTRL_DSMPD(1'b1), .CLK_SEL_REFCLK_SEL_HM(2'b11), .CLK_SEL_REFCLK_SEL_SM(3'b001)
        , .DIV_1_AUXDIV(12'b000000001010), .DIV_1_FBDIV(12'b000000011001)
        , .DIV_2_FRAC(24'b000000000000000000000000), .DIV_2_REFDIV(6'b000001)
         )  txpll_isnt_0 (.FAB_LOCK(PLL_LOCK), .DIV_CLK(CLK_125), 
        .FAB_REF_CLK(gnd_net), .REF_CLK_P(REF_CLK), .REF_CLK_N(gnd_net)
        , .BIT_CLK(BIT_CLK), .JA_REF_CLK(gnd_net), .LOCK(LOCK), 
        .REF_CLK_TO_LANE(REF_CLK_TO_LANE), .DRI_CLK(gnd_net), 
        .DRI_CTRL({gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net}), 
        .DRI_WDATA({gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net})
        , .DRI_ARST_N(vcc_net), .DRI_RDATA({nc0, nc1, nc2, nc3, nc4, 
        nc5, nc6, nc7, nc8, nc9, nc10, nc11, nc12, nc13, nc14, nc15, 
        nc16, nc17, nc18, nc19, nc20, nc21, nc22, nc23, nc24, nc25, 
        nc26, nc27, nc28, nc29, nc30, nc31, nc32}), .DRI_INTERRUPT(), 
        .LINK_CLK(gnd_net), .LINK_ADDR({gnd_net, gnd_net, gnd_net}), 
        .LINK_EN(gnd_net), .LINK_ARST_N(gnd_net), .LINK_WDATA({gnd_net, 
        gnd_net, gnd_net, gnd_net}), .LINK_RDATA({nc33, nc34, nc35, 
        nc36}));
    GND gnd_inst (.Y(gnd_net));
    
endmodule
