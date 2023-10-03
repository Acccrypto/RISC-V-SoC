//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Apr 11 09:22:51 2023
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
    PCIESS_LANE_RXD0_N,
    PCIESS_LANE_RXD0_P,
    PCIESS_LANE_RXD1_N,
    PCIESS_LANE_RXD1_P,
    PCIESS_LANE_RXD2_N,
    PCIESS_LANE_RXD2_P,
    PCIESS_LANE_RXD3_N,
    PCIESS_LANE_RXD3_P,
    REFCLK,
    REFCLK_N,
    REF_CLK_50MHz,
    REF_CLK_PAD_N,
    REF_CLK_PAD_P,
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
    PCIESS_LANE_TXD0_N,
    PCIESS_LANE_TXD0_P,
    PCIESS_LANE_TXD1_N,
    PCIESS_LANE_TXD1_P,
    PCIESS_LANE_TXD2_N,
    PCIESS_LANE_TXD2_P,
    PCIESS_LANE_TXD3_N,
    PCIESS_LANE_TXD3_P,
    PCIE_1_PERST_N,
    RESET_N,
    SDIO_SW_EN_N,
    SDIO_SW_SEL0,
    SDIO_SW_SEL1,
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
input         PCIESS_LANE_RXD0_N;
input         PCIESS_LANE_RXD0_P;
input         PCIESS_LANE_RXD1_N;
input         PCIESS_LANE_RXD1_P;
input         PCIESS_LANE_RXD2_N;
input         PCIESS_LANE_RXD2_P;
input         PCIESS_LANE_RXD3_N;
input         PCIESS_LANE_RXD3_P;
input         REFCLK;
input         REFCLK_N;
input         REF_CLK_50MHz;
input         REF_CLK_PAD_N;
input         REF_CLK_PAD_P;
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
output        PCIESS_LANE_TXD0_N;
output        PCIESS_LANE_TXD0_P;
output        PCIESS_LANE_TXD1_N;
output        PCIESS_LANE_TXD1_P;
output        PCIESS_LANE_TXD2_N;
output        PCIESS_LANE_TXD2_P;
output        PCIESS_LANE_TXD3_N;
output        PCIESS_LANE_TXD3_P;
output        PCIE_1_PERST_N;
output        RESET_N;
output        SDIO_SW_EN_N;
output        SDIO_SW_SEL0;
output        SDIO_SW_SEL1;
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
wire          CLOCKS_AND_RESETS_CLKS_TO_XCVR_BIT_CLK;
wire          CLOCKS_AND_RESETS_CLKS_TO_XCVR_LOCK;
wire          CLOCKS_AND_RESETS_CLKS_TO_XCVR_REF_CLK_TO_LANE;
wire          CLOCKS_AND_RESETS_FIC_0_CLK;
wire          CLOCKS_AND_RESETS_FIC_1_CLK;
wire          CLOCKS_AND_RESETS_FIC_2_CLK;
wire          CLOCKS_AND_RESETS_FIC_3_CLK;
wire          CLOCKS_AND_RESETS_PCIe_CLK_125MHz;
wire          CLOCKS_AND_RESETS_PCIE_INIT_DONE;
wire          CLOCKS_AND_RESETS_PCIe_REFERENCE_CLK;
wire          CLOCKS_AND_RESETS_RESETN_FIC_0_CLK;
wire          CLOCKS_AND_RESETS_RESETN_FIC_1_CLK;
wire          CLOCKS_AND_RESETS_RESETN_FIC_3_CLK;
wire          CS_net_0;
wire   [3:0]  DM_net_0;
wire   [31:0] DQ;
wire   [3:0]  DQS;
wire   [3:0]  DQS_N;
wire          FIC_0_PERIPHERALS_1_AXI4mslave0_ARREADY;
wire          FIC_0_PERIPHERALS_1_AXI4mslave0_AWREADY;
wire   [3:0]  FIC_0_PERIPHERALS_1_AXI4mslave0_BID;
wire   [1:0]  FIC_0_PERIPHERALS_1_AXI4mslave0_BRESP;
wire          FIC_0_PERIPHERALS_1_AXI4mslave0_BVALID;
wire   [63:0] FIC_0_PERIPHERALS_1_AXI4mslave0_RDATA;
wire   [3:0]  FIC_0_PERIPHERALS_1_AXI4mslave0_RID;
wire          FIC_0_PERIPHERALS_1_AXI4mslave0_RLAST;
wire   [1:0]  FIC_0_PERIPHERALS_1_AXI4mslave0_RRESP;
wire          FIC_0_PERIPHERALS_1_AXI4mslave0_RVALID;
wire          FIC_0_PERIPHERALS_1_AXI4mslave0_WREADY;
wire          FIC_0_PERIPHERALS_1_core_poly_irq;
wire   [37:0] FIC_1_PERIPHERALS_1_AXI4mslave0_ARADDR;
wire   [1:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARBURST;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARCACHE;
wire   [7:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARLEN;
wire   [2:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARPROT;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARQOS;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_ARREADY;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARREGION;
wire   [2:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARSIZE;
wire   [0:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARUSER;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_ARVALID;
wire   [37:0] FIC_1_PERIPHERALS_1_AXI4mslave0_AWADDR;
wire   [1:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWBURST;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWCACHE;
wire   [7:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWLEN;
wire   [2:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWPROT;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWQOS;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_AWREADY;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWREGION;
wire   [2:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWSIZE;
wire   [0:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWUSER;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_AWVALID;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_BREADY;
wire   [1:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_BRESP;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_BVALID;
wire   [63:0] FIC_1_PERIPHERALS_1_AXI4mslave0_RDATA;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_RLAST;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_RREADY;
wire   [1:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_RRESP;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_RVALID;
wire   [63:0] FIC_1_PERIPHERALS_1_AXI4mslave0_WDATA;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_WLAST;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_WREADY;
wire   [7:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_WSTRB;
wire   [0:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_WUSER;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_WVALID;
wire          FIC_1_PERIPHERALS_1_PCIe_IRQ;
wire          FIC_3_PERIPHERALS_1_GPIO_OUT_0;
wire          FIC_3_PERIPHERALS_1_GPIO_OUT_1;
wire          FIC_3_PERIPHERALS_1_GPIO_OUT_2;
wire          FIC_3_PERIPHERALS_1_GPIO_OUT_3;
wire          FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_E51_IRQ;
wire          FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_1_IRQ;
wire          FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_2_IRQ;
wire          FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_3_IRQ;
wire          FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_4_IRQ;
wire          FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_ARST_N;
wire          FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_CLK;
wire   [10:0] FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_CTRL;
wire          FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_INTERRUPT;
wire   [32:0] FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_RDATA;
wire   [32:0] FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_WDATA;
wire   [10:0] FIC_3_PERIPHERALS_1_Q0_LANE1_DRI_DRI_CTRL;
wire          FIC_3_PERIPHERALS_1_Q0_LANE1_DRI_DRI_INTERRUPT;
wire   [32:0] FIC_3_PERIPHERALS_1_Q0_LANE1_DRI_DRI_RDATA;
wire   [10:0] FIC_3_PERIPHERALS_1_Q0_LANE2_DRI_DRI_CTRL;
wire          FIC_3_PERIPHERALS_1_Q0_LANE2_DRI_DRI_INTERRUPT;
wire   [32:0] FIC_3_PERIPHERALS_1_Q0_LANE2_DRI_DRI_RDATA;
wire   [10:0] FIC_3_PERIPHERALS_1_Q0_LANE3_DRI_DRI_CTRL;
wire          FIC_3_PERIPHERALS_1_Q0_LANE3_DRI_DRI_INTERRUPT;
wire   [32:0] FIC_3_PERIPHERALS_1_Q0_LANE3_DRI_DRI_RDATA;
wire          I2C_1_SCL;
wire          I2C_1_SDA;
wire          LED0_net_0;
wire          LED1_net_0;
wire          LED2_net_0;
wire          LED3_net_0;
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
wire   [37:0] MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARADDR;
wire   [1:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARBURST;
wire   [3:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARCACHE;
wire   [7:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARID;
wire   [7:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLEN;
wire   [2:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARPROT;
wire   [3:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARQOS;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARREADY;
wire   [2:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARSIZE;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARVALID;
wire   [37:0] MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWADDR;
wire   [1:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWBURST;
wire   [3:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWCACHE;
wire   [7:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWID;
wire   [7:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLEN;
wire   [2:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWPROT;
wire   [3:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWQOS;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWREADY;
wire   [2:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWSIZE;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWVALID;
wire   [7:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BID;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BREADY;
wire   [1:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BRESP;
wire   [0:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BUSER;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BVALID;
wire   [63:0] MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RDATA;
wire   [7:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RID;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RLAST;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RREADY;
wire   [1:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RRESP;
wire   [0:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RUSER;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RVALID;
wire   [63:0] MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WDATA;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WLAST;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WREADY;
wire   [7:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WSTRB;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WVALID;
wire          MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PENABLE;
wire   [31:0] MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PRDATA;
wire          MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PREADY;
wire          MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PSELx;
wire          MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PSLVERR;
wire   [31:0] MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PWDATA;
wire          MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PWRITE;
wire   [3:0]  MSS_WRAPPER_1_FIC_3_APB_M_PSTRB;
wire          MSS_WRAPPER_1_GPIO_2_M2F_16;
wire          MSS_WRAPPER_1_GPIO_2_M2F_17;
wire          MSS_WRAPPER_1_GPIO_2_M2F_18;
wire          MSS_WRAPPER_1_GPIO_2_M2F_19;
wire          MSS_WRAPPER_1_GPIO_2_M2F_26;
wire          MSS_WRAPPER_1_GPIO_2_M2F_27;
wire          MSS_WRAPPER_1_GPIO_2_M2F_28;
wire          MSS_WRAPPER_1_MSS_DLL_LOCKS;
wire          ODT_net_0;
wire          PCIE_1_PERST_N_net_0;
wire          PCIESS_LANE_RXD0_N;
wire          PCIESS_LANE_RXD0_P;
wire          PCIESS_LANE_RXD1_N;
wire          PCIESS_LANE_RXD1_P;
wire          PCIESS_LANE_RXD2_N;
wire          PCIESS_LANE_RXD2_P;
wire          PCIESS_LANE_RXD3_N;
wire          PCIESS_LANE_RXD3_P;
wire          PCIESS_LANE_TXD0_N_net_0;
wire          PCIESS_LANE_TXD0_P_net_0;
wire          PCIESS_LANE_TXD1_N_net_0;
wire          PCIESS_LANE_TXD1_P_net_0;
wire          PCIESS_LANE_TXD2_N_net_0;
wire          PCIESS_LANE_TXD2_P_net_0;
wire          PCIESS_LANE_TXD3_N_net_0;
wire          PCIESS_LANE_TXD3_P_net_0;
wire          QSPI_CLK;
wire          QSPI_DATA_0;
wire          QSPI_DATA_1;
wire          QSPI_DATA_2;
wire          QSPI_DATA_3;
wire          QSPI_SEL;
wire          REF_CLK_50MHz;
wire          REF_CLK_PAD_N;
wire          REF_CLK_PAD_P;
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
wire          SDIO_SW_SEL1_net_0;
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
wire          LED0_net_1;
wire          LED1_net_1;
wire          LED2_net_1;
wire          LED3_net_1;
wire          MAC_1_MDC_net_1;
wire          MMUART_0_TXD_M2F_net_1;
wire          MMUART_1_TXD_M2F_net_1;
wire          MMUART_2_TXD_M2F_net_1;
wire          MMUART_3_TXD_M2F_net_1;
wire          ODT_net_1;
wire          PCIESS_LANE_TXD0_N_net_1;
wire          PCIESS_LANE_TXD0_P_net_1;
wire          PCIESS_LANE_TXD1_N_net_1;
wire          PCIESS_LANE_TXD1_P_net_1;
wire          PCIESS_LANE_TXD2_N_net_1;
wire          PCIESS_LANE_TXD2_P_net_1;
wire          PCIESS_LANE_TXD3_N_net_1;
wire          PCIESS_LANE_TXD3_P_net_1;
wire          PCIE_1_PERST_N_net_1;
wire          RESET_N_net_1;
wire          SDIO_SW_SEL1_net_1;
wire          SDIO_SW_SEL1_net_2;
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
wire   [3:0]  AXI4mmaster0_MASTER0_AWREGION_const_net_1;
wire   [3:0]  AXI4mmaster0_MASTER0_ARREGION_const_net_1;
wire   [25:0] PCIE_APB_SLAVE_APB_S_PADDR_const_net_0;
wire   [31:0] PCIE_APB_SLAVE_APB_S_PWDATA_const_net_0;
wire   [32:0] PLL0_SW_DRI_RDATA_const_net_0;
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
wire   [4:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARID;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARID_0;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARID_0_3to0;
wire   [1:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARLOCK;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_ARLOCK_0;
wire   [0:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_ARLOCK_0_0to0;
wire   [4:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWID;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWID_0;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWID_0_3to0;
wire   [1:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWLOCK;
wire          FIC_1_PERIPHERALS_1_AXI4mslave0_AWLOCK_0;
wire   [0:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_AWLOCK_0_0to0;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_BID;
wire   [4:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_BID_0;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_BID_0_3to0;
wire   [4:4]  FIC_1_PERIPHERALS_1_AXI4mslave0_BID_0_4to4;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_RID;
wire   [4:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_RID_0;
wire   [3:0]  FIC_1_PERIPHERALS_1_AXI4mslave0_RID_0_3to0;
wire   [4:4]  FIC_1_PERIPHERALS_1_AXI4mslave0_RID_0_4to4;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK;
wire   [1:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0;
wire   [0:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_0to0;
wire   [1:1]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_1to1;
wire          MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK;
wire   [1:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0;
wire   [0:0]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_0to0;
wire   [1:1]  MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_1to1;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK;
wire   [1:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK_0;
wire   [0:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK_0_0to0;
wire   [1:1]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK_0_1to1;
wire          MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK;
wire   [1:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK_0;
wire   [0:0]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK_0_0to0;
wire   [1:1]  MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK_0_1to1;
wire   [28:0] MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR;
wire   [31:0] MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR_0;
wire   [28:0] MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR_0_28to0;
wire   [31:29]MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR_0_31to29;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net                                            = 1'b0;
assign VCC_net                                            = 1'b1;
assign AXI4mmaster0_MASTER0_AWREGION_const_net_0          = 4'h0;
assign AXI4mmaster0_MASTER0_ARREGION_const_net_0          = 4'h0;
assign AXI4mmaster0_MASTER0_AWREGION_const_net_1          = 4'h0;
assign AXI4mmaster0_MASTER0_ARREGION_const_net_1          = 4'h0;
assign PCIE_APB_SLAVE_APB_S_PADDR_const_net_0             = 26'h0000000;
assign PCIE_APB_SLAVE_APB_S_PWDATA_const_net_0            = 32'h00000000;
assign PLL0_SW_DRI_RDATA_const_net_0                      = 33'h000000000;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWID_const_net_0    = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWADDR_const_net_0  = 38'h0000000000;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWLEN_const_net_0   = 8'h00;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWSIZE_const_net_0  = 3'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWBURST_const_net_0 = 2'h3;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWCACHE_const_net_0 = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWPROT_const_net_0  = 3'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWQOS_const_net_0   = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WDATA_const_net_0   = 64'h0000000000000000;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WSTRB_const_net_0   = 8'hFF;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARID_const_net_0    = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARADDR_const_net_0  = 38'h0000000000;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARLEN_const_net_0   = 8'h00;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARSIZE_const_net_0  = 3'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARBURST_const_net_0 = 2'h3;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARCACHE_const_net_0 = 4'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARPROT_const_net_0  = 3'h0;
assign FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARQOS_const_net_0   = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWID_const_net_0    = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWADDR_const_net_0  = 38'h0000000000;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWLEN_const_net_0   = 8'h00;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWSIZE_const_net_0  = 3'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWBURST_const_net_0 = 2'h3;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWCACHE_const_net_0 = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWPROT_const_net_0  = 3'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWQOS_const_net_0   = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WDATA_const_net_0   = 64'h0000000000000000;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WSTRB_const_net_0   = 8'hFF;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARID_const_net_0    = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARADDR_const_net_0  = 38'h0000000000;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARLEN_const_net_0   = 8'h00;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARSIZE_const_net_0  = 3'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARBURST_const_net_0 = 2'h3;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARCACHE_const_net_0 = 4'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARPROT_const_net_0  = 3'h0;
assign FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARQOS_const_net_0   = 4'h0;
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
assign LED0_net_1                        = LED0_net_0;
assign LED0                              = LED0_net_1;
assign LED1_net_1                        = LED1_net_0;
assign LED1                              = LED1_net_1;
assign LED2_net_1                        = LED2_net_0;
assign LED2                              = LED2_net_1;
assign LED3_net_1                        = LED3_net_0;
assign LED3                              = LED3_net_1;
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
assign PCIESS_LANE_TXD0_N_net_1          = PCIESS_LANE_TXD0_N_net_0;
assign PCIESS_LANE_TXD0_N                = PCIESS_LANE_TXD0_N_net_1;
assign PCIESS_LANE_TXD0_P_net_1          = PCIESS_LANE_TXD0_P_net_0;
assign PCIESS_LANE_TXD0_P                = PCIESS_LANE_TXD0_P_net_1;
assign PCIESS_LANE_TXD1_N_net_1          = PCIESS_LANE_TXD1_N_net_0;
assign PCIESS_LANE_TXD1_N                = PCIESS_LANE_TXD1_N_net_1;
assign PCIESS_LANE_TXD1_P_net_1          = PCIESS_LANE_TXD1_P_net_0;
assign PCIESS_LANE_TXD1_P                = PCIESS_LANE_TXD1_P_net_1;
assign PCIESS_LANE_TXD2_N_net_1          = PCIESS_LANE_TXD2_N_net_0;
assign PCIESS_LANE_TXD2_N                = PCIESS_LANE_TXD2_N_net_1;
assign PCIESS_LANE_TXD2_P_net_1          = PCIESS_LANE_TXD2_P_net_0;
assign PCIESS_LANE_TXD2_P                = PCIESS_LANE_TXD2_P_net_1;
assign PCIESS_LANE_TXD3_N_net_1          = PCIESS_LANE_TXD3_N_net_0;
assign PCIESS_LANE_TXD3_N                = PCIESS_LANE_TXD3_N_net_1;
assign PCIESS_LANE_TXD3_P_net_1          = PCIESS_LANE_TXD3_P_net_0;
assign PCIESS_LANE_TXD3_P                = PCIESS_LANE_TXD3_P_net_1;
assign PCIE_1_PERST_N_net_1              = PCIE_1_PERST_N_net_0;
assign PCIE_1_PERST_N                    = PCIE_1_PERST_N_net_1;
assign RESET_N_net_1                     = RESET_N_net_0;
assign RESET_N                           = RESET_N_net_1;
assign SDIO_SW_SEL1_net_1                = SDIO_SW_SEL1_net_0;
assign SDIO_SW_SEL0                      = SDIO_SW_SEL1_net_1;
assign SDIO_SW_SEL1_net_2                = SDIO_SW_SEL1_net_0;
assign SDIO_SW_SEL1                      = SDIO_SW_SEL1_net_2;
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
assign FIC_1_PERIPHERALS_1_AXI4mslave0_ARID_0 = { FIC_1_PERIPHERALS_1_AXI4mslave0_ARID_0_3to0 };
assign FIC_1_PERIPHERALS_1_AXI4mslave0_ARID_0_3to0 = FIC_1_PERIPHERALS_1_AXI4mslave0_ARID[3:0];

assign FIC_1_PERIPHERALS_1_AXI4mslave0_ARLOCK_0 = { FIC_1_PERIPHERALS_1_AXI4mslave0_ARLOCK_0_0to0 };
assign FIC_1_PERIPHERALS_1_AXI4mslave0_ARLOCK_0_0to0 = FIC_1_PERIPHERALS_1_AXI4mslave0_ARLOCK[0:0];

assign FIC_1_PERIPHERALS_1_AXI4mslave0_AWID_0 = { FIC_1_PERIPHERALS_1_AXI4mslave0_AWID_0_3to0 };
assign FIC_1_PERIPHERALS_1_AXI4mslave0_AWID_0_3to0 = FIC_1_PERIPHERALS_1_AXI4mslave0_AWID[3:0];

assign FIC_1_PERIPHERALS_1_AXI4mslave0_AWLOCK_0 = { FIC_1_PERIPHERALS_1_AXI4mslave0_AWLOCK_0_0to0 };
assign FIC_1_PERIPHERALS_1_AXI4mslave0_AWLOCK_0_0to0 = FIC_1_PERIPHERALS_1_AXI4mslave0_AWLOCK[0:0];

assign FIC_1_PERIPHERALS_1_AXI4mslave0_BID_0 = { FIC_1_PERIPHERALS_1_AXI4mslave0_BID_0_4to4, FIC_1_PERIPHERALS_1_AXI4mslave0_BID_0_3to0 };
assign FIC_1_PERIPHERALS_1_AXI4mslave0_BID_0_3to0 = FIC_1_PERIPHERALS_1_AXI4mslave0_BID[3:0];
assign FIC_1_PERIPHERALS_1_AXI4mslave0_BID_0_4to4 = 1'b0;

assign FIC_1_PERIPHERALS_1_AXI4mslave0_RID_0 = { FIC_1_PERIPHERALS_1_AXI4mslave0_RID_0_4to4, FIC_1_PERIPHERALS_1_AXI4mslave0_RID_0_3to0 };
assign FIC_1_PERIPHERALS_1_AXI4mslave0_RID_0_3to0 = FIC_1_PERIPHERALS_1_AXI4mslave0_RID[3:0];
assign FIC_1_PERIPHERALS_1_AXI4mslave0_RID_0_4to4 = 1'b0;

assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0 = { MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_1to1, MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_0to0 };
assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_0to0 = MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK;
assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_ARLOCK_0_1to1 = 1'b0;

assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0 = { MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_1to1, MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_0to0 };
assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_0to0 = MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK;
assign MSS_WRAPPER_1_FIC_0_AXI4_INITIATOR_AWLOCK_0_1to1 = 1'b0;

assign MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK_0 = { MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK_0_1to1, MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK_0_0to0 };
assign MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK_0_0to0 = MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK;
assign MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK_0_1to1 = 1'b0;

assign MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK_0 = { MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK_0_1to1, MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK_0_0to0 };
assign MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK_0_0to0 = MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK;
assign MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK_0_1to1 = 1'b0;

assign MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR_0 = { MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR_0_31to29, MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR_0_28to0 };
assign MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR_0_28to0 = MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR[28:0];
assign MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR_0_31to29 = 3'h0;

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CLOCKS_AND_RESETS
CLOCKS_AND_RESETS CLOCKS_AND_RESETS_inst_0(
        // Inputs
        .EXT_RST_N          ( USB_ULPI_RESET_net_0 ),
        .MSS_PLL_LOCKS      ( MSS_WRAPPER_1_MSS_DLL_LOCKS ),
        .REF_CLK_50MHz      ( REF_CLK_50MHz ),
        .REF_CLK_PAD_N      ( REF_CLK_PAD_N ),
        .REF_CLK_PAD_P      ( REF_CLK_PAD_P ),
        // Outputs
        .BIT_CLK            ( CLOCKS_AND_RESETS_CLKS_TO_XCVR_BIT_CLK ),
        .FIC_0_CLK          ( CLOCKS_AND_RESETS_FIC_0_CLK ),
        .FIC_1_CLK          ( CLOCKS_AND_RESETS_FIC_1_CLK ),
        .FIC_2_CLK          ( CLOCKS_AND_RESETS_FIC_2_CLK ),
        .FIC_3_CLK          ( CLOCKS_AND_RESETS_FIC_3_CLK ),
        .LOCK               ( CLOCKS_AND_RESETS_CLKS_TO_XCVR_LOCK ),
        .PCIE_INIT_DONE     ( CLOCKS_AND_RESETS_PCIE_INIT_DONE ),
        .PCIe_CLK_125MHz    ( CLOCKS_AND_RESETS_PCIe_CLK_125MHz ),
        .PCIe_REFERENCE_CLK ( CLOCKS_AND_RESETS_PCIe_REFERENCE_CLK ),
        .REF_CLK_TO_LANE    ( CLOCKS_AND_RESETS_CLKS_TO_XCVR_REF_CLK_TO_LANE ),
        .RESETN_FIC2_CLK    (  ),
        .RESETN_FIC_0_CLK   ( CLOCKS_AND_RESETS_RESETN_FIC_0_CLK ),
        .RESETN_FIC_1_CLK   ( CLOCKS_AND_RESETS_RESETN_FIC_1_CLK ),
        .RESETN_FIC_3_CLK   ( CLOCKS_AND_RESETS_RESETN_FIC_3_CLK ) 
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

//--------FIC_1_PERIPHERALS
FIC_1_PERIPHERALS FIC_1_PERIPHERALS_1(
        // Inputs
        .ACLK                                              ( CLOCKS_AND_RESETS_FIC_1_CLK ),
        .ARESETN                                           ( CLOCKS_AND_RESETS_RESETN_FIC_1_CLK ),
        .AXI4mmaster0_MASTER0_ARVALID                      ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARVALID ),
        .AXI4mmaster0_MASTER0_AWVALID                      ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWVALID ),
        .AXI4mmaster0_MASTER0_BREADY                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BREADY ),
        .AXI4mmaster0_MASTER0_RREADY                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RREADY ),
        .AXI4mmaster0_MASTER0_WLAST                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WLAST ),
        .AXI4mmaster0_MASTER0_WVALID                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WVALID ),
        .AXI4mslave0_SLAVE0_ARREADY                        ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARREADY ),
        .AXI4mslave0_SLAVE0_AWREADY                        ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWREADY ),
        .AXI4mslave0_SLAVE0_BVALID                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_BVALID ),
        .AXI4mslave0_SLAVE0_RLAST                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_RLAST ),
        .AXI4mslave0_SLAVE0_RVALID                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_RVALID ),
        .AXI4mslave0_SLAVE0_WREADY                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_WREADY ),
        .CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_BIT_CLK       ( CLOCKS_AND_RESETS_CLKS_TO_XCVR_BIT_CLK ),
        .CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_LOCK      ( CLOCKS_AND_RESETS_CLKS_TO_XCVR_LOCK ),
        .CLKS_FROM_TXPLL_TO_PCIE_1_PCIE_1_TX_PLL_REF_CLK   ( CLOCKS_AND_RESETS_CLKS_TO_XCVR_REF_CLK_TO_LANE ),
        .PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_ARST_N    ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_ARST_N ),
        .PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CLK       ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_CLK ),
        .PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_ARST_N    ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_ARST_N ),
        .PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CLK       ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_CLK ),
        .PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_ARST_N    ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_ARST_N ),
        .PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CLK       ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_CLK ),
        .PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_ARST_N    ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_ARST_N ),
        .PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CLK       ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_CLK ),
        .PCIESS_LANE_RXD0_N                                ( PCIESS_LANE_RXD0_N ),
        .PCIESS_LANE_RXD0_P                                ( PCIESS_LANE_RXD0_P ),
        .PCIESS_LANE_RXD1_N                                ( PCIESS_LANE_RXD1_N ),
        .PCIESS_LANE_RXD1_P                                ( PCIESS_LANE_RXD1_P ),
        .PCIESS_LANE_RXD2_N                                ( PCIESS_LANE_RXD2_N ),
        .PCIESS_LANE_RXD2_P                                ( PCIESS_LANE_RXD2_P ),
        .PCIESS_LANE_RXD3_N                                ( PCIESS_LANE_RXD3_N ),
        .PCIESS_LANE_RXD3_P                                ( PCIESS_LANE_RXD3_P ),
        .PCIE_APB_SLAVE_APB_S_PENABLE                      ( GND_net ), // tied to 1'b0 from definition
        .PCIE_APB_SLAVE_APB_S_PSEL                         ( GND_net ), // tied to 1'b0 from definition
        .PCIE_APB_SLAVE_APB_S_PWRITE                       ( GND_net ), // tied to 1'b0 from definition
        .PCIe_CLK_125MHz                                   ( CLOCKS_AND_RESETS_PCIe_CLK_125MHz ),
        .PCIe_INIT_DONE                                    ( CLOCKS_AND_RESETS_PCIE_INIT_DONE ),
        .PCIe_REFERENCE_CLK                                ( CLOCKS_AND_RESETS_PCIe_REFERENCE_CLK ),
        .PCLK                                              ( CLOCKS_AND_RESETS_FIC_3_CLK ),
        .PRESETN                                           ( CLOCKS_AND_RESETS_RESETN_FIC_3_CLK ),
        .AXI4mmaster0_MASTER0_ARADDR                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARADDR ),
        .AXI4mmaster0_MASTER0_ARBURST                      ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARBURST ),
        .AXI4mmaster0_MASTER0_ARCACHE                      ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARCACHE ),
        .AXI4mmaster0_MASTER0_ARID                         ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARID ),
        .AXI4mmaster0_MASTER0_ARLEN                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLEN ),
        .AXI4mmaster0_MASTER0_ARLOCK                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK_0 ),
        .AXI4mmaster0_MASTER0_ARPROT                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARPROT ),
        .AXI4mmaster0_MASTER0_ARQOS                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARQOS ),
        .AXI4mmaster0_MASTER0_ARREGION                     ( AXI4mmaster0_MASTER0_ARREGION_const_net_1 ), // tied to 4'h0 from definition
        .AXI4mmaster0_MASTER0_ARSIZE                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARSIZE ),
        .AXI4mmaster0_MASTER0_ARUSER                       ( GND_net ), // tied to 1'b0 from definition
        .AXI4mmaster0_MASTER0_AWADDR                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWADDR ),
        .AXI4mmaster0_MASTER0_AWBURST                      ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWBURST ),
        .AXI4mmaster0_MASTER0_AWCACHE                      ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWCACHE ),
        .AXI4mmaster0_MASTER0_AWID                         ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWID ),
        .AXI4mmaster0_MASTER0_AWLEN                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLEN ),
        .AXI4mmaster0_MASTER0_AWLOCK                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK_0 ),
        .AXI4mmaster0_MASTER0_AWPROT                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWPROT ),
        .AXI4mmaster0_MASTER0_AWQOS                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWQOS ),
        .AXI4mmaster0_MASTER0_AWREGION                     ( AXI4mmaster0_MASTER0_AWREGION_const_net_1 ), // tied to 4'h0 from definition
        .AXI4mmaster0_MASTER0_AWSIZE                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWSIZE ),
        .AXI4mmaster0_MASTER0_AWUSER                       ( GND_net ), // tied to 1'b0 from definition
        .AXI4mmaster0_MASTER0_WDATA                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WDATA ),
        .AXI4mmaster0_MASTER0_WSTRB                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WSTRB ),
        .AXI4mmaster0_MASTER0_WUSER                        ( GND_net ), // tied to 1'b0 from definition
        .AXI4mslave0_SLAVE0_BID                            ( FIC_1_PERIPHERALS_1_AXI4mslave0_BID_0 ),
        .AXI4mslave0_SLAVE0_BRESP                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_BRESP ),
        .AXI4mslave0_SLAVE0_BUSER                          ( GND_net ), // tied to 1'b0 from definition
        .AXI4mslave0_SLAVE0_RDATA                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_RDATA ),
        .AXI4mslave0_SLAVE0_RID                            ( FIC_1_PERIPHERALS_1_AXI4mslave0_RID_0 ),
        .AXI4mslave0_SLAVE0_RRESP                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_RRESP ),
        .AXI4mslave0_SLAVE0_RUSER                          ( GND_net ), // tied to 1'b0 from definition
        .PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_CTRL      ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_CTRL ),
        .PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_WDATA     ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_WDATA ),
        .PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_CTRL      ( FIC_3_PERIPHERALS_1_Q0_LANE1_DRI_DRI_CTRL ),
        .PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_WDATA     ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_WDATA ),
        .PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_CTRL      ( FIC_3_PERIPHERALS_1_Q0_LANE2_DRI_DRI_CTRL ),
        .PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_WDATA     ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_WDATA ),
        .PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_CTRL      ( FIC_3_PERIPHERALS_1_Q0_LANE3_DRI_DRI_CTRL ),
        .PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_WDATA     ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_WDATA ),
        .PCIE_APB_SLAVE_APB_S_PADDR                        ( PCIE_APB_SLAVE_APB_S_PADDR_const_net_0 ), // tied to 26'h0000000 from definition
        .PCIE_APB_SLAVE_APB_S_PWDATA                       ( PCIE_APB_SLAVE_APB_S_PWDATA_const_net_0 ), // tied to 32'h00000000 from definition
        // Outputs
        .AXI4mmaster0_MASTER0_ARREADY                      ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARREADY ),
        .AXI4mmaster0_MASTER0_AWREADY                      ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWREADY ),
        .AXI4mmaster0_MASTER0_BVALID                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BVALID ),
        .AXI4mmaster0_MASTER0_RLAST                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RLAST ),
        .AXI4mmaster0_MASTER0_RVALID                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RVALID ),
        .AXI4mmaster0_MASTER0_WREADY                       ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WREADY ),
        .AXI4mslave0_SLAVE0_ARVALID                        ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARVALID ),
        .AXI4mslave0_SLAVE0_AWVALID                        ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWVALID ),
        .AXI4mslave0_SLAVE0_BREADY                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_BREADY ),
        .AXI4mslave0_SLAVE0_RREADY                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_RREADY ),
        .AXI4mslave0_SLAVE0_WLAST                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_WLAST ),
        .AXI4mslave0_SLAVE0_WVALID                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_WVALID ),
        .PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_INTERRUPT ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_INTERRUPT ),
        .PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_INTERRUPT ( FIC_3_PERIPHERALS_1_Q0_LANE1_DRI_DRI_INTERRUPT ),
        .PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_INTERRUPT ( FIC_3_PERIPHERALS_1_Q0_LANE2_DRI_DRI_INTERRUPT ),
        .PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_INTERRUPT ( FIC_3_PERIPHERALS_1_Q0_LANE3_DRI_DRI_INTERRUPT ),
        .PCIESS_LANE_TXD0_N                                ( PCIESS_LANE_TXD0_N_net_0 ),
        .PCIESS_LANE_TXD0_P                                ( PCIESS_LANE_TXD0_P_net_0 ),
        .PCIESS_LANE_TXD1_N                                ( PCIESS_LANE_TXD1_N_net_0 ),
        .PCIESS_LANE_TXD1_P                                ( PCIESS_LANE_TXD1_P_net_0 ),
        .PCIESS_LANE_TXD2_N                                ( PCIESS_LANE_TXD2_N_net_0 ),
        .PCIESS_LANE_TXD2_P                                ( PCIESS_LANE_TXD2_P_net_0 ),
        .PCIESS_LANE_TXD3_N                                ( PCIESS_LANE_TXD3_N_net_0 ),
        .PCIESS_LANE_TXD3_P                                ( PCIESS_LANE_TXD3_P_net_0 ),
        .PCIE_1_PERST_N                                    ( PCIE_1_PERST_N_net_0 ),
        .PCIE_APB_SLAVE_APB_S_PREADY                       (  ),
        .PCIE_APB_SLAVE_APB_S_PSLVERR                      (  ),
        .PCIe_IRQ                                          ( FIC_1_PERIPHERALS_1_PCIe_IRQ ),
        .AXI4mmaster0_MASTER0_BID                          ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BID ),
        .AXI4mmaster0_MASTER0_BRESP                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BRESP ),
        .AXI4mmaster0_MASTER0_BUSER                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BUSER ),
        .AXI4mmaster0_MASTER0_RDATA                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RDATA ),
        .AXI4mmaster0_MASTER0_RID                          ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RID ),
        .AXI4mmaster0_MASTER0_RRESP                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RRESP ),
        .AXI4mmaster0_MASTER0_RUSER                        ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RUSER ),
        .AXI4mslave0_SLAVE0_ARADDR                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARADDR ),
        .AXI4mslave0_SLAVE0_ARBURST                        ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARBURST ),
        .AXI4mslave0_SLAVE0_ARCACHE                        ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARCACHE ),
        .AXI4mslave0_SLAVE0_ARID                           ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARID ),
        .AXI4mslave0_SLAVE0_ARLEN                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARLEN ),
        .AXI4mslave0_SLAVE0_ARLOCK                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARLOCK ),
        .AXI4mslave0_SLAVE0_ARPROT                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARPROT ),
        .AXI4mslave0_SLAVE0_ARQOS                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARQOS ),
        .AXI4mslave0_SLAVE0_ARREGION                       ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARREGION ),
        .AXI4mslave0_SLAVE0_ARSIZE                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARSIZE ),
        .AXI4mslave0_SLAVE0_ARUSER                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARUSER ),
        .AXI4mslave0_SLAVE0_AWADDR                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWADDR ),
        .AXI4mslave0_SLAVE0_AWBURST                        ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWBURST ),
        .AXI4mslave0_SLAVE0_AWCACHE                        ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWCACHE ),
        .AXI4mslave0_SLAVE0_AWID                           ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWID ),
        .AXI4mslave0_SLAVE0_AWLEN                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWLEN ),
        .AXI4mslave0_SLAVE0_AWLOCK                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWLOCK ),
        .AXI4mslave0_SLAVE0_AWPROT                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWPROT ),
        .AXI4mslave0_SLAVE0_AWQOS                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWQOS ),
        .AXI4mslave0_SLAVE0_AWREGION                       ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWREGION ),
        .AXI4mslave0_SLAVE0_AWSIZE                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWSIZE ),
        .AXI4mslave0_SLAVE0_AWUSER                         ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWUSER ),
        .AXI4mslave0_SLAVE0_WDATA                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_WDATA ),
        .AXI4mslave0_SLAVE0_WSTRB                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_WSTRB ),
        .AXI4mslave0_SLAVE0_WUSER                          ( FIC_1_PERIPHERALS_1_AXI4mslave0_WUSER ),
        .PCIESS_LANE0_DRI_SLAVE_PCIESS_LANE0_DRI_RDATA     ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_RDATA ),
        .PCIESS_LANE1_DRI_SLAVE_PCIESS_LANE1_DRI_RDATA     ( FIC_3_PERIPHERALS_1_Q0_LANE1_DRI_DRI_RDATA ),
        .PCIESS_LANE2_DRI_SLAVE_PCIESS_LANE2_DRI_RDATA     ( FIC_3_PERIPHERALS_1_Q0_LANE2_DRI_DRI_RDATA ),
        .PCIESS_LANE3_DRI_SLAVE_PCIESS_LANE3_DRI_RDATA     ( FIC_3_PERIPHERALS_1_Q0_LANE3_DRI_DRI_RDATA ),
        .PCIE_APB_SLAVE_APB_S_PRDATA                       (  ) 
        );

