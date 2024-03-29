# Microsemi Corp.
# Date: 2024-Jan-06 16:58:31
# This file was generated based on the following SDC source files:
#   E:/MPFS_Projects/Dilithium_HW/component/work/PF_CCC_C0/PF_CCC_C0_0/PF_CCC_C0_PF_CCC_C0_0_PF_CCC.sdc
#   E:/MPFS_Projects/Dilithium_HW/component/work/FIC0_INITIATOR/FIC0_INITIATOR_0/FIC0_INITIATOR.sdc
#   E:/MPFS_Projects/Dilithium_HW/component/work/ICICLE_MSS/ICICLE_MSS.sdc
# *** Any modifications to this file will be lost if derived constraints is re-run. ***
#

create_clock -name {REF_CLK_50MHz} -period 20 [ get_ports { REF_CLK_50MHz } ]
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0} -multiply_by 131 -divide_by 50 -source [ get_pins { CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
set_false_path -through [ get_nets { FIC_0_PERIPHERALS_1/FIC0_INITIATOR_inst_0/ARESETN* } ]
