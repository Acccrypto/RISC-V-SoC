# Netlist Viewer TCL File
set_family -name PolarFireSoC
top_module -name mult_23
addfile -view RTL -lib work -type VLOG -mode system_verilog -name {F:/MPFS_Projects/MPFS_ICICLE/hdl/mult_23.v}
addfile -view HIER -lib work -type VLOG -mode system_verilog -name {F:/MPFS_Projects/MPFS_ICICLE/synthesis/mult_23.vm}
addfile -view FLAT -lib work -type AFL -mode NONE -name {F:/MPFS_Projects/MPFS_ICICLE/designer/mult_23/mult_23.afl}