//--------FIC_3_PERIPHERALS
FIC_3_PERIPHERALS FIC_3_PERIPHERALS_1(
        // Inputs
        .PCLK                            ( CLOCKS_AND_RESETS_FIC_3_CLK ),
        .PLL0_SW_DRI_INTERRUPT           ( VCC_net ), // tied to 1'b1 from definition
        .PRESETN                         ( CLOCKS_AND_RESETS_RESETN_FIC_3_CLK ),
        .Q0_LANE0_DRI_INTERRUPT          ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_INTERRUPT ),
        .Q0_LANE1_DRI_INTERRUPT          ( FIC_3_PERIPHERALS_1_Q0_LANE1_DRI_DRI_INTERRUPT ),
        .Q0_LANE2_DRI_INTERRUPT          ( FIC_3_PERIPHERALS_1_Q0_LANE2_DRI_DRI_INTERRUPT ),
        .Q0_LANE3_DRI_INTERRUPT          ( FIC_3_PERIPHERALS_1_Q0_LANE3_DRI_DRI_INTERRUPT ),
        .APB_MMASTER_in_psel             ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PSELx ),
        .APB_MMASTER_in_penable          ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PENABLE ),
        .APB_MMASTER_in_pwrite           ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PWRITE ),
        .PLL0_SW_DRI_RDATA               ( PLL0_SW_DRI_RDATA_const_net_0 ), // tied to 33'h000000000 from definition
        .PSTRB                           ( MSS_WRAPPER_1_FIC_3_APB_M_PSTRB ),
        .Q0_LANE0_DRI_RDATA              ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_RDATA ),
        .Q0_LANE1_DRI_RDATA              ( FIC_3_PERIPHERALS_1_Q0_LANE1_DRI_DRI_RDATA ),
        .Q0_LANE2_DRI_RDATA              ( FIC_3_PERIPHERALS_1_Q0_LANE2_DRI_DRI_RDATA ),
        .Q0_LANE3_DRI_RDATA              ( FIC_3_PERIPHERALS_1_Q0_LANE3_DRI_DRI_RDATA ),
        .APB_MMASTER_in_paddr            ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR_0 ),
        .APB_MMASTER_in_pwdata           ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PWDATA ),
        // Outputs
        .GPIO_OUT_0                      ( FIC_3_PERIPHERALS_1_GPIO_OUT_0 ),
        .GPIO_OUT_1                      ( FIC_3_PERIPHERALS_1_GPIO_OUT_1 ),
        .GPIO_OUT_2                      ( FIC_3_PERIPHERALS_1_GPIO_OUT_2 ),
        .GPIO_OUT_3                      ( FIC_3_PERIPHERALS_1_GPIO_OUT_3 ),
        .IHC_SUBSYSTEM_E51_IRQ           ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_E51_IRQ ),
        .IHC_SUBSYSTEM_U54_1_IRQ         ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_1_IRQ ),
        .IHC_SUBSYSTEM_U54_2_IRQ         ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_2_IRQ ),
        .IHC_SUBSYSTEM_U54_3_IRQ         ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_3_IRQ ),
        .IHC_SUBSYSTEM_U54_4_IRQ         ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_4_IRQ ),
        .Q0_LANE0_DRI_DRI_ARST_N         ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_ARST_N ),
        .Q0_LANE0_DRI_DRI_CLK            ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_CLK ),
        .fabric_sd_emmc_demux_select_out ( SDIO_SW_SEL1_net_0 ),
        .APB_MMASTER_in_pready           ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PREADY ),
        .APB_MMASTER_in_pslverr          ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PSLVERR ),
        .PLL0_SW_DRI_CTRL                (  ),
        .Q0_LANE0_DRI_CTRL               ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_CTRL ),
        .Q0_LANE0_DRI_DRI_WDATA          ( FIC_3_PERIPHERALS_1_Q0_LANE0_DRI_DRI_WDATA ),
        .Q0_LANE1_DRI_CTRL               ( FIC_3_PERIPHERALS_1_Q0_LANE1_DRI_DRI_CTRL ),
        .Q0_LANE2_DRI_CTRL               ( FIC_3_PERIPHERALS_1_Q0_LANE2_DRI_DRI_CTRL ),
        .Q0_LANE3_DRI_CTRL               ( FIC_3_PERIPHERALS_1_Q0_LANE3_DRI_DRI_CTRL ),
        .APB_MMASTER_in_prdata           ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PRDATA ) 
        );

