add_prb \
         -net    {FIC_0_PERIPHERALS_1/poly_ntt_0/bitrev_Z} \
         -port   {Probe_Insert0} \
         -pkgpin {A10} \
         -fam    {PA5SOC}
prbi \
         -desdir {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN} \
         -design {MPFS_ICICLE_KIT_BASE_DESIGN} \
         -fam {PA5SOC} \
         -die {PA5SOC250T_ES} \
         -pkg {fcvg484} \
         -use_debug {0} \
         -init_lock_file {}
