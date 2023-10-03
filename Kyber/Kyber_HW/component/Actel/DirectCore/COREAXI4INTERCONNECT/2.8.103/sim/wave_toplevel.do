
add wave -noupdate {/testbench/wrStart }
add wave -noupdate {/testbench/rdStart }
add wave -noupdate {/testbench/masterWrAddrDone[3:1] }
add wave -noupdate {/testbench/masterRespDone[3:1] }
add wave -noupdate {/testbench/masterRdAddrDone[3:1] }
add wave -noupdate {/testbench/masterRdDone[3:1] }
add wave -noupdate {/testbench/masterWrStatus[3:1] }
add wave -noupdate {/testbench/masterRdStatus[3:1] }
add wave -noupdate {/testbench/passStatus }
add wave -divider " -- Testbench  -----  "
add wave -group Testbench -noupdate {/testbench/* }
add wave -divider " -- UUT  -----  "
add wave -group UUT -noupdate {/testbench/uut/* }
add wave -divider " -- Master 0  -----  "
add wave -group Master0 -noupdate {/testbench/M_CLK0 }
add wave -group Master0 -noupdate {/testbench/uut/*MASTER0_* }
add wave -divider " -- Master 1  -----  "
add wave -group Master1 -noupdate {/testbench/M_CLK1 }
add wave -group Master1 -noupdate {/testbench/uut/*MASTER1_* }
add wave -divider " -- Master 2  -----  "
add wave -group Master2 -noupdate {/testbench/M_CLK2 }
add wave -group Master2 -noupdate {/testbench/uut/*MASTER2_* }
add wave -divider " -- Master 3  -----  " 
add wave -group Master3 -noupdate {/testbench/M_CLK3 }
add wave -group Master3 -noupdate {/testbench/uut/*MASTER3_* }
add wave -divider " -- SLAVE 0  -----  "
add wave -group Slave0 -noupdate {/testbench/S_CLK0 }
add wave -group Slave0 -noupdate {/testbench/uut/SLAVE0_* }
add wave -divider " -- SLAVE 1  -----  "
add wave -group Slave1 -noupdate {/testbench/S_CLK1 }
add wave -group Slave1 -noupdate {/testbench/uut/SLAVE1_* }
add wave -divider " -- SLAVE 2  -----  "
add wave -group Slave2 -noupdate {/testbench/S_CLK2 }
add wave -group Slave2 -noupdate {/testbench/uut/SLAVE2_* }
add wave -divider " -- SLAVE 3  -----  "
add wave -group Slave3 -noupdate {/testbench/S_CLK3 }
add wave -group Slave3 -noupdate {/testbench/uut/SLAVE3_* }