//--------OR2
OR2 MSS_GPIO_2_16_OR_COREGPIO_C0_GPIO_OUT_0(
        // Inputs
        .A ( MSS_WRAPPER_1_GPIO_2_M2F_16 ),
        .B ( FIC_3_PERIPHERALS_1_GPIO_OUT_0 ),
        // Outputs
        .Y ( LED0_net_0 ) 
        );

//--------OR2
OR2 MSS_GPIO_2_17_OR_COREGPIO_C0_GPIO_OUT_1(
        // Inputs
        .A ( MSS_WRAPPER_1_GPIO_2_M2F_17 ),
        .B ( FIC_3_PERIPHERALS_1_GPIO_OUT_1 ),
        // Outputs
        .Y ( LED1_net_0 ) 
        );

//--------OR2
OR2 MSS_GPIO_2_18_OR_COREGPIO_C0_GPIO_OUT_2(
        // Inputs
        .A ( MSS_WRAPPER_1_GPIO_2_M2F_18 ),
        .B ( FIC_3_PERIPHERALS_1_GPIO_OUT_2 ),
        // Outputs
        .Y ( LED2_net_0 ) 
        );

//--------OR2
OR2 MSS_GPIO_2_19_OR_COREGPIO_C0_GPIO_OUT_3(
        // Inputs
        .A ( MSS_WRAPPER_1_GPIO_2_M2F_19 ),
        .B ( FIC_3_PERIPHERALS_1_GPIO_OUT_3 ),
        // Outputs
        .Y ( LED3_net_0 ) 
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
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARREADY ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARREADY ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWREADY ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWREADY ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BVALID  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BVALID ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RLAST   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RLAST ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RVALID  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RVALID ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WREADY  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WREADY ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARLOCK     ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARLOCK_0 ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARVALID    ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARVALID ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWLOCK     ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWLOCK_0 ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWVALID    ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWVALID ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_BREADY     ( FIC_1_PERIPHERALS_1_AXI4mslave0_BREADY ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RREADY     ( FIC_1_PERIPHERALS_1_AXI4mslave0_RREADY ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WLAST      ( FIC_1_PERIPHERALS_1_AXI4mslave0_WLAST ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WVALID     ( FIC_1_PERIPHERALS_1_AXI4mslave0_WVALID ),
        .FIC_2_ACLK                                ( CLOCKS_AND_RESETS_FIC_2_CLK ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARLOCK     ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARVALID    ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWLOCK     ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWVALID    ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_BREADY     ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RREADY     ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WLAST      ( GND_net ), // tied to 1'b0 from definition
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WVALID     ( GND_net ), // tied to 1'b0 from definition
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PREADY    ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PREADY ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PSLVERR   ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PSLVERR ),
        .FIC_3_PCLK                                ( CLOCKS_AND_RESETS_FIC_3_CLK ),
        .GPIO_2_F2M_30                             ( SW2_OR_GPIO_2_26_Y ),
        .GPIO_2_F2M_31                             ( SW3_OR_GPIO_2_27_Y ),
        .MMUART_0_RXD_F2M                          ( MMUART_0_RXD_F2M ),
        .MMUART_1_RXD_F2M                          ( MMUART_1_RXD_F2M ),
        .MMUART_2_RXD_F2M                          ( MMUART_2_RXD_F2M ),
        .MMUART_3_RXD_F2M                          ( MMUART_3_RXD_F2M ),
        .MMUART_4_RXD_F2M                          ( mBUS_UART_RX ),
        .MSS_INT_F2M_0                             ( SW1_OR_GPIO_2_28_Y ),
        .MSS_INT_F2M_1                             ( FIC_1_PERIPHERALS_1_PCIe_IRQ ),
        .MSS_INT_F2M_2                             ( FIC_0_PERIPHERALS_1_core_poly_irq ),
        .MSS_INT_F2M_3                             ( mBUS_INT ),
        .MSS_INT_F2M_59                            ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_4_IRQ ),
        .MSS_INT_F2M_60                            ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_3_IRQ ),
        .MSS_INT_F2M_61                            ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_2_IRQ ),
        .MSS_INT_F2M_62                            ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_U54_1_IRQ ),
        .MSS_INT_F2M_63                            ( FIC_3_PERIPHERALS_1_IHC_SUBSYSTEM_E51_IRQ ),
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
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BID     ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BID ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BRESP   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BRESP ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RDATA   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RDATA ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RID     ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RID ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RRESP   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RRESP ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARADDR     ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARADDR ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARBURST    ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARBURST ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARCACHE    ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARCACHE ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARID       ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARID_0 ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARLEN      ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARLEN ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARPROT     ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARPROT ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARQOS      ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARQOS ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARSIZE     ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARSIZE ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWADDR     ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWADDR ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWBURST    ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWBURST ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWCACHE    ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWCACHE ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWID       ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWID_0 ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWLEN      ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWLEN ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWPROT     ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWPROT ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWQOS      ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWQOS ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWSIZE     ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWSIZE ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WDATA      ( FIC_1_PERIPHERALS_1_AXI4mslave0_WDATA ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WSTRB      ( FIC_1_PERIPHERALS_1_AXI4mslave0_WSTRB ),
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
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PRDATA    ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PRDATA ),
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
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_ARREADY    ( FIC_0_PERIPHERALS_1_AXI4mslave0_ARREADY ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_AWREADY    ( FIC_0_PERIPHERALS_1_AXI4mslave0_AWREADY ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_BVALID     ( FIC_0_PERIPHERALS_1_AXI4mslave0_BVALID ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RLAST      ( FIC_0_PERIPHERALS_1_AXI4mslave0_RLAST ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RVALID     ( FIC_0_PERIPHERALS_1_AXI4mslave0_RVALID ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_WREADY     ( FIC_0_PERIPHERALS_1_AXI4mslave0_WREADY ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARLOCK  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLOCK ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARVALID ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARVALID ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWLOCK  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLOCK ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWVALID ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWVALID ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_BREADY  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_BREADY ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_RREADY  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_RREADY ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WLAST   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WLAST ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WVALID  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WVALID ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_ARREADY    ( FIC_1_PERIPHERALS_1_AXI4mslave0_ARREADY ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_AWREADY    ( FIC_1_PERIPHERALS_1_AXI4mslave0_AWREADY ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_BVALID     ( FIC_1_PERIPHERALS_1_AXI4mslave0_BVALID ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RLAST      ( FIC_1_PERIPHERALS_1_AXI4mslave0_RLAST ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RVALID     ( FIC_1_PERIPHERALS_1_AXI4mslave0_RVALID ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_WREADY     ( FIC_1_PERIPHERALS_1_AXI4mslave0_WREADY ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_ARREADY    (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_AWREADY    (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_BVALID     (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RLAST      (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RVALID     (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_WREADY     (  ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PENABLE   ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PENABLE ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PSEL      ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PSELx ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PWRITE    ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PWRITE ),
        .GPIO_2_M2F_16                             ( MSS_WRAPPER_1_GPIO_2_M2F_16 ),
        .GPIO_2_M2F_17                             ( MSS_WRAPPER_1_GPIO_2_M2F_17 ),
        .GPIO_2_M2F_18                             ( MSS_WRAPPER_1_GPIO_2_M2F_18 ),
        .GPIO_2_M2F_19                             ( MSS_WRAPPER_1_GPIO_2_M2F_19 ),
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
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_BID        ( FIC_0_PERIPHERALS_1_AXI4mslave0_BID ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_BRESP      ( FIC_0_PERIPHERALS_1_AXI4mslave0_BRESP ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RDATA      ( FIC_0_PERIPHERALS_1_AXI4mslave0_RDATA ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RID        ( FIC_0_PERIPHERALS_1_AXI4mslave0_RID ),
        .FIC_0_AXI4_TARGET_FIC_0_AXI4_S_RRESP      ( FIC_0_PERIPHERALS_1_AXI4mslave0_RRESP ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARADDR  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARADDR ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARBURST ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARBURST ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARCACHE ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARCACHE ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARID    ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARID ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARLEN   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARLEN ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARPROT  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARPROT ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARQOS   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARQOS ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_ARSIZE  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_ARSIZE ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWADDR  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWADDR ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWBURST ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWBURST ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWCACHE ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWCACHE ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWID    ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWID ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWLEN   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWLEN ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWPROT  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWPROT ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWQOS   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWQOS ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_AWSIZE  ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_AWSIZE ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WDATA   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WDATA ),
        .FIC_1_AXI4_INITIATOR_FIC_1_AXI4_M_WSTRB   ( MSS_WRAPPER_1_FIC_1_AXI4_INITIATOR_WSTRB ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_BID        ( FIC_1_PERIPHERALS_1_AXI4mslave0_BID ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_BRESP      ( FIC_1_PERIPHERALS_1_AXI4mslave0_BRESP ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RDATA      ( FIC_1_PERIPHERALS_1_AXI4mslave0_RDATA ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RID        ( FIC_1_PERIPHERALS_1_AXI4mslave0_RID ),
        .FIC_1_AXI4_TARGET_FIC_1_AXI4_S_RRESP      ( FIC_1_PERIPHERALS_1_AXI4mslave0_RRESP ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_BID        (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_BRESP      (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RDATA      (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RID        (  ),
        .FIC_2_AXI4_TARGET_FIC_2_AXI4_S_RRESP      (  ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PADDR     ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PADDR ),
        .FIC_3_APB_INITIATOR_FIC_3_APB_M_PWDATA    ( MSS_WRAPPER_1_FIC_3_APB_INITIATOR_PWDATA ),
        .FIC_3_APB_M_PSTRB                         ( MSS_WRAPPER_1_FIC_3_APB_M_PSTRB ),
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
