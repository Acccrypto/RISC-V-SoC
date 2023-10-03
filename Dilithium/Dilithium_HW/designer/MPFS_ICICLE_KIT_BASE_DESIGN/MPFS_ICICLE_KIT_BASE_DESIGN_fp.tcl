new_project \
         -name {MPFS_ICICLE_KIT_BASE_DESIGN} \
         -location {F:\RISC-V\Reference Code\icicle-kit-reference-design-master\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {MPFS250T_ES} \
         -name {MPFS250T_ES}
enable_device \
         -name {MPFS250T_ES} \
         -enable {TRUE}
save_project
close_project
