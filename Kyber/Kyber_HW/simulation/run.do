quietly set ACTELLIBNAME PolarFireSoC
quietly set PROJECT_DIR "F:/RISC-V/Reference Code/icicle-kit-reference-design-master/MPFS_ICICLE"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap polarfire "D:/Microchip/Libero_SoC_v2022.2/Designer/lib/modelsimpro/precompiled/vlog/polarfire"
vmap PolarFire "D:/Microchip/Libero_SoC_v2022.2/Designer/lib/modelsimpro/precompiled/vlog/polarfire"
if {[file exists COREAXI4DMACONTROLLER_LIB/_info]} {
   echo "INFO: Simulation library COREAXI4DMACONTROLLER_LIB already exists"
} else {
   file delete -force COREAXI4DMACONTROLLER_LIB 
   vlib COREAXI4DMACONTROLLER_LIB
}
vmap COREAXI4DMACONTROLLER_LIB "COREAXI4DMACONTROLLER_LIB"
if {[file exists COREAPB3_LIB/_info]} {
   echo "INFO: Simulation library COREAPB3_LIB already exists"
} else {
   file delete -force COREAPB3_LIB 
   vlib COREAPB3_LIB
}
vmap COREAPB3_LIB "COREAPB3_LIB"

vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/address_generator.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/conflict_free_memory_map.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/delay.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/fsm.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/add_sub_rd.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/mult_rd.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/poly_mul.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/arbiter.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/network_bank_in.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/network_bf_in.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/network_bf_out.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/poly_bank.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/poly_ram.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/tf_ROM.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/tf_address_generator.v"
vlog "+incdir+${PROJECT_DIR}/hdl" -sv -work presynth "${PROJECT_DIR}/hdl/poly_ntt.v"
vlog "+incdir+${PROJECT_DIR}/hdl" "+incdir+${PROJECT_DIR}/stimulus" -sv -work presynth "${PROJECT_DIR}/stimulus/tb_poly_ntt.v"

vsim -L polarfire -L presynth -L COREAXI4DMACONTROLLER_LIB -L COREAPB3_LIB  -t 1ps -pli D:/Microchip/Libero_SoC_v2022.2/Designer/lib/modelsimpro/pli/pf_crypto_win_me_pli.dll presynth.tb_poly_ntt
add wave /tb_poly_ntt/*
run 1000ns
