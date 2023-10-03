# ===========================================================
# Created by Microsemi SmartDesign Tue Nov 12 21:21:13 2019  
#                                                            
# Warning: Do not modify this file, it may lead to unexpected
#          simulation failures in your design.               
#                                                            
# ===========================================================
                                                             
if {$tcl_platform(os) == "Linux"} {
  exec "$env(ACTEL_SW_DIR)/bin64/bfmtovec"     -in ICICLE_MSS_PFSOC_MSS_FIC3_user.bfm -out PFSOC_MSS_FIC3.vec
} else {
  exec "$env(ACTEL_SW_DIR)/bin64/bfmtovec.exe"     -in ICICLE_MSS_PFSOC_MSS_FIC3_user.bfm -out PFSOC_MSS_FIC3.vec
}

