# Written by Synplify Pro version map202109actsp1, Build 056R. Synopsys Run ID: sid1704529018 
# Top Level Design Parameters 

# Clocks 
create_clock -period 20.000 -waveform {0.000 10.000} -name {REF_CLK_50MHz} [get_ports {REF_CLK_50MHz}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {PF_CCC_C0_PF_CCC_C0_0_PF_CCC|pll_inst_0_clkint_12_inferred_clock} [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT3}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {PF_CCC_C0_PF_CCC_C0_0_PF_CCC|pll_inst_0_clkint_8_inferred_clock} [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT2}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {PF_CCC_C0_PF_CCC_C0_0_PF_CCC|pll_inst_0_clkint_4_inferred_clock} [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT1}] 

# Virtual Clocks 

# Generated Clocks 
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0} -multiply_by {33} -divide_by {10} -source [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/REF_CLK_0}]  [get_pins {CLOCKS_AND_RESETS_inst_0/CCC_FIC_x_CLK/PF_CCC_C0_0/pll_inst_0/OUT0}] 

# Paths Between Clocks 

# Multicycle Constraints 

# Point-to-point Delay Constraints 

# False Path Constraints 
set_false_path -through [get_pins {CLOCKS_AND_RESETS_inst_0/RESET_FIC_0_CLK/CORERESET_0/dff_15/Q}] 

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
set_clock_groups -asynchronous -group [get_clocks {PF_CCC_C0_PF_CCC_C0_0_PF_CCC|pll_inst_0_clkint_12_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {PF_CCC_C0_PF_CCC_C0_0_PF_CCC|pll_inst_0_clkint_8_inferred_clock}]
set_clock_groups -asynchronous -group [get_clocks {PF_CCC_C0_PF_CCC_C0_0_PF_CCC|pll_inst_0_clkint_4_inferred_clock}]

# syn_mode Attributes 

# Cells 

# Port DRC Rules 

# Input Transition Constraints 

# Unused constraints (intentionally commented out) 


# Non-forward-annotatable constraints (intentionally commented out) 

# Block Path constraints 

