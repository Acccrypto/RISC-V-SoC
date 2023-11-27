//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Sun Nov 26 17:03:15 2023
// Version: 2022.2 2022.2.0.10
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// MPFS_ICICLE_KIT_BASE_DESIGN
module MPFS_ICICLE_KIT_BASE_DESIGN(
    // Inputs
    CAN_0_RXBUS_F2M,
    CAN_1_RXBUS,
    MMUART_0_RXD_F2M,
    MMUART_1_RXD_F2M,
    MMUART_2_RXD_F2M,
    MMUART_3_RXD_F2M,
    REFCLK,
    REFCLK_N,
    REF_CLK_50MHz,
    SD_CD_EMMC_STRB,
    SD_WP_EMMC_RSTN,
    SGMII_RX0_N,
    SGMII_RX0_P,
    SGMII_RX1_N,
    SGMII_RX1_P,
    SPI_1_DI,
    SW1,
    SW2,
    SW3,
    SW4,
    USB_CLK,
    USB_DIR,
    USB_NXT,
    mBUS_INT,
    mBUS_UART_RX,
    // Outputs
    CA,
    CAN_0_TXBUS_M2F,
    CAN_0_TX_EBL_M2F,
    CAN_1_TXBUS,
    CAN_1_TX_EBL_N,
    CK,
    CKE,
    CK_N,
    CS,
    DM,
    LED0,
    LED1,
    LED2,
    LED3,
    MAC_1_MDC,
    MMUART_0_TXD_M2F,
    MMUART_1_TXD_M2F,
    MMUART_2_TXD_M2F,
    MMUART_3_TXD_M2F,
    ODT,
    RESET_N,
    SDIO_SW_EN_N,
    SD_CLK_EMMC_CLK,
    SD_POW_EMMC_DATA4,
    SD_VOLT_CMD_DIR_EMMC_DATA7,
    SD_VOLT_DIR_0_EMMC_UNUSED,
    SD_VOLT_DIR_1_3_EMMC_UNUSED,
    SD_VOLT_EN_EMMC_DATA6,
    SD_VOLT_SEL_EMMC_DATA5,
    SGMII_TX0_N,
    SGMII_TX0_P,
    SGMII_TX1_N,
    SGMII_TX1_P,
    SPI_1_DO,
    USB_STP,
    USB_ULPI_RESET,
    VSC_8662_CMODE3,
    VSC_8662_CMODE4,
    VSC_8662_CMODE5,
    VSC_8662_CMODE6,
    VSC_8662_CMODE7,
    VSC_8662_OSCEN,
    VSC_8662_PLLMODE,
    VSC_8662_RESETN,
    VSC_8662_SRESET,
    mBUS_UART_TX,
    // Inouts
    DQ,
    DQS,
    DQS_N,
    I2C_1_SCL,
    I2C_1_SDA,
    MAC_1_MDIO,
    QSPI_CLK,
    QSPI_DATA_0,
    QSPI_DATA_1,
    QSPI_DATA_2,
    QSPI_DATA_3,
    QSPI_SEL,
    RPi_GPIO12,
    RPi_GPIO13,
    RPi_GPIO16,
    RPi_GPIO17,
    RPi_GPIO19,
    RPi_GPIO20,
    RPi_GPIO21,
    RPi_GPIO22,
    RPi_GPIO23,
    RPi_GPIO24,
    RPi_GPIO25,
    RPi_GPIO26,
    RPi_GPIO27,
    SD_CMD_EMMC_CMD,
    SD_DATA0_EMMC_DATA0,
    SD_DATA1_EMMC_DATA1,
    SD_DATA2_EMMC_DATA2,
    SD_DATA3_EMMC_DATA3,
    SPI_1_CLK,
    SPI_1_SS0,
    USB_DATA0,
    USB_DATA1,
    USB_DATA2,
    USB_DATA3,
    USB_DATA4,
    USB_DATA5,
    USB_DATA6,
    USB_DATA7,
    mBUS_I2C_SCL,
    mBUS_I2C_SDA
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         CAN_0_RXBUS_F2M;
input         CAN_1_RXBUS;
input         MMUART_0_RXD_F2M;
input         MMUART_1_RXD_F2M;
input         MMUART_2_RXD_F2M;
input         MMUART_3_RXD_F2M;
input         REFCLK;
input         REFCLK_N;
input         REF_CLK_50MHz;
input         SD_CD_EMMC_STRB;
input         SD_WP_EMMC_RSTN;
input         SGMII_RX0_N;
input         SGMII_RX0_P;
input         SGMII_RX1_N;
input         SGMII_RX1_P;
input         SPI_1_DI;
input         SW1;
input         SW2;
input         SW3;
input         SW4;
input         USB_CLK;
input         USB_DIR;
input         USB_NXT;
input         mBUS_INT;
input         mBUS_UART_RX;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [5:0]  CA;
output        CAN_0_TXBUS_M2F;
output        CAN_0_TX_EBL_M2F;
output        CAN_1_TXBUS;
output        CAN_1_TX_EBL_N;
output        CK;
output        CKE;
output        CK_N;
output        CS;
output [3:0]  DM;
output        LED0;
output        LED1;
output        LED2;
output        LED3;
output        MAC_1_MDC;
output        MMUART_0_TXD_M2F;
output        MMUART_1_TXD_M2F;
output        MMUART_2_TXD_M2F;
output        MMUART_3_TXD_M2F;
output        ODT;
output        RESET_N;
output        SDIO_SW_EN_N;
output        SD_CLK_EMMC_CLK;
output        SD_POW_EMMC_DATA4;
output        SD_VOLT_CMD_DIR_EMMC_DATA7;
output        SD_VOLT_DIR_0_EMMC_UNUSED;
output        SD_VOLT_DIR_1_3_EMMC_UNUSED;
output        SD_VOLT_EN_EMMC_DATA6;
output        SD_VOLT_SEL_EMMC_DATA5;
output        SGMII_TX0_N;
output        SGMII_TX0_P;
output        SGMII_TX1_N;
output        SGMII_TX1_P;
output        SPI_1_DO;
output        USB_STP;
output        USB_ULPI_RESET;
output        VSC_8662_CMODE3;
output        VSC_8662_CMODE4;
output        VSC_8662_CMODE5;
output        VSC_8662_CMODE6;
output        VSC_8662_CMODE7;
output        VSC_8662_OSCEN;
output        VSC_8662_PLLMODE;
output        VSC_8662_RESETN;
output        VSC_8662_SRESET;
output        mBUS_UART_TX;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout  [31:0] DQ;
inout  [3:0]  DQS;
inout  [3:0]  DQS_N;
inout         I2C_1_SCL;
inout         I2C_1_SDA;
inout         MAC_1_MDIO;
inout         QSPI_CLK;
inout         QSPI_DATA_0;
inout         QSPI_DATA_1;
inout         QSPI_DATA_2;
inout         QSPI_DATA_3;
inout         QSPI_SEL;
inout         RPi_GPIO12;
inout         RPi_GPIO13;
inout         RPi_GPIO16;
inout         RPi_GPIO17;
inout         RPi_GPIO19;
inout         RPi_GPIO20;
inout         RPi_GPIO21;
inout         RPi_GPIO22;
inout         RPi_GPIO23;
inout         RPi_GPIO24;
inout         RPi_GPIO25;
inout         RPi_GPIO26;
inout         RPi_GPIO27;
inout         SD_CMD_EMMC_CMD;
inout         SD_DATA0_EMMC_DATA0;
inout         SD_DATA1_EMMC_DATA1;
inout         SD_DATA2_EMMC_DATA2;
inout         SD_DATA3_EMMC_DATA3;
inout         SPI_1_CLK;
inout         SPI_1_SS0;
inout         USB_DATA0;
inout         USB_DATA1;
inout         USB_DATA2;
inout         USB_DATA3;
inout         USB_DATA4;
inout         USB_DATA5;
inout         USB_DATA6;
inout         USB_DATA7;
inout         mBUS_I2C_SCL;
inout         mBUS_I2C_SDA;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [5:0]  CA_net_0;
wire          CAN_0_RXBUS_F2M;
wire          CAN_0_TX_EBL_M2F_net_0;
wire          CAN_0_TXBUS_M2F_net_0;
wire          CAN_1_RXBUS;
wire          CAN_1_TX_EBL_N_net_0;
wire          CAN_1_TXBUS_net_0;
wire          CK_net_0;
wire          CK_N_net_0;
wire          CKE_net_0;
wire          CLOCKS_AND_RESETS_FIC_0_CLK;
wire          CLOCKS_AND_RESETS_FIC_1_CLK;
wire          CLOCKS_AND_RESETS_FIC_2_CLK;
wire          CLOCKS_AND_RESETS_FIC_3_CLK;
wire          CLOCKS_AND_RESETS_RESETN_FIC_0_CLK;
wire          CS_net_0;
wire   [3:0]  DM_net_0;
wire   [31:0] DQ;
wire   [3:0]  DQS;
wire   [3:0]  DQS_N;
wire          FIC_0_PERIPHERALS_1_core_poly_irq;
wire          I2C_1_SCL;
wire          I2C_1_SDA;
wire          LED0_0;
wire          LED1_0;
wire          LED2_0;
wire          LED3_0;
wire          MAC_1_MDC_net_0;
wire          MAC_1_MDIO;
wire          mBUS_I2C_SCL;
wire          mBUS_I2C_SDA;
wire          mBUS_INT;
wire          mBUS_UART_RX;
wire          mBUS_UART_TX_net_0;
wire          MMUART_0_RXD_F2M;
wire          MMUART_0_TXD_M2F_net_0;
wire          MMUART_1_RXD_F2M;
wire          MMUART_1_TXD_M2F_net_0;
wire          MMUART_2_RXD_F2M;
wire          MMUART_2_TXD_M2F_net_0;
wire          MMUART_3_RXD_F2M;
wire          MMUART_3_TXD_M2F_net_0;
wire   [37:0] MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARADDR;
wire   [1:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARBURST;
wire   [3:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARCACHE;
wire   [7:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARID;
wire   [7:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLEN;
wire   [2:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARPROT;
wire   [3:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARQOS;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARREADY;
wire   [2:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARSIZE;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARVALID;
wire   [37:0] MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWADDR;
wire   [1:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWBURST;
wire   [3:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWCACHE;
wire   [7:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWID;
wire   [7:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLEN;
wire   [2:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWPROT;
wire   [3:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWQOS;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWREADY;
wire   [2:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWSIZE;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWVALID;
wire   [7:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BID;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BREADY;
wire   [1:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BRESP;
wire   [0:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BUSER;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BVALID;
wire   [63:0] MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RDATA;
wire   [7:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RID;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RLAST;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RREADY;
wire   [1:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RRESP;
wire   [0:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RUSER;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RVALID;
wire   [63:0] MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WDATA;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WLAST;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WREADY;
wire   [7:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WSTRB;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WVALID;
wire          MSS_WRAPPER_1_GPIO_2_M2F_26;
wire          MSS_WRAPPER_1_GPIO_2_M2F_27;
wire          MSS_WRAPPER_1_GPIO_2_M2F_28;
wire          MSS_WRAPPER_1_MSS_DLL_LOCKS;
wire          ODT_net_0;
wire          QSPI_CLK;
wire          QSPI_DATA_0;
wire          QSPI_DATA_1;
wire          QSPI_DATA_2;
wire          QSPI_DATA_3;
wire          QSPI_SEL;
wire          REF_CLK_50MHz;
wire          REFCLK;
wire          REFCLK_N;
wire          RESET_N_net_0;
wire          RPi_GPIO12;
wire          RPi_GPIO13;
wire          RPi_GPIO16;
wire          RPi_GPIO17;
wire          RPi_GPIO19;
wire          RPi_GPIO20;
wire          RPi_GPIO21;
wire          RPi_GPIO22;
wire          RPi_GPIO23;
wire          RPi_GPIO24;
wire          RPi_GPIO25;
wire          RPi_GPIO26;
wire          RPi_GPIO27;
wire          SD_CD_EMMC_STRB;
wire          SD_CLK_EMMC_CLK_net_0;
wire          SD_CMD_EMMC_CMD;
wire          SD_DATA0_EMMC_DATA0;
wire          SD_DATA1_EMMC_DATA1;
wire          SD_DATA2_EMMC_DATA2;
wire          SD_DATA3_EMMC_DATA3;
wire          SD_POW_EMMC_DATA4_net_0;
wire          SD_VOLT_CMD_DIR_EMMC_DATA7_net_0;
wire          SD_VOLT_DIR_0_EMMC_UNUSED_net_0;
wire          SD_VOLT_DIR_1_3_EMMC_UNUSED_net_0;
wire          SD_VOLT_EN_EMMC_DATA6_net_0;
wire          SD_VOLT_SEL_EMMC_DATA5_net_0;
wire          SD_WP_EMMC_RSTN;
wire          SGMII_RX0_N;
wire          SGMII_RX0_P;
wire          SGMII_RX1_N;
wire          SGMII_RX1_P;
wire          SGMII_TX0_N_net_0;
wire          SGMII_TX0_P_net_0;
wire          SGMII_TX1_N_net_0;
wire          SGMII_TX1_P_net_0;
wire          SPI_1_CLK;
wire          SPI_1_DI;
wire          SPI_1_DO_net_0;
wire          SPI_1_SS0;
wire          SW1;
wire          SW1_OR_GPIO_2_28_Y;
wire          SW2;
wire          SW2_OR_GPIO_2_26_Y;
wire          SW3;
wire          SW3_OR_GPIO_2_27_Y;
wire          SW4;
wire          USB_CLK;
wire          USB_DATA0;
wire          USB_DATA1;
wire          USB_DATA2;
wire          USB_DATA3;
wire          USB_DATA4;
wire          USB_DATA5;
wire          USB_DATA6;
wire          USB_DATA7;
wire          USB_DIR;
wire          USB_NXT;
wire          USB_STP_net_0;
wire          USB_ULPI_RESET_net_0;
wire          CAN_0_TXBUS_M2F_net_1;
wire          CAN_0_TX_EBL_M2F_net_1;
wire          CAN_1_TXBUS_net_1;
wire          CAN_1_TX_EBL_N_net_1;
wire          CKE_net_1;
wire          CK_N_net_1;
wire          CK_net_1;
wire          CS_net_1;
wire          LED0_0_net_0;
wire          LED1_0_net_0;
wire          LED2_0_net_0;
wire          LED3_0_net_0;
wire          MAC_1_MDC_net_1;
wire          MMUART_0_TXD_M2F_net_1;
wire          MMUART_1_TXD_M2F_net_1;
wire          MMUART_2_TXD_M2F_net_1;
wire          MMUART_3_TXD_M2F_net_1;
wire          ODT_net_1;
wire          RESET_N_net_1;
wire          SD_CLK_EMMC_CLK_net_1;
wire          SD_POW_EMMC_DATA4_net_1;
wire          SD_VOLT_CMD_DIR_EMMC_DATA7_net_1;
wire          SD_VOLT_DIR_0_EMMC_UNUSED_net_1;
wire          SD_VOLT_DIR_1_3_EMMC_UNUSED_net_1;
wire          SD_VOLT_EN_EMMC_DATA6_net_1;
wire          SD_VOLT_SEL_EMMC_DATA5_net_1;
wire          SGMII_TX0_N_net_1;
wire          SGMII_TX0_P_net_1;
wire          SGMII_TX1_N_net_1;
wire          SGMII_TX1_P_net_1;
wire          SPI_1_DO_net_1;
wire          USB_STP_net_1;
wire          USB_ULPI_RESET_net_2;
wire          mBUS_UART_TX_net_1;
wire   [5:0]  CA_net_1;
wire   [3:0]  DM_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire          VCC_net;
wire   [3:0]  AXI4mmaster0_MASTER0_AWREGION_const_net_0;
wire   [3:0]  AXI4mmaster0_MASTER0_ARREGION_const_net_0;
wire   [7:0]  FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BID_const_net_0;
wire   [1:0]  FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BRESP_const_net_0;
wire   [7:0]  FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RID_const_net_0;
wire   [63:0] FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RDATA_const_net_0;
wire   [1:0]  FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RRESP_const_net_0;
wire   [31:0] FIC_3_APB_INITIATOR_FIC_3_APB_M_PRDATA_const_net_0;
wire   [3:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWID_const_net_0;
wire   [37:0] FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWADDR_const_net_0;
wire   [7:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWLEN_const_net_0;
wire   [2:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWSIZE_const_net_0;
wire   [1:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWBURST_const_net_0;
wire   [3:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWCACHE_const_net_0;
wire   [2:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWPROT_const_net_0;
wire   [3:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWQOS_const_net_0;
wire   [63:0] FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WDATA_const_net_0;
wire   [7:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WSTRB_const_net_0;
wire   [3:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARID_const_net_0;
wire   [37:0] FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARADDR_const_net_0;
wire   [7:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARLEN_const_net_0;
wire   [2:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARSIZE_const_net_0;
wire   [1:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARBURST_const_net_0;
wire   [3:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARCACHE_const_net_0;
wire   [2:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARPROT_const_net_0;
wire   [3:0]  FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARQOS_const_net_0;
wire   [3:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWID_const_net_0;
wire   [37:0] FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWADDR_const_net_0;
wire   [7:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWLEN_const_net_0;
wire   [2:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWSIZE_const_net_0;
wire   [1:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWBURST_const_net_0;
wire   [3:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWCACHE_const_net_0;
wire   [2:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWPROT_const_net_0;
wire   [3:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWQOS_const_net_0;
wire   [63:0] FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WDATA_const_net_0;
wire   [7:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WSTRB_const_net_0;
wire   [3:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARID_const_net_0;
wire   [37:0] FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARADDR_const_net_0;
wire   [7:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARLEN_const_net_0;
wire   [2:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARSIZE_const_net_0;
wire   [1:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARBURST_const_net_0;
wire   [3:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARCACHE_const_net_0;
wire   [2:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARPROT_const_net_0;
wire   [3:0]  FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARQOS_const_net_0;
wire   [3:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWID_const_net_0;
wire   [37:0] FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWADDR_const_net_0;
wire   [7:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWLEN_const_net_0;
wire   [2:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWSIZE_const_net_0;
wire   [1:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWBURST_const_net_0;
wire   [3:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWCACHE_const_net_0;
wire   [2:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWPROT_const_net_0;
wire   [3:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWQOS_const_net_0;
wire   [63:0] FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WDATA_const_net_0;
wire   [7:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WSTRB_const_net_0;
wire   [3:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARID_const_net_0;
wire   [37:0] FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARADDR_const_net_0;
wire   [7:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARLEN_const_net_0;
wire   [2:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARSIZE_const_net_0;
wire   [1:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARBURST_const_net_0;
wire   [3:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARCACHE_const_net_0;
wire   [2:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARPROT_const_net_0;
wire   [3:0]  FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARQOS_const_net_0;
//--------------------------------------------------------------------
// Inverted Nets
//--------------------------------------------------------------------
wire          USB_ULPI_RESET_net_1;
wire          USB_ULPI_RESET_OUT_PRE_INV0_0;
wire          A_IN_POST_INV1_0;
wire          A_IN_POST_INV2_0;
wire          A_IN_POST_INV3_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK;
wire   [1:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0;
wire   [0:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_0to0;
wire   [1:1]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_1to1;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK;
wire   [1:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0;
wire   [0:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_0to0;
wire   [1:1]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_1to1;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net                                             = 1'b0;
assign VCC_net                                             = 1'b1;
assign AXI4mmaster0_MASTER0_AWREGION_const_net_0           = 4'h0;
assign AXI4mmaster0_MASTER0_ARREGION_const_net_0           = 4'h0;
assign FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BID_const_net_0   = 8'h00;
assign FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BRESP_const_net_0 = 2'h0;
assign FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RID_const_net_0   = 8'h00;
assign FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RDATA_const_net_0 = 64'h0000000000000000;
assign FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RRESP_const_net_0 = 2'h0;
assign FIC_3_APB_INITIATOR_FIC_3_APB_M_PRDATA_const_net_0  = 32'h00000000;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWID_const_net_0     = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWADDR_const_net_0   = 38'h0000000000;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWLEN_const_net_0    = 8'h00;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWSIZE_const_net_0   = 3'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWBURST_const_net_0  = 2'h3;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWCACHE_const_net_0  = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWPROT_const_net_0   = 3'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWQOS_const_net_0    = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WDATA_const_net_0    = 64'h0000000000000000;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WSTRB_const_net_0    = 8'hFF;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARID_const_net_0     = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARADDR_const_net_0   = 38'h0000000000;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARLEN_const_net_0    = 8'h00;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARSIZE_const_net_0   = 3'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARBURST_const_net_0  = 2'h3;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARCACHE_const_net_0  = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARPROT_const_net_0   = 3'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARQOS_const_net_0    = 4'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWID_const_net_0     = 4'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWADDR_const_net_0   = 38'h0000000000;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWLEN_const_net_0    = 8'h00;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWSIZE_const_net_0   = 3'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWBURST_const_net_0  = 2'h3;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWCACHE_const_net_0  = 4'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWPROT_const_net_0   = 3'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWQOS_const_net_0    = 4'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WDATA_const_net_0    = 64'h0000000000000000;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WSTRB_const_net_0    = 8'hFF;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARID_const_net_0     = 4'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARADDR_const_net_0   = 38'h0000000000;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARLEN_const_net_0    = 8'h00;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARSIZE_const_net_0   = 3'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARBURST_const_net_0  = 2'h3;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARCACHE_const_net_0  = 4'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARPROT_const_net_0   = 3'h0;
assign FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARQOS_const_net_0    = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWID_const_net_0     = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWADDR_const_net_0   = 38'h0000000000;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWLEN_const_net_0    = 8'h00;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWSIZE_const_net_0   = 3'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWBURST_const_net_0  = 2'h3;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWCACHE_const_net_0  = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWPROT_const_net_0   = 3'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWQOS_const_net_0    = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WDATA_const_net_0    = 64'h0000000000000000;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WSTRB_const_net_0    = 8'hFF;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARID_const_net_0     = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARADDR_const_net_0   = 38'h0000000000;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARLEN_const_net_0    = 8'h00;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARSIZE_const_net_0   = 3'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARBURST_const_net_0  = 2'h3;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARCACHE_const_net_0  = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARPROT_const_net_0   = 3'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARQOS_const_net_0    = 4'h0;
//--------------------------------------------------------------------
// Inversions
//--------------------------------------------------------------------
assign USB_ULPI_RESET_net_1 = ~ USB_ULPI_RESET_OUT_PRE_INV0_0;
assign A_IN_POST_INV1_0     = ~ SW1;
assign A_IN_POST_INV2_0     = ~ SW2;
assign A_IN_POST_INV3_0     = ~ SW3;
//--------------------------------------------------------------------
// TieOff assignments
//--------------------------------------------------------------------
assign SDIO_SW_EN_N                      = 1'b0;
assign VSC_8662_CMODE3                   = 1'b0;
assign VSC_8662_CMODE4                   = 1'b0;
assign VSC_8662_CMODE5                   = 1'b0;
assign VSC_8662_CMODE6                   = 1'b1;
assign VSC_8662_CMODE7                   = 1'b0;
assign VSC_8662_OSCEN                    = 1'b1;
assign VSC_8662_PLLMODE                  = 1'b1;
assign VSC_8662_SRESET                   = 1'b1;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign CAN_0_TXBUS_M2F_net_1             = CAN_0_TXBUS_M2F_net_0;
assign CAN_0_TXBUS_M2F                   = CAN_0_TXBUS_M2F_net_1;
assign CAN_0_TX_EBL_M2F_net_1            = CAN_0_TX_EBL_M2F_net_0;
assign CAN_0_TX_EBL_M2F                  = CAN_0_TX_EBL_M2F_net_1;
assign CAN_1_TXBUS_net_1                 = CAN_1_TXBUS_net_0;
assign CAN_1_TXBUS                       = CAN_1_TXBUS_net_1;
assign CAN_1_TX_EBL_N_net_1              = CAN_1_TX_EBL_N_net_0;
assign CAN_1_TX_EBL_N                    = CAN_1_TX_EBL_N_net_1;
assign CKE_net_1                         = CKE_net_0;
assign CKE                               = CKE_net_1;
assign CK_N_net_1                        = CK_N_net_0;
assign CK_N                              = CK_N_net_1;
assign CK_net_1                          = CK_net_0;
assign CK                                = CK_net_1;
assign CS_net_1                          = CS_net_0;
assign CS                                = CS_net_1;
assign LED0_0_net_0                      = LED0_0;
assign LED0                              = LED0_0_net_0;
assign LED1_0_net_0                      = LED1_0;
assign LED1                              = LED1_0_net_0;
assign LED2_0_net_0                      = LED2_0;
assign LED2                              = LED2_0_net_0;
assign LED3_0_net_0                      = LED3_0;
assign LED3                              = LED3_0_net_0;
assign MAC_1_MDC_net_1                   = MAC_1_MDC_net_0;
assign MAC_1_MDC                         = MAC_1_MDC_net_1;
assign MMUART_0_TXD_M2F_net_1            = MMUART_0_TXD_M2F_net_0;
assign MMUART_0_TXD_M2F                  = MMUART_0_TXD_M2F_net_1;
assign MMUART_1_TXD_M2F_net_1            = MMUART_1_TXD_M2F_net_0;
assign MMUART_1_TXD_M2F                  = MMUART_1_TXD_M2F_net_1;
assign MMUART_2_TXD_M2F_net_1            = MMUART_2_TXD_M2F_net_0;
assign MMUART_2_TXD_M2F                  = MMUART_2_TXD_M2F_net_1;
assign MMUART_3_TXD_M2F_net_1            = MMUART_3_TXD_M2F_net_0;
assign MMUART_3_TXD_M2F                  = MMUART_3_TXD_M2F_net_1;
assign ODT_net_1                         = ODT_net_0;
assign ODT                               = ODT_net_1;
assign RESET_N_net_1                     = RESET_N_net_0;
assign RESET_N                           = RESET_N_net_1;
assign SD_CLK_EMMC_CLK_net_1             = SD_CLK_EMMC_CLK_net_0;
assign SD_CLK_EMMC_CLK                   = SD_CLK_EMMC_CLK_net_1;
assign SD_POW_EMMC_DATA4_net_1           = SD_POW_EMMC_DATA4_net_0;
assign SD_POW_EMMC_DATA4                 = SD_POW_EMMC_DATA4_net_1;
assign SD_VOLT_CMD_DIR_EMMC_DATA7_net_1  = SD_VOLT_CMD_DIR_EMMC_DATA7_net_0;
assign SD_VOLT_CMD_DIR_EMMC_DATA7        = SD_VOLT_CMD_DIR_EMMC_DATA7_net_1;
assign SD_VOLT_DIR_0_EMMC_UNUSED_net_1   = SD_VOLT_DIR_0_EMMC_UNUSED_net_0;
assign SD_VOLT_DIR_0_EMMC_UNUSED         = SD_VOLT_DIR_0_EMMC_UNUSED_net_1;
assign SD_VOLT_DIR_1_3_EMMC_UNUSED_net_1 = SD_VOLT_DIR_1_3_EMMC_UNUSED_net_0;
assign SD_VOLT_DIR_1_3_EMMC_UNUSED       = SD_VOLT_DIR_1_3_EMMC_UNUSED_net_1;
assign SD_VOLT_EN_EMMC_DATA6_net_1       = SD_VOLT_EN_EMMC_DATA6_net_0;
assign SD_VOLT_EN_EMMC_DATA6             = SD_VOLT_EN_EMMC_DATA6_net_1;
assign SD_VOLT_SEL_EMMC_DATA5_net_1      = SD_VOLT_SEL_EMMC_DATA5_net_0;
assign SD_VOLT_SEL_EMMC_DATA5            = SD_VOLT_SEL_EMMC_DATA5_net_1;
assign SGMII_TX0_N_net_1                 = SGMII_TX0_N_net_0;
assign SGMII_TX0_N                       = SGMII_TX0_N_net_1;
assign SGMII_TX0_P_net_1                 = SGMII_TX0_P_net_0;
assign SGMII_TX0_P                       = SGMII_TX0_P_net_1;
assign SGMII_TX1_N_net_1                 = SGMII_TX1_N_net_0;
assign SGMII_TX1_N                       = SGMII_TX1_N_net_1;
assign SGMII_TX1_P_net_1                 = SGMII_TX1_P_net_0;
assign SGMII_TX1_P                       = SGMII_TX1_P_net_1;
assign SPI_1_DO_net_1                    = SPI_1_DO_net_0;
assign SPI_1_DO                          = SPI_1_DO_net_1;
assign USB_STP_net_1                     = USB_STP_net_0;
assign USB_STP                           = USB_STP_net_1;
assign USB_ULPI_RESET_OUT_PRE_INV0_0     = USB_ULPI_RESET_net_0;
assign USB_ULPI_RESET                    = USB_ULPI_RESET_net_1;
assign USB_ULPI_RESET_net_2              = USB_ULPI_RESET_net_0;
assign VSC_8662_RESETN                   = USB_ULPI_RESET_net_2;
assign mBUS_UART_TX_net_1                = mBUS_UART_TX_net_0;
assign mBUS_UART_TX                      = mBUS_UART_TX_net_1;
assign CA_net_1                          = CA_net_0;
assign CA[5:0]                           = CA_net_1;
assign DM_net_1                          = DM_net_0;
assign DM[3:0]                           = DM_net_1;
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0 = { MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_1to1, MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_0to0 };
assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_0to0 = MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK;
assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_1to1 = 1'b0;

assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0 = { MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_1to1, MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_0to0 };
assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_0to0 = MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK;
assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_1to1 = 1'b0;

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CLOCKS_AND_RESETS
CLOCKS_AND_RESETS CLOCKS_AND_RESETS_inst_0(
        // Inputs
        .EXT_RST_N        ( USB_ULPI_RESET_net_0 ),
        .MSS_PLL_LOCKS    ( MSS_WRAPPER_1_MSS_DLL_LOCKS ),
        .REF_CLK_50MHz    ( REF_CLK_50MHz ),
        // Outputs
        .FIC_0_CLK        ( CLOCKS_AND_RESETS_FIC_0_CLK ),
        .FIC_1_CLK        ( CLOCKS_AND_RESETS_FIC_1_CLK ),
        .FIC_2_CLK        ( CLOCKS_AND_RESETS_FIC_2_CLK ),
        .FIC_3_CLK        ( CLOCKS_AND_RESETS_FIC_3_CLK ),
        .RESETN_FIC_0_CLK ( CLOCKS_AND_RESETS_RESETN_FIC_0_CLK ) 
        );

//--------FIC_0_PERIPHERALS
FIC_0_PERIPHERALS FIC_0_PERIPHERALS_1(
        // Inputs
        .ACLK                          ( CLOCKS_AND_RESETS_FIC_0_CLK ),
        .ARESETN                       ( CLOCKS_AND_RESETS_RESETN_FIC_0_CLK ),
        .AXI4mmaster0_MASTER0_AWVALID  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWVALID ),
        .AXI4mmaster0_MASTER0_WLAST    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WLAST ),
        .AXI4mmaster0_MASTER0_WVALID   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WVALID ),
        .AXI4mmaster0_MASTER0_BREADY   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BREADY ),
        .AXI4mmaster0_MASTER0_ARVALID  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARVALID ),
        .AXI4mmaster0_MASTER0_RREADY   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RREADY ),
        .AXI4mmaster0_MASTER0_AWID     ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWID ),
        .AXI4mmaster0_MASTER0_AWADDR   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWADDR ),
        .AXI4mmaster0_MASTER0_AWLEN    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLEN ),
        .AXI4mmaster0_MASTER0_AWSIZE   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWSIZE ),
        .AXI4mmaster0_MASTER0_AWBURST  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWBURST ),
        .AXI4mmaster0_MASTER0_AWLOCK   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0 ),
        .AXI4mmaster0_MASTER0_AWCACHE  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWCACHE ),
        .AXI4mmaster0_MASTER0_AWPROT   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWPROT ),
        .AXI4mmaster0_MASTER0_AWQOS    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWQOS ),
        .AXI4mmaster0_MASTER0_AWREGION ( AXI4mmaster0_MASTER0_AWREGION_const_net_0 ), // tied to 4'h0 from definition
        .AXI4mmaster0_MASTER0_WDATA    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WDATA ),
        .AXI4mmaster0_MASTER0_WSTRB    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WSTRB ),
        .AXI4mmaster0_MASTER0_ARID     ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARID ),
        .AXI4mmaster0_MASTER0_ARADDR   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARADDR ),
        .AXI4mmaster0_MASTER0_ARLEN    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLEN ),
        .AXI4mmaster0_MASTER0_ARSIZE   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARSIZE ),
        .AXI4mmaster0_MASTER0_ARBURST  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARBURST ),
        .AXI4mmaster0_MASTER0_ARLOCK   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0 ),
        .AXI4mmaster0_MASTER0_ARCACHE  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARCACHE ),
        .AXI4mmaster0_MASTER0_ARPROT   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARPROT ),
        .AXI4mmaster0_MASTER0_ARQOS    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARQOS ),
        .AXI4mmaster0_MASTER0_ARREGION ( AXI4mmaster0_MASTER0_ARREGION_const_net_0 ), // tied to 4'h0 from definition
        .AXI4mmaster0_MASTER0_AWUSER   ( GND_net ), // tied to 1'b0 from definition
        .AXI4mmaster0_MASTER0_WUSER    ( GND_net ), // tied to 1'b0 from definition
        .AXI4mmaster0_MASTER0_ARUSER   ( GND_net ), // tied to 1'b0 from definition
        // Outputs
        .core_poly_irq                 ( FIC_0_PERIPHERALS_1_core_poly_irq ),
        .AXI4mmaster0_MASTER0_AWREADY  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWREADY ),
        .AXI4mmaster0_MASTER0_WREADY   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WREADY ),
        .AXI4mmaster0_MASTER0_BVALID   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BVALID ),
        .AXI4mmaster0_MASTER0_ARREADY  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARREADY ),
        .AXI4mmaster0_MASTER0_RLAST    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RLAST ),
        .AXI4mmaster0_MASTER0_RVALID   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RVALID ),
        .AXI4mmaster0_MASTER0_BID      ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BID ),
        .AXI4mmaster0_MASTER0_BRESP    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BRESP ),
        .AXI4mmaster0_MASTER0_RID      ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RID ),
        .AXI4mmaster0_MASTER0_RDATA    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RDATA ),
        .AXI4mmaster0_MASTER0_RRESP    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RRESP ),
        .AXI4mmaster0_MASTER0_BUSER    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BUSER ),
        .AXI4mmaster0_MASTER0_RUSER    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RUSER ) 
        );

//--------MSS_WRAPPER
MSS_WRAPPER MSS_WRAPPER_1(
        // Inputs
        .CAN_0_RXBUS_F2M                           ( CAN_0_RXBUS_F2M ),
        .CAN_1_RXBUS                               ( CAN_1_RXBUS ),
        .FIC_0_ACLK                                ( CLOCKS_AND_RESETS_FIC_0_CLK ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARREADY ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARREADY ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWREADY ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWREADY ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_BVALID  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BVALID ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_RLAST   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RLAST ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_RVALID  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RVALID ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_WREADY  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WREADY ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARLOCK     ( GND_net ), // tied to 1'b0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARVALID    ( GND_net ), // tied to 1'b0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWLOCK     ( GND_net ), // tied to 1'b0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWVALID    ( GND_net ), // tied to 1'b0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_BREADY     ( GND_net ), // tied to 1'b0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RREADY     ( GND_net ), // tied to 1'b0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WLAST      ( GND_net ), // tied to 1'b0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WVALID     ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_ACLK                                ( CLOCKS_AND_RESETS_FIC_1_CLK ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARREADY ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWREADY ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BVALID  ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RLAST   ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RVALID  ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WREADY  ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARLOCK     ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARVALID    ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWLOCK     ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWVALID    ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_BREADY     ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RREADY     ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WLAST      ( GND_net ), // tied to 1'b0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WVALID     ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_ACLK                                ( CLOCKS_AND_RESETS_FIC_2_CLK ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARLOCK     ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARVALID    ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWLOCK     ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWVALID    ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_BREADY     ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RREADY     ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WLAST      ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WVALID     ( GND_net ), // tied to 1'b0 from definition
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PREADY    ( VCC_net ), // tied to 1'b1 from definition
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PSLVERR   ( GND_net ), // tied to 1'b0 from definition
        .FIC_3_PCLK                                ( CLOCKS_AND_RESETS_FIC_3_CLK ),
        .GPIO_2_F2M_30                             ( SW2_OR_GPIO_2_26_Y ),
        .GPIO_2_F2M_31                             ( SW3_OR_GPIO_2_27_Y ),
        .MMUART_0_RXD_F2M                          ( MMUART_0_RXD_F2M ),
        .MMUART_1_RXD_F2M                          ( MMUART_1_RXD_F2M ),
        .MMUART_2_RXD_F2M                          ( MMUART_2_RXD_F2M ),
        .MMUART_3_RXD_F2M                          ( MMUART_3_RXD_F2M ),
        .MMUART_4_RXD_F2M                          ( mBUS_UART_RX ),
        .MSS_INT_F2M_0                             ( SW1_OR_GPIO_2_28_Y ),
        .MSS_INT_F2M_2                             ( FIC_0_PERIPHERALS_1_core_poly_irq ),
        .MSS_INT_F2M_3                             ( mBUS_INT ),
        .MSS_RESET_N_F2M                           ( SW4 ),
        .REFCLK_N                                  ( REFCLK_N ),
        .REFCLK                                    ( REFCLK ),
        .SD_CD_EMMC_STRB                           ( SD_CD_EMMC_STRB ),
        .SD_WP_EMMC_RSTN                           ( SD_WP_EMMC_RSTN ),
        .SGMII_RX0_N                               ( SGMII_RX0_N ),
        .SGMII_RX0_P                               ( SGMII_RX0_P ),
        .SGMII_RX1_N                               ( SGMII_RX1_N ),
        .SGMII_RX1_P                               ( SGMII_RX1_P ),
        .SPI_1_DI                                  ( SPI_1_DI ),
        .USB_CLK                                   ( USB_CLK ),
        .USB_DIR                                   ( USB_DIR ),
        .USB_NXT                                   ( USB_NXT ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_BID     ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BID ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_BRESP   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BRESP ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_RDATA   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RDATA ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_RID     ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RID ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_RRESP   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RRESP ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARADDR     ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARADDR_const_net_0 ), // tied to 38'h0000000000 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARBURST    ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARBURST_const_net_0 ), // tied to 2'h3 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARCACHE    ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARCACHE_const_net_0 ), // tied to 4'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARID       ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARID_const_net_0 ), // tied to 4'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARLEN      ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARLEN_const_net_0 ), // tied to 8'h00 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARPROT     ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARPROT_const_net_0 ), // tied to 3'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARQOS      ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARQOS_const_net_0 ), // tied to 4'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARSIZE     ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARSIZE_const_net_0 ), // tied to 3'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWADDR     ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWADDR_const_net_0 ), // tied to 38'h0000000000 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWBURST    ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWBURST_const_net_0 ), // tied to 2'h3 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWCACHE    ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWCACHE_const_net_0 ), // tied to 4'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWID       ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWID_const_net_0 ), // tied to 4'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWLEN      ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWLEN_const_net_0 ), // tied to 8'h00 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWPROT     ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWPROT_const_net_0 ), // tied to 3'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWQOS      ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWQOS_const_net_0 ), // tied to 4'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWSIZE     ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWSIZE_const_net_0 ), // tied to 3'h0 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WDATA      ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WDATA_const_net_0 ), // tied to 64'h0000000000000000 from definition
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WSTRB      ( FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WSTRB_const_net_0 ), // tied to 8'hFF from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BID     ( FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BID_const_net_0 ), // tied to 8'h00 from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BRESP   ( FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BRESP_const_net_0 ), // tied to 2'h0 from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RDATA   ( FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RDATA_const_net_0 ), // tied to 64'h0000000000000000 from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RID     ( FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RID_const_net_0 ), // tied to 8'h00 from definition
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RRESP   ( FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RRESP_const_net_0 ), // tied to 2'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARADDR     ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARADDR_const_net_0 ), // tied to 38'h0000000000 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARBURST    ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARBURST_const_net_0 ), // tied to 2'h3 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARCACHE    ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARCACHE_const_net_0 ), // tied to 4'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARID       ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARID_const_net_0 ), // tied to 4'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARLEN      ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARLEN_const_net_0 ), // tied to 8'h00 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARPROT     ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARPROT_const_net_0 ), // tied to 3'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARQOS      ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARQOS_const_net_0 ), // tied to 4'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARSIZE     ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARSIZE_const_net_0 ), // tied to 3'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWADDR     ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWADDR_const_net_0 ), // tied to 38'h0000000000 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWBURST    ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWBURST_const_net_0 ), // tied to 2'h3 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWCACHE    ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWCACHE_const_net_0 ), // tied to 4'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWID       ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWID_const_net_0 ), // tied to 4'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWLEN      ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWLEN_const_net_0 ), // tied to 8'h00 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWPROT     ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWPROT_const_net_0 ), // tied to 3'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWQOS      ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWQOS_const_net_0 ), // tied to 4'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWSIZE     ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWSIZE_const_net_0 ), // tied to 3'h0 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WDATA      ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WDATA_const_net_0 ), // tied to 64'h0000000000000000 from definition
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WSTRB      ( FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WSTRB_const_net_0 ), // tied to 8'hFF from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARADDR     ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARADDR_const_net_0 ), // tied to 38'h0000000000 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARBURST    ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARBURST_const_net_0 ), // tied to 2'h3 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARCACHE    ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARCACHE_const_net_0 ), // tied to 4'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARID       ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARID_const_net_0 ), // tied to 4'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARLEN      ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARLEN_const_net_0 ), // tied to 8'h00 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARPROT     ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARPROT_const_net_0 ), // tied to 3'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARQOS      ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARQOS_const_net_0 ), // tied to 4'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARSIZE     ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARSIZE_const_net_0 ), // tied to 3'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWADDR     ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWADDR_const_net_0 ), // tied to 38'h0000000000 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWBURST    ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWBURST_const_net_0 ), // tied to 2'h3 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWCACHE    ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWCACHE_const_net_0 ), // tied to 4'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWID       ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWID_const_net_0 ), // tied to 4'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWLEN      ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWLEN_const_net_0 ), // tied to 8'h00 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWPROT     ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWPROT_const_net_0 ), // tied to 3'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWQOS      ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWQOS_const_net_0 ), // tied to 4'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWSIZE     ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWSIZE_const_net_0 ), // tied to 3'h0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WDATA      ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WDATA_const_net_0 ), // tied to 64'h0000000000000000 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WSTRB      ( FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WSTRB_const_net_0 ), // tied to 8'hFF from definition
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PRDATA    ( FIC_3_APB_INITIATOR_FIC_3_APB_M_PRDATA_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .CAN_0_TXBUS_M2F                           ( CAN_0_TXBUS_M2F_net_0 ),
        .CAN_0_TX_EBL_M2F                          ( CAN_0_TX_EBL_M2F_net_0 ),
        .CAN_1_TXBUS                               ( CAN_1_TXBUS_net_0 ),
        .CAN_1_TX_EBL_N                            ( CAN_1_TX_EBL_N_net_0 ),
        .CKE                                       ( CKE_net_0 ),
        .CK_N                                      ( CK_N_net_0 ),
        .CK                                        ( CK_net_0 ),
        .CS                                        ( CS_net_0 ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARLOCK  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARVALID ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARVALID ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWLOCK  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWVALID ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWVALID ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_BREADY  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_BREADY ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_RREADY  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_RREADY ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_WLAST   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WLAST ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_WVALID  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WVALID ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARREADY    (  ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWREADY    (  ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_BVALID     (  ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RLAST      (  ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RVALID     (  ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WREADY     (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARLOCK  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARVALID (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWLOCK  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWVALID (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BREADY  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RREADY  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WLAST   (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WVALID  (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARREADY    (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWREADY    (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_BVALID     (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RLAST      (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RVALID     (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WREADY     (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARREADY    (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWREADY    (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_BVALID     (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RLAST      (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RVALID     (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WREADY     (  ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PENABLE   (  ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PSEL      (  ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PWRITE    (  ),
        .GPIO_2_M2F_16                             ( LED0_0 ),
        .GPIO_2_M2F_17                             ( LED1_0 ),
        .GPIO_2_M2F_18                             ( LED2_0 ),
        .GPIO_2_M2F_19                             ( LED3_0 ),
        .GPIO_2_M2F_26                             ( MSS_WRAPPER_1_GPIO_2_M2F_26 ),
        .GPIO_2_M2F_27                             ( MSS_WRAPPER_1_GPIO_2_M2F_27 ),
        .GPIO_2_M2F_28                             ( MSS_WRAPPER_1_GPIO_2_M2F_28 ),
        .MAC_1_MDC                                 ( MAC_1_MDC_net_0 ),
        .MMUART_0_TXD_M2F                          ( MMUART_0_TXD_M2F_net_0 ),
        .MMUART_1_TXD_M2F                          ( MMUART_1_TXD_M2F_net_0 ),
        .MMUART_2_TXD_M2F                          ( MMUART_2_TXD_M2F_net_0 ),
        .MMUART_3_TXD_M2F                          ( MMUART_3_TXD_M2F_net_0 ),
        .MMUART_4_TXD_M2F                          ( mBUS_UART_TX_net_0 ),
        .MSS_DLL_LOCKS                             ( MSS_WRAPPER_1_MSS_DLL_LOCKS ),
        .MSS_RESET_N_M2F                           ( USB_ULPI_RESET_net_0 ),
        .ODT                                       ( ODT_net_0 ),
        .RESET_N                                   ( RESET_N_net_0 ),
        .SD_CLK_EMMC_CLK                           ( SD_CLK_EMMC_CLK_net_0 ),
        .SD_POW_EMMC_DATA4                         ( SD_POW_EMMC_DATA4_net_0 ),
        .SD_VOLT_CMD_DIR_EMMC_DATA7                ( SD_VOLT_CMD_DIR_EMMC_DATA7_net_0 ),
        .SD_VOLT_DIR_0_EMMC_UNUSED                 ( SD_VOLT_DIR_0_EMMC_UNUSED_net_0 ),
        .SD_VOLT_DIR_1_3_EMMC_UNUSED               ( SD_VOLT_DIR_1_3_EMMC_UNUSED_net_0 ),
        .SD_VOLT_EN_EMMC_DATA6                     ( SD_VOLT_EN_EMMC_DATA6_net_0 ),
        .SD_VOLT_SEL_EMMC_DATA5                    ( SD_VOLT_SEL_EMMC_DATA5_net_0 ),
        .SGMII_TX0_N                               ( SGMII_TX0_N_net_0 ),
        .SGMII_TX0_P                               ( SGMII_TX0_P_net_0 ),
        .SGMII_TX1_N                               ( SGMII_TX1_N_net_0 ),
        .SGMII_TX1_P                               ( SGMII_TX1_P_net_0 ),
        .SPI_1_DO                                  ( SPI_1_DO_net_0 ),
        .USB_STP                                   ( USB_STP_net_0 ),
        .CA                                        ( CA_net_0 ),
        .DM                                        ( DM_net_0 ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARADDR  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARADDR ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARBURST ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARBURST ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARCACHE ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARCACHE ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARID    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARID ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARLEN   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLEN ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARPROT  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARPROT ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARQOS   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARQOS ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_ARSIZE  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARSIZE ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWADDR  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWADDR ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWBURST ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWBURST ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWCACHE ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWCACHE ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWID    ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWID ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWLEN   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLEN ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWPROT  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWPROT ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWQOS   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWQOS ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_AWSIZE  ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWSIZE ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_WDATA   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WDATA ),
        .FIC_0_AXI4_INITIATOR_FIC_0_AXI4_M_WSTRB   ( MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_WSTRB ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_BID        (  ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_BRESP      (  ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RDATA      (  ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RID        (  ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RRESP      (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARADDR  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARBURST (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARCACHE (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARID    (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARLEN   (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARPROT  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARQOS   (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARSIZE  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWADDR  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWBURST (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWCACHE (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWID    (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWLEN   (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWPROT  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWQOS   (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWSIZE  (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WDATA   (  ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WSTRB   (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_BID        (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_BRESP      (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RDATA      (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RID        (  ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RRESP      (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_BID        (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_BRESP      (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RDATA      (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RID        (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RRESP      (  ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PADDR     (  ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PWDATA    (  ),
        // Inouts
        .I2C_1_SCL                                 ( I2C_1_SCL ),
        .I2C_1_SDA                                 ( I2C_1_SDA ),
        .MAC_1_MDIO                                ( MAC_1_MDIO ),
        .QSPI_CLK                                  ( QSPI_CLK ),
        .QSPI_DATA_0                               ( QSPI_DATA_0 ),
        .QSPI_DATA_1                               ( QSPI_DATA_1 ),
        .QSPI_DATA_2                               ( QSPI_DATA_2 ),
        .QSPI_DATA_3                               ( QSPI_DATA_3 ),
        .QSPI_SEL                                  ( QSPI_SEL ),
        .RPi_GPIO12                                ( RPi_GPIO12 ),
        .RPi_GPIO13                                ( RPi_GPIO13 ),
        .RPi_GPIO16                                ( RPi_GPIO16 ),
        .RPi_GPIO17                                ( RPi_GPIO17 ),
        .RPi_GPIO19                                ( RPi_GPIO19 ),
        .RPi_GPIO20                                ( RPi_GPIO20 ),
        .RPi_GPIO21                                ( RPi_GPIO21 ),
        .RPi_GPIO22                                ( RPi_GPIO22 ),
        .RPi_GPIO23                                ( RPi_GPIO23 ),
        .RPi_GPIO24                                ( RPi_GPIO24 ),
        .RPi_GPIO25                                ( RPi_GPIO25 ),
        .RPi_GPIO26                                ( RPi_GPIO26 ),
        .RPi_GPIO27                                ( RPi_GPIO27 ),
        .SD_CMD_EMMC_CMD                           ( SD_CMD_EMMC_CMD ),
        .SD_DATA0_EMMC_DATA0                       ( SD_DATA0_EMMC_DATA0 ),
        .SD_DATA1_EMMC_DATA1                       ( SD_DATA1_EMMC_DATA1 ),
        .SD_DATA2_EMMC_DATA2                       ( SD_DATA2_EMMC_DATA2 ),
        .SD_DATA3_EMMC_DATA3                       ( SD_DATA3_EMMC_DATA3 ),
        .SPI_1_CLK                                 ( SPI_1_CLK ),
        .SPI_1_SS0                                 ( SPI_1_SS0 ),
        .USB_DATA0                                 ( USB_DATA0 ),
        .USB_DATA1                                 ( USB_DATA1 ),
        .USB_DATA2                                 ( USB_DATA2 ),
        .USB_DATA3                                 ( USB_DATA3 ),
        .USB_DATA4                                 ( USB_DATA4 ),
        .USB_DATA5                                 ( USB_DATA5 ),
        .USB_DATA6                                 ( USB_DATA6 ),
        .USB_DATA7                                 ( USB_DATA7 ),
        .mBUS_I2C_SCL                              ( mBUS_I2C_SCL ),
        .mBUS_I2C_SDA                              ( mBUS_I2C_SDA ),
        .DQS_N                                     ( DQS_N ),
        .DQS                                       ( DQS ),
        .DQ                                        ( DQ ) 
        );

//--------OR2
OR2 SW1_OR_GPIO_2_28(
        // Inputs
        .A ( A_IN_POST_INV1_0 ),
        .B ( MSS_WRAPPER_1_GPIO_2_M2F_28 ),
        // Outputs
        .Y ( SW1_OR_GPIO_2_28_Y ) 
        );

//--------OR2
OR2 SW2_OR_GPIO_2_26(
        // Inputs
        .A ( A_IN_POST_INV2_0 ),
        .B ( MSS_WRAPPER_1_GPIO_2_M2F_26 ),
        // Outputs
        .Y ( SW2_OR_GPIO_2_26_Y ) 
        );

//--------OR2
OR2 SW3_OR_GPIO_2_27(
        // Inputs
        .A ( A_IN_POST_INV3_0 ),
        .B ( MSS_WRAPPER_1_GPIO_2_M2F_27 ),
        // Outputs
        .Y ( SW3_OR_GPIO_2_27_Y ) 
        );


endmodule
