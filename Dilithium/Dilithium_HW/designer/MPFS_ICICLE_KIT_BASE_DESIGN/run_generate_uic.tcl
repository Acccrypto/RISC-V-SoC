set_device \
    -fam PolarFireSoC \
    -die PA5SOC250T_ES \
    -pkg fcvg484
set_proj_dir \
    -path {F:\MPFS_Projects\MPFS_ICICLE}
set_impl_dir \
    -path {F:\MPFS_Projects\MPFS_ICICLE\designer\MPFS_ICICLE_KIT_BASE_DESIGN}
set_is_relative_path \
    -value {FALSE}
set_root_path_dir \
    -path {}
set_first_stage \
    -address 00000000
set_second_stage \
    -uprom_address 00000000 \
    -snvm_address 00000000 \
    -spi_address 00000400 \
    -spi_binding spi_noauth \
    -ramBroadcast 1 \
    -spi_ClockDivider 2
set_override_file \
    -path {}
set_auto_calib_timeout \
    -value {3000}
defvar_set -name PA5_PRINT_DEVICE_SELECTION_INIT_DATA_FILE -value 1
defvar_set -name RESTRICTPROBEPINS                         -value 1
defvar_set -name SYSTEM_CONTROLLER_SUSPEND_MODE            -value 0
defvar_set -name FHB_FLOW                                  -value 0
