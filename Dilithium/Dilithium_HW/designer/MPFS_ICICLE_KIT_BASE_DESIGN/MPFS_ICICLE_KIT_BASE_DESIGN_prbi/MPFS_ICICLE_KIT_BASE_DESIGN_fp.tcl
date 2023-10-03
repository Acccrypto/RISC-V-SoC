new_project \
         -name {MPFS_ICICLE_KIT_BASE_DESIGN} \
         -location {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN_fp} \
         -mode {chain}
add_actel_device \
         -device {MPFS250T_ES} \
         -name {MPFS250T_ES}
enable_device \
         -name {MPFS250T_ES} \
         -enable {TRUE}
save_project
