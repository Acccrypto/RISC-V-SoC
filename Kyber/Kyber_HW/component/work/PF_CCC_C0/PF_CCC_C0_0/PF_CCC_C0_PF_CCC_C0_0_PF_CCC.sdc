set_component PF_CCC_C0_PF_CCC_C0_0_PF_CCC
# Microsemi Corp.
# Date: 2023-Sep-12 21:36:36
#

# Base clock for PLL #0
create_clock -period 20 [ get_pins { pll_inst_0/REF_CLK_0 } ]
create_generated_clock -multiply_by 33 -divide_by 10 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT0 } ]
create_generated_clock -multiply_by 77 -divide_by 30 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT1 } ]
create_generated_clock -multiply_by 77 -divide_by 30 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT2 } ]
create_generated_clock -multiply_by 231 -divide_by 230 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT3 } ]
