set_device -family {PolarFireSoC} -die {MPFS250T_ES} -speed {STD}
read_adl {E:\MPFS_Projects\Dilithium_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN.adl}
read_afl {E:\MPFS_Projects\Dilithium_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN.afl}
map_netlist
read_sdc {E:\MPFS_Projects\Dilithium_HW\constraint\MPFS_ICICLE_KIT_BASE_DESIGN_derived_constraints.sdc}
read_sdc {E:\MPFS_Projects\Dilithium_HW\constraint\fic_clocks.sdc}
check_constraints {E:\MPFS_Projects\Dilithium_HW\constraint\placer_sdc_errors.log}
estimate_jitter -report {E:\MPFS_Projects\Dilithium_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\place_and_route_jitter_report.txt}
write_sdc -mode layout {E:\MPFS_Projects\Dilithium_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\place_route.sdc}
