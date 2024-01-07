# Microsemi Corp.
# Date: 2024-Jan-06 16:22:36
# This file was generated based on the following SDC source files:
#   E:/MPFS_Projects/Kyber_HW/constraint/MPFS_ICICLE_KIT_BASE_DESIGN_derived_constraints.sdc
#   E:/MPFS_Projects/Kyber_HW/constraint/fic_clocks.sdc
#

create_clock -name {REF_CLK_50MHz} -period 20 [ get_ports { REF_CLK_50MHz } ]
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0} -multiply_by 33 -divide_by 10 -source [ get_pins { CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
set_false_path -through [ get_pins { FIC_0_PERIPHERALS_1/FIC0_INITIATOR_inst_0/FIC0_INITIATOR_0/arst_aclk_sync/sysReset/ALn FIC_0_PERIPHERALS_1/FIC0_INITIATOR_inst_0/FIC0_INITIATOR_0/arst_aclk_sync/sysReset_f1/ALn } ]
set_clock_jitter 0.135 [ get_clocks { CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
set_clock_jitter 0.00317887 [ get_clocks { REF_CLK_50MHz } ]
set_clock_groups -name {FIC0_clks} -asynchronous -group [ get_clocks { CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
