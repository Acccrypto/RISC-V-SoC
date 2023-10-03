set_device -family {PolarFireSoC} -die {MPFS250T_ES} -speed {STD}
read_adl {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN.adl}
read_afl {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN.afl}
map_netlist
read_sdc {F:\MPFS_Projects\MPFS_ICICLE\constraint\MPFS_ICICLE_KIT_BASE_DESIGN_derived_constraints.sdc}
read_sdc {F:\MPFS_Projects\MPFS_ICICLE\constraint\fic_clocks.sdc}
check_constraints {F:\MPFS_Projects\MPFS_ICICLE\constraint\placer_sdc_errors.log}
estimate_jitter -report {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN\place_and_route_jitter_report.txt}
write_sdc -mode layout {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN\place_route.sdc}