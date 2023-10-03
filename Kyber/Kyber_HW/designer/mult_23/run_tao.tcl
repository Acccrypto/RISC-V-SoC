set_device -family {PolarFireSoC} -die {MPFS250T_ES} -speed {STD}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\mult_23.v}
set_top_level {mult_23}
map_netlist
check_constraints {F:\MPFS_Projects\MPFS_ICICLE\constraint\synthesis_sdc_errors.log}
write_fdc {F:\MPFS_Projects\MPFS_ICICLE\designer\mult_23\synthesis.fdc}
