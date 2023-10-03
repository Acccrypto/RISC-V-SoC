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
set_def {GUI_PROJECT_PATH} {F:\MPFS_Projects\MPFS_ICICLE\MPFS_ICICLE.prjx}
set_def {GUI_PROJECT_DIR} {F:\MPFS_Projects\MPFS_ICICLE}
set_def USE_CONSTRAINTS_FLOW 1
set_name MPFS_ICICLE_KIT_BASE_DESIGN
set_workdir {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN}
set_design_state post_layout
set_operating_conditions -name slow_lv_lt
set_operating_conditions -name fast_hv_lt
set_operating_conditions -name slow_lv_ht
