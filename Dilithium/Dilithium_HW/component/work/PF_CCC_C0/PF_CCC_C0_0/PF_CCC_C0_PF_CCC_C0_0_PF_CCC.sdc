set_component PF_CCC_C0_PF_CCC_C0_0_PF_CCC
# Microsemi Corp.
# Date: 2023-Aug-23 16:24:31
#

# Base clock for PLL #0
create_clock -period 20 [ get_pins { pll_inst_0/REF_CLK_0 } ]
create_generated_clock -multiply_by 27 -divide_by 10 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT0 } ]
create_generated_clock -multiply_by 27 -divide_by 10 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT1 } ]
create_generated_clock -multiply_by 27 -divide_by 10 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT2 } ]
create_generated_clock -multiply_by 81 -divide_by 80 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT3 } ]
