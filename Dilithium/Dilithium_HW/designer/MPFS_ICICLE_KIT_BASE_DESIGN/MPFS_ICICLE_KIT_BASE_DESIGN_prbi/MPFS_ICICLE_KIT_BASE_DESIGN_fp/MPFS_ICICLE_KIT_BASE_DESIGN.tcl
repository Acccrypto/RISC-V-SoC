open_project -project {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN_fp/MPFS_ICICLE_KIT_BASE_DESIGN.pro}
load_programming_data \
    -name {MPFS250T_ES} \
    -fpga {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN.map} \
    -dca {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN.dca} \
    -header {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN.hdr} \
    -snvm {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN.efc}  \
    -spm {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN.spm} 
export_single_stapl -name {MPFS250T_ES} -file {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN.stp} -secured
save_project
close_project