# Written by Synplify Pro version map202109actsp1, Build 056R. Synopsys Run ID: sid1692780230 
# Top Level Design Parameters 

# Clocks 
create_clock -period 20.000 -waveform {0.000 10.000} -name {REF_CLK_50MHz} [get_ports {REF_CLK_50MHz}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {REF_CLK_PAD_P} [get_ports {REF_CLK_PAD_P}] 
create_clock -period 6.250 -waveform {0.000 3.125} -name {CLOCKS_AND_RESETS_inst_0/OSCILLATOR_160MHz_inst_0/OSCILLATOR_160MHz_0/I_OSC_160/CLK} [get_pins {CLOCKS_AND_RESETS_inst_0/OSCILLATOR_160MHz_inst_0/OSCILLATOR_160MHz_0/I_OSC_160/CLK}] 
create_clock -period 8.000 -waveform {0.000 4.000} -name {CLOCKS_AND_RESETS_inst_0/TRANSMIT_PLL_0/TRANSMIT_PLL_0/txpll_isnt_0/DIV_CLK} [get_pins {CLOCKS_AND_RESETS_inst_0/TRANSMIT_PLL_0/TRANSMIT_PLL_0/txpll_isnt_0/DIV_CLK}] 

# Virtual Clocks 

# Generated Clocks 
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0} -multiply_by {27} -divide_by {10} -source [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/REF_CLK_0}]  [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0}] 
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT1} -multiply_by {27} -divide_by {10} -source [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/REF_CLK_0}]  [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT1}] 
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT2} -multiply_by {27} -divide_by {10} -source [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/REF_CLK_0}]  [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT2}] 
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT3} -multiply_by {81} -divide_by {80} -source [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/REF_CLK_0}]  [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT3}] 
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/CLK_160MHz_to_CLK_80MHz/CLK_DIV_0/I_CD/Y_DIV} -divide_by {2} -source [get_pins {CLOCKS_AND_RESETS_inst_0/CLK_160MHz_to_CLK_80MHz/CLK_DIV_0/I_CD/A}]  [get_pins {CLOCKS_AND_RESETS_inst_0/CLK_160MHz_to_CLK_80MHz/CLK_DIV_0/I_CD/Y_DIV}] 

# Paths Between Clocks 

# Multicycle Constraints 

# Point-to-point Delay Constraints 

# False Path Constraints 
set_false_path -through [get_pins {CLOCKS_AND_RESETS_inst_0/RESET_FIC_0_CLK/CORERESET_0/dff_15/Q}] 
set_false_path -through [get_pins {CLOCKS_AND_RESETS_inst_0/RESET_FIC_1_CLK/CORERESET_0/dff_15/Q}] 
set_false_path -through [get_pins {CLOCKS_AND_RESETS_inst_0/RESET_FIC_1_CLK/CORERESET_0/dff_15/Q}] 

# Output Load Constraints 

# Driving Cell Constraints 

# Input Delay Constraints 

# Output Delay Constraints 

# Wire Loads 

# Other Constraints 

# syn_hier Attributes 

# set_case Attributes 

# Clock Delay Constraints 
set_clock_groups -asynchronous -group [get_clocks {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0}]
set_clock_groups -asynchronous -group [get_clocks {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT1}]
set_clock_groups -asynchronous -group [get_clocks {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT2}]
set_clock_groups -asynchronous -group [get_clocks {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT3}]

# syn_mode Attributes 

# Cells 

# Port DRC Rules 

# Input Transition Constraints 

# Unused constraints (intentionally commented out) 
# set_false_path -to [get_pins { FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.INTERRUPT[0] FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.INTERRUPT[1] FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.INTERRUPT[2] FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.INTERRUPT[3] FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.INTERRUPT[4] FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.INTERRUPT[5] FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.INTERRUPT[6] FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.INTERRUPT[7] FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.WAKEREQ FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.MPERST_N }]
# set_false_path -from [get_pins { FIC_1_PERIPHERALS_1.PCIE.PF_PCIE_C0_0.PCIE_1.TL_CLK }]


# Non-forward-annotatable constraints (intentionally commented out) 

# Block Path constraints 

