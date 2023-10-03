open_project -project {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN_fp/MPFS_ICICLE_KIT_BASE_DESIGN.pro}
set_programming_file \
    -name {MPFS250T_ES} \
    -file {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN.stp} 
enable_device \
    -name {MPFS250T_ES} \
    -enable {1} 
set_programming_action \
    -name {MPFS250T_ES} \
    -action {PROGRAM} 
run_selected_actions -prog_spi_flash 0 -disable_prog_design 0
save_project
close_project
