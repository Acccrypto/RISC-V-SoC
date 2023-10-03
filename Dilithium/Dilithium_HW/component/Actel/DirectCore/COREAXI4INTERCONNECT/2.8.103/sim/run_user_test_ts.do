##############################################################################
# CPZ Version Number - Note: Needs to be manually changed per package
##############################################################################
quietly set CAXI4_VERSION "2.8.103"


##############################################################################
# Compile AHB Master model and files
##############################################################################
vlog -work presynth  "${PROJECT_DIR}/component/Actel/DirectCore/COREAXI4INTERCONNECT/${CAXI4_VERSION}/sim/AHBModel/AHBL_Master.v"

##############################################################################
# Compile testbench and AXI4Master and AXI4Slave models
##############################################################################
vlog -work presynth +define+SIM_MODE=1 "${PROJECT_DIR}/component/Actel/DirectCore/COREAXI4INTERCONNECT/${CAXI4_VERSION}/sim/AXI4Models/Axi4SlaveGen.v"
vlog -work presynth +define+SIM_MODE=1 "${PROJECT_DIR}/component/Actel/DirectCore/COREAXI4INTERCONNECT/${CAXI4_VERSION}/sim/AXI4Models/AxiMaster.v"
vlog -work presynth +define+SIM_MODE=1 "${PROJECT_DIR}/component/Actel/DirectCore/COREAXI4INTERCONNECT/${CAXI4_VERSION}/sim/AXI4Models/Axi4MasterGen.v"
vlog -work presynth +define+SIM_MODE=1 "${PROJECT_DIR}/component/Actel/DirectCore/COREAXI4INTERCONNECT/${CAXI4_VERSION}/sim/AXI4Models/DualPort_Ram_SyncWr_ASyncRd.v"


##############################################################################
# Compile user testbench
##############################################################################
vlog -work presynth  "${PROJECT_DIR}/component/Actel/DirectCore/COREAXI4INTERCONNECT/${CAXI4_VERSION}/sim/User_Test.v"

##############################################################################
# Define log files for output from simulation runs
##############################################################################
transcript file "${PROJECT_DIR}/component/Actel/DirectCore/COREAXI4INTERCONNECT/${CAXI4_VERSION}/sim/logs/TestAXI4Interconnect_User.log"		
transcript on

#############################################################################
# Load simulation and add waves
##############################################################################

vsim -L presynth -t 1ns presynth.testbench -gNUM_THREADS=1 -wlf waves.wlf
do "${PROJECT_DIR}/component/Actel/DirectCore/COREAXI4INTERCONNECT/${CAXI4_VERSION}/sim/wave_toplevel.do"

log -r *
run -all

transcript file ""
