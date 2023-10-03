# ===========================================================
# Created by Microsemi SmartDesign Tue Nov 12 21:21:13 2019  
#                                                            
# Warning: Do not modify this file, it may lead to unexpected
#          simulation failures in your design.               
#                                                            
# ===========================================================
                                                             
if {$tcl_platform(os) == "Linux"} {
  exec "$env(ACTEL_SW_DIR)/bin64/bfmtovec"     -in ICICLE_MSS_PFSOC_MSS_FIC1_user.bfm -out PFSOC_MSS_FIC1.vec -AXI_ADDR_WIDTH 38
} else {
  exec "$env(ACTEL_SW_DIR)/bin64/bfmtovec.exe"     -in ICICLE_MSS_PFSOC_MSS_FIC1_user.bfm -out PFSOC_MSS_FIC1.vec -AXI_ADDR_WIDTH 38
}

