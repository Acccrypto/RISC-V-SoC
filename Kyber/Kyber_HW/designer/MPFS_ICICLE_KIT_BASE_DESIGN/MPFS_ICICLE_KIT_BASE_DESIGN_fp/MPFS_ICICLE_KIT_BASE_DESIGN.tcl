open_project -project {F:\mypaper2\Projects\Kyber_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN_fp\MPFS_ICICLE_KIT_BASE_DESIGN.pro}
enable_device -name {MPFS250T_ES} -enable 1
set_programming_file -name {MPFS250T_ES} -file {F:\mypaper2\Projects\Kyber_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN.ppd}
set_programming_action -action {PROGRAM} -name {MPFS250T_ES} 
run_selected_actions
save_project
close_project
