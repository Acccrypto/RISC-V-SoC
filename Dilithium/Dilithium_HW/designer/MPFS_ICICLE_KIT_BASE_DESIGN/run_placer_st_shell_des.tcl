set_device \
    -family  PolarFireSoC \
    -die     PA5SOC250T_ES \
    -package fcvg484 \
    -speed   STD \
    -tempr   {EXT} \
    -voltr   {EXT}
set_def {VOLTAGE} {1.05}
set_def {VCCI_1.2_VOLTR} {EXT}
set_def {VCCI_1.5_VOLTR} {EXT}
set_def {VCCI_1.8_VOLTR} {EXT}
set_def {VCCI_2.5_VOLTR} {EXT}
set_def {VCCI_3.3_VOLTR} {EXT}
set_def {RTG4_MITIGATION_ON} {0}
set_def USE_CONSTRAINTS_FLOW 1
set_def NETLIST_TYPE EDIF
set_name MPFS_ICICLE_KIT_BASE_DESIGN
set_workdir {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN}
set_log     {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN_sdc.log}
set_design_state pre_layout
