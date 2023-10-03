set_device -family {PolarFireSoC} -die {MPFS250T_ES} -speed {STD}
read_verilog -mode system_verilog {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\hdl\arbiter.v}
read_verilog -mode system_verilog {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\hdl\delay.v}
read_verilog -mode system_verilog {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\hdl\network_bank_in.v}
read_verilog -mode system_verilog {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\hdl\network_bf_in.v}
read_verilog -mode system_verilog {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\hdl\network_bf_out.v}
read_verilog -mode system_verilog {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\hdl\poly_bank.v}
read_verilog -mode system_verilog {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\hdl\poly_ram.v}
set_top_level {poly_ram}
map_netlist
check_constraints {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\constraint\synthesis_sdc_errors.log}
write_fdc {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\designer\poly_ram\synthesis.fdc}
