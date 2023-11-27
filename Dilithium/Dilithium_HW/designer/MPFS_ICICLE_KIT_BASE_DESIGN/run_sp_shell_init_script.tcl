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
set_def {PLL_SUPPLY} {}
set_def {VPP_SUPPLY_25_33} {VPP_SUPPLY_33}
set_def {VDDAUX_SUPPLY_25_33} {VDDAUX_SUPPLY_25}
set_def USE_CONSTRAINTS_FLOW 1
set_netlist -afl {E:\MPFS_Projects\Dilithium_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN.afl} -adl {E:\MPFS_Projects\Dilithium_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN.adl}
set_placement   {E:\MPFS_Projects\Dilithium_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN.loc}
set_routing     {E:\MPFS_Projects\Dilithium_HW\designer\MPFS_ICICLE_KIT_BASE_DESIGN\MPFS_ICICLE_KIT_BASE_DESIGN.seg}
set_sdcfilelist -sdc {E:\MPFS_Projects\Dilithium_HW\constraint\MPFS_ICICLE_KIT_BASE_DESIGN_derived_constraints.sdc, E:\MPFS_Projects\Dilithium_HW\constraint\fic_clocks.sdc}
