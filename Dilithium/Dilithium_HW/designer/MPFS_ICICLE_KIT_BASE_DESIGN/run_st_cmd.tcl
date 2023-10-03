read_sdc -scenario "timing_analysis" -netlist "optimized" -pin_separator "/" -ignore_errors {F:/MPFS_Projects/MPFS_ICICLE/designer/MPFS_ICICLE_KIT_BASE_DESIGN/timing_analysis.sdc}
set_options -analysis_scenario "timing_analysis" 
save
