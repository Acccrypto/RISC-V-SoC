set_device -family {PolarFireSoC} -die {MPFS250T_ES} -speed {STD}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\address_generator.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\conflict_free_memory_map.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\polyvec_ram.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\delay.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\fsm.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\fp_modop.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\poly_mul.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\arbiter.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\network_bank_in.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\network_bf_in.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\network_bf_out.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\poly_bank.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\poly_ram.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\tf_ROM.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\tf_address_generator.v}
read_verilog -mode system_verilog {F:\MPFS_Projects\MPFS_ICICLE\hdl\Core_Poly.v}
set_top_level {Core_Poly}
map_netlist
check_constraints {F:\MPFS_Projects\MPFS_ICICLE\constraint\synthesis_sdc_errors.log}
write_fdc {F:\MPFS_Projects\MPFS_ICICLE\designer\Core_Poly\synthesis.fdc}
