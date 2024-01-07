`timescale 1 ns/100 ps
// Version: 2022.2 2022.2.0.10


module PF_CCC_C0_PF_CCC_C0_0_PF_CCC(
       OUT0_FABCLK_0,
       OUT1_FABCLK_0,
       OUT2_FABCLK_0,
       OUT3_FABCLK_0,
       PLL_LOCK_0,
       REF_CLK_0,
       PLL_POWERDOWN_N_0
    );
output OUT0_FABCLK_0;
output OUT1_FABCLK_0;
output OUT2_FABCLK_0;
output OUT3_FABCLK_0;
output PLL_LOCK_0;
input  REF_CLK_0;
input  PLL_POWERDOWN_N_0;

    wire gnd_net, vcc_net, pll_inst_0_clkint_0, pll_inst_0_clkint_4, 
        pll_inst_0_clkint_8, pll_inst_0_clkint_12;
    
    CLKINT clkint_8 (.A(pll_inst_0_clkint_8), .Y(OUT2_FABCLK_0));
    CLKINT clkint_0 (.A(pll_inst_0_clkint_0), .Y(OUT0_FABCLK_0));
    PLL #( .VCOFREQUENCY(4716), .DELAY_LINE_SIMULATION_MODE(""), .DATA_RATE(0.0)
        , .FORMAL_NAME(""), .INTERFACE_NAME(""), .INTERFACE_LEVEL(3'b0)
        , .SOFTRESET(1'b0), .SOFT_POWERDOWN_N(1'b1), .RFDIV_EN(1'b1), .OUT0_DIV_EN(1'b1)
        , .OUT1_DIV_EN(1'b1), .OUT2_DIV_EN(1'b1), .OUT3_DIV_EN(1'b1), .SOFT_REF_CLK_SEL(1'b0)
        , .RESET_ON_LOCK(1'b1), .BYPASS_CLK_SEL(4'b0), .BYPASS_GO_EN_N(1'b1)
        , .BYPASS_PLL(4'b0), .BYPASS_OUT_DIVIDER(4'b0), .FF_REQUIRES_LOCK(1'b0)
        , .FSE_N(1'b0), .FB_CLK_SEL_0(2'b00), .FB_CLK_SEL_1(1'b0), .RFDIV(6'b011001)
        , .FRAC_EN(1'b0), .FRAC_DAC_EN(1'b0), .DIV0_RST_DELAY(3'b000)
        , .DIV0_VAL(7'b0001001), .DIV1_RST_DELAY(3'b000), .DIV1_VAL(7'b0001001)
        , .DIV2_RST_DELAY(3'b000), .DIV2_VAL(7'b0001001), .DIV3_RST_DELAY(3'b000)
        , .DIV3_VAL(7'b0010111), .DIV3_CLK_SEL(1'b0), .BW_INT_CTRL(2'b0)
        , .BW_PROP_CTRL(2'b01), .IREF_EN(1'b1), .IREF_TOGGLE(1'b0), .LOCK_CNT(4'b0000)
        , .DESKEW_CAL_CNT(3'b110), .DESKEW_CAL_EN(1'b1), .DESKEW_CAL_BYPASS(1'b0)
        , .SYNC_REF_DIV_EN(1'b0), .SYNC_REF_DIV_EN_2(1'b0), .OUT0_PHASE_SEL(3'b000)
        , .OUT1_PHASE_SEL(3'b000), .OUT2_PHASE_SEL(3'b000), .OUT3_PHASE_SEL(3'b000)
        , .SOFT_LOAD_PHASE_N(1'b1), .SSM_DIV_VAL(6'b1), .FB_FRAC_VAL(24'b0)
        , .SSM_SPREAD_MODE(1'b0), .SSM_MODULATION(5'b00101), .FB_INT_VAL(12'b100100110110)
        , .SSM_EN_N(1'b1), .SSM_EXT_WAVE_EN(2'b0), .SSM_EXT_WAVE_MAX_ADDR(8'b0)
        , .SSM_RANDOM_EN(1'b0), .SSM_RANDOM_PATTERN_SEL(3'b0), .CDMUX0_SEL(2'b0)
        , .CDMUX1_SEL(1'b1), .CDMUX2_SEL(1'b0), .CDELAY0_SEL(8'b0), .CDELAY0_EN(1'b0)
        , .DRI_EN(1'b1) )  pll_inst_0 (.LOCK(PLL_LOCK_0), 
        .SSCG_WAVE_TABLE_ADDR({nc0, nc1, nc2, nc3, nc4, nc5, nc6, nc7})
        , .DELAY_LINE_OUT_OF_RANGE(), .POWERDOWN_N(PLL_POWERDOWN_N_0), 
        .OUT0_EN(vcc_net), .OUT1_EN(vcc_net), .OUT2_EN(vcc_net), 
        .OUT3_EN(vcc_net), .REF_CLK_SEL(gnd_net), .BYPASS_EN_N(vcc_net)
        , .LOAD_PHASE_N(vcc_net), .SSCG_WAVE_TABLE({gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net}), 
        .PHASE_DIRECTION(gnd_net), .PHASE_ROTATE(gnd_net), 
        .PHASE_OUT0_SEL(gnd_net), .PHASE_OUT1_SEL(gnd_net), 
        .PHASE_OUT2_SEL(gnd_net), .PHASE_OUT3_SEL(gnd_net), 
        .DELAY_LINE_MOVE(gnd_net), .DELAY_LINE_DIRECTION(gnd_net), 
        .DELAY_LINE_WIDE(gnd_net), .DELAY_LINE_LOAD(vcc_net), 
        .REFCLK_SYNC_EN(gnd_net), .REF_CLK_0(REF_CLK_0), .REF_CLK_1(
        gnd_net), .FB_CLK(gnd_net), .OUT0(pll_inst_0_clkint_0), .OUT1(
        pll_inst_0_clkint_4), .OUT2(pll_inst_0_clkint_8), .OUT3(
        pll_inst_0_clkint_12), .DRI_CLK(gnd_net), .DRI_CTRL({gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net}), .DRI_WDATA({gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, gnd_net, 
        gnd_net, gnd_net, gnd_net}), .DRI_ARST_N(vcc_net), .DRI_RDATA({
        nc8, nc9, nc10, nc11, nc12, nc13, nc14, nc15, nc16, nc17, nc18, 
        nc19, nc20, nc21, nc22, nc23, nc24, nc25, nc26, nc27, nc28, 
        nc29, nc30, nc31, nc32, nc33, nc34, nc35, nc36, nc37, nc38, 
        nc39, nc40}), .DRI_INTERRUPT());
    CLKINT clkint_12 (.A(pll_inst_0_clkint_12), .Y(OUT3_FABCLK_0));
    VCC vcc_inst (.Y(vcc_net));
    GND gnd_inst (.Y(gnd_net));
    CLKINT clkint_4 (.A(pll_inst_0_clkint_4), .Y(OUT1_FABCLK_0));
    
endmodule
