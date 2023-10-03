save
set st_prbi {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN/MPFS_ICICLE_KIT_BASE_DESIGN_prbi/MPFS_ICICLE_KIT_BASE_DESIGN_st_prbi.rpt}
set fp [open $st_prbi w]
puts $fp [list_paths -from { FIC_0_PERIPHERALS_1/poly_ntt_0/bitrev:Q } -to { Probe_Insert0 }]
close $fp
