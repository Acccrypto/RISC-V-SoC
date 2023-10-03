// ****************************************************************************/
// Microsemi Corporation Proprietary and Confidential
// Copyright 2017 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
// IN ADVANCE IN WRITING.
//
// Description: 
//
// SVN Revision Information:
// SVN $Revision: 28772 $
// SVN $Date: 2017-02-09 20:06:50 +0000 (Thu, 09 Feb 2017) $
//
// Resolved SARs
// SAR      Date     Who   Description
//
// Notes:
//
// ****************************************************************************/
`define TEST_CASE_0
`define TEST_CASE_1
`define TEST_CASE_2
`define TEST_CASE_3
`define TEST_CASE_4
`define TEST_CASE_5
`define TEST_CASE_6
////////////////////////////////////////////////////////////////////////////////
// Main testbench program
////////////////////////////////////////////////////////////////////////////////
$display ("****************************************************************");
$display ("** CoreAXI4DMAController - User testbench simulation            ");
$display ("****************************************************************");
`ifdef TEST_CASE_0 // External descriptor fetch
    $display ($time, "Executing test case 0");
    
    // Write the descriptor configuration to the external descriptor store
    config_ext_dscrptr(
        32'h80000040,    // ext_dscrptr_addr
        23'h000040,      // num_of_bytes
        32'h00000080,    // src_addr
        2'b01,           // src_op
        32'h00000100,    // dst_addr
        2'b01,           // dst_op
        1'b1,            // int_on_process
        1'b0,            // chain
        1'b1,            // src_data_valid
        1'b1,            // dst_data_ready
        1'b0,            // ext_dscrptr_next
        32'h00000000     // next_dscrptr_num_addr
    );
    
    // Configure interrupt 0 - Allow OpDone, wrError, rdError, invalid BD to generate interrupt
    config_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'hf             // Interrupt mask
    );
    
    // Write the DMA transfer description to BD 0
    // The operation described will transfer the external predefined descriptor from address 0x40
    // to address 0x20. When the operation is complete, the external descriptor will be fetched
    // by the DMA controller and executed.
    // The external descriptor transfer 64 bytes from address 0x80 to address 0x100.
    // The DMA controller will clear the external descriptor's data valid bit once the DMA operation
    // is complete whilst waiting on the Control master to service the interrupt.
    config_int_dscrptr(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        'h0,             // Internal descriptor number
        23'd20,          // Number of bytes to transfer
        32'h80000040,    // Source address
        2'b01,           // Source operation
        32'h80000020,    // Destination address
        2'b01,           // Destination operation
        1'b0,            // Interrupt when this descriptor is processed in a chain
        1'b1,            // Chain
        1'b1,            // src_data_valid
        1'b1,            // dst_data_ready
        1'b1,            // External descriptor next
        32'h80000020     // Next descriptor number/address
    );

    // Kick-off the chain operation by writing to the Start operation register
    start_operation(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0                // Internal descriptor number
    );
    
    wait_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        4'b0,            // Interrupt number
        6'd32,           // Internal descriptor number
        1'b1,            // External descriptor
        32'h80000020,    // External descriptor address
        4'b0001          // Interrupt status
    );

    // Clear the interrupt by writing one to the associated bits in the interrupt clear register
    clr_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'b0001          // Clear
    );
    $display($time, "Completed executing test case 0");
`endif

`ifdef TEST_CASE_1 // Simple DMA transfer with narrow last beat
    $display ($time, "Executing test case 1");    
    // Configure interrupt 0 - Allow OpDone, wrError, rdError, invalid BD to generate interrupt
    config_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'hf             // Interrupt mask
    );
    
    // Write the DMA transfer description to BD 0
    config_int_dscrptr(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        'h0,             // Internal descriptor number
        23'd60,          // Number of bytes to transfer
        32'h00000000,    // Source address
        2'b01,           // Source operation
        32'h40000020,    // Destination address
        2'b01,           // Destination operation
        1'b1,            // Interrupt when this descriptor is processed in a chain
        1'b0,            // Chain
        1'b1,            // src_data_valid
        1'b1,            // dst_data_ready
        1'b0,            // External descriptor next
        32'h00000000     // Next descriptor number/address
    );
    
    // Kick-off the operation by writing to the Start operation register
    start_operation(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0                // Internal descriptor number
    );
    
    // Wait for the associated interrupt output to be asserted
    wait_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        4'b0,            // Interrupt number
        6'd0,            // Internal descriptor number
        1'b0,            // External descriptor
        32'h0,           // External descriptor address
        4'b0001          // Interrupt status
    );
    
    // Clear the interrupt by writing one to the associated bits in the interrupt clear register
    clr_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'b0001          // Clear
    );
    
    // Reset the data valid bit so that the DMA transfer described in descriptor 0 can be kicked off again
    src_data_valid_reset_int(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0
    );
    dst_data_ready_reset_int(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0
    );
    
    // Kick-off the operation by writing to the Start operation register
    start_operation(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0
    );
    
    // Wait for the associated interrupt output to be asserted
    wait_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        4'b0,            // Interrupt number
        6'd0,            // Internal descriptor number
        1'b0,            // External descriptor
        32'h0,           // External descriptor address
        4'b0001          // Interrupt status
    ); // Opdone status expected
    
    // Clear the interrupt by writing one to the associated bits in the interrupt clear register
    clr_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'b0001          // Clear
    );
    $display ($time, "Completed executing test case 1");
`endif

`ifdef TEST_CASE_2 // Large DMA transfer requiring multiple AXI transactions and spanning 4 KB boundary on dest side
    $display ($time, "Executing test case 2");
    // Configure interrupt 0 - Allow OpDone, wrError, rdError, invalid BD to generate interrupt
    config_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'hf             // Interrupt mask
    );
    
    // Write the DMA transfer description to BD 1
    config_int_dscrptr(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        'h1,             // Internal descriptor number
        23'd4096,        // Number of bytes to transfer
        32'h00000000,    // Source address
        2'b01,           // Source operation
        32'h40000008,    // Destination address
        2'b01,           // Destination operation
        1'b1,            // Interrupt when this descriptor is processed in a chain
        1'b0,            // Chain
        1'b1,            // src_data_valid
        1'b1,            // dst_data_ready
        1'b0,            // External descriptor next
        32'h00000000     // Next descriptor number/address
    );
    
    // Kick-off the operation by writing to the Start operation register
    start_operation(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        1
    );
    
    // Wait for the associated interrupt output to be asserted
    wait_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        4'b0,            // Interrupt number
        6'd1,            // Internal descriptor number
        1'b0,            // External descriptor
        32'h0,           // External descriptor address
        4'b0001          // Interrupt status
    ); // Opdone status expected
    
    // Clear the interrupt by writing one to the associated bits in the interrupt clear register
    clr_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'b0001          // Clear
    );
    $display ($time, "Completed executing test case 2");
`endif

`ifdef TEST_CASE_3 // Internal descriptor chain operation
    $display ($time, "Executing test case 3");
    // Configure interrupt 0 - Allow OpDone, wrError, rdError, invalid BD to generate interrupt
    config_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'hf             // Interrupt mask
    );
    
    // Write the DMA transfer description to BD 0
    config_int_dscrptr(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        'h0,             // Internal descriptor number
        23'd60,          // Number of bytes to transfer
        32'h00000000,    // Source address
        2'b01,           // Source operation
        32'h40000020,    // Destination address
        2'b01,           // Destination operation
        1'b0,            // Interrupt when this descriptor is processed in a chain
        1'b1,            // Chain
        1'b1,            // src_data_valid
        1'b1,            // dst_data_ready
        1'b0,            // External descriptor next
        32'h00000001     // Next descriptor number/address
    );
    
    // Write the DMA transfer description to BD 1
    config_int_dscrptr(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        'h1,             // Internal descriptor number
        23'd4096,        // Number of bytes to transfer
        32'h00000000,    // Source address
        2'b01,           // Source operation
        32'h40000008,    // Destination address
        2'b01,           // Destination operation
        1'b0,            // Interrupt when this descriptor is processed in a chain
        1'b0,            // Chain
        1'b1,            // src_data_valid
        1'b1,            // dst_data_ready
        1'b0,            // External descriptor next
        32'h00000000     // Next descriptor number/address
    );
    
    // Kick-off the operation by writing to the Start operation register
    start_operation(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0                // Internal descriptor number
    );

    wait_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        4'b0,            // Interrupt number
        6'd1,            // Internal descriptor number
        1'b0,            // External descriptor
        32'h0,           // External descriptor address
        4'b0001          // Interrupt status
    );
    
    // Clear the interrupt by writing one to the associated bits in the interrupt clear register
    clr_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'b0001          // Clear
    );
    $display ($time, "Completed executing test case 3");
`endif
`ifdef TEST_CASE_4 // Multiple coincident start bits for same priority level descriptors
    $display ($time, "Executing test case 4");
    config_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'hf             // Interrupt mask
    );
    
    // Write the DMA transfer description to BD 0
    config_int_dscrptr(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        'h0,             // Internal descriptor number
        23'd4096,        // Number of bytes to transfer
        32'h00000008,    // Source address
        2'b01,           // Source operation
        32'h40000200,    // Destination address
        2'b01,           // Destination operation
        1'b0,            // Interrupt when this descriptor is processed in a chain
        1'b0,            // Chain
        1'b1,            // src_data_valid
        1'b1,            // dst_data_ready
        1'b0,            // External descriptor next
        32'h00000000     // Next descriptor number/address
    );
    
    // Write the DMA transfer description to BD 2
    config_int_dscrptr(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        'h2,             // Internal descriptor number
        23'd4096,        // Number of bytes to transfer
        32'h00000108,    // Source address
        2'b01,           // Source operation
        32'h40000408,    // Destination address
        2'b01,           // Destination operation
        1'b0,            // Interrupt when this descriptor is processed in a chain
        1'b0,            // Chain
        1'b1,            // src_data_valid
        1'b1,            // dst_data_ready
        1'b0,            // External descriptor next
        32'h00000000     // Next descriptor number/address
    );
    
    // Kick-off both descriptors in the same clock cycle
    axi_write(
        DMA_0_BASE_ADDR+START_OP_REG_ADDR,
        32'h00000005,
        4'hF
    );
    
    wait_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        4'b0,            // Interrupt number
        6'd2,            // Internal descriptor number
        1'b0,            // External descriptor
        32'h0,           // External descriptor address
        4'b0001          // Interrupt status
    );
    
    clr_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'b0001          // Clear
    );
    
    wait_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        4'b0,            // Interrupt number
        6'd0,            // Internal descriptor number
        1'b0,            // External descriptor
        32'h0,           // External descriptor address
        4'b0001          // Interrupt status
    );
    
    clr_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'b0001          // Clear
    );
    $display ($time, "Completed executing test case 4");
`endif

if (AXI4_STREAM_IF != 0)
    begin
        `ifdef TEST_CASE_5 // Stream descriptor bridging support
            $display ($time, "Executing test case 5");
            config_irq(
                DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
                0,               // Interrupt number
                4'hf             // Interrupt mask
            );
            
            // Setup the stream descriptor in the external descriptor store
            axi_write(
                'h80000000,
                32'h0000000D, // Dscrptr Valid, Dest data ready, Inc addr operation
                4'hF
            ); // Configuration register
            
            axi_write(
                'h80000004,
                32'd4096,
                4'hF
            ); // Number of bytes
            
            axi_write(
                'h80000008,
                32'h00000000,
                4'hF
            ); // Destination address
        
            
            // Configure the Stream DEST 00 register in CoreAXI4DMAController memory map
            axi_write(
                DMA_0_BASE_ADDR+'h460,
                32'h80000000,    // Stream descriptor address
                4'hF             // Write strobe
            );
            
            wait_irq(
                DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
                0,               // Interrupt number
                6'd33,           // Internal descriptor number
                1,               // External descriptor
                32'h80000000,    // External descriptor address
                4'b0001          // Interrupt status
            );
            
            clr_irq(
                DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
                0,               // Interrupt number
                4'b0001          // Clear
            );
            
            // Setup the stream descriptor in the external descriptor store
            axi_write(
                'h80000010,
                32'h0000000D,   // Dscrptr Valid, Dest data ready, Inc addr operation
                4'hF
            ); // Configuration register
        
            axi_write(
                'h80000014,
                32'd4096,
                4'hF
            ); // Number of bytes register
            
            axi_write(
                'h80000018,
                32'h40000000,
                4'hF
            ); // Destination address register
            
            // Configure the Stream DEST 01 register in CoreAXI4DMAController memory map
            axi_write(
                DMA_0_BASE_ADDR+'h464, 
                32'h80000010,          // Stream descriptor address
                4'hF                   // Write strobe
            );
        
            wait_irq(
                DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
                0,               // Interrupt number
                6'd33,           // Internal descriptor number
                1,               // External descriptor
                32'h80000010,    // External descriptor address
                4'b0001          // Interrupt status
            );
            clr_irq(
                DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
                0,               // Interrupt number
                4'b0001          // Clear
            );
            $display ($time, "Completed executing test case 5");
        `endif
    end

`ifdef TEST_CASE_6
    $display ($time, "Executing test case 6");
    // Configure interrupt 0 - Allow OpDone, wrError, rdError, invalid BD to generate interrupt
    config_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'hf             // Interrupt mask
    );
    
    // Write the DMA transfer description to BD 0
    config_int_dscrptr(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        'h0,             // Internal descriptor number
        23'd1,           // Number of bytes to transfer
        32'h00000FF0,    // Source address
        2'b01,           // Source operation
        32'h40000FF4,    // Destination address
        2'b01,           // Destination operation
        1'b1,            // Interrupt when this descriptor is processed in a chain
        1'b0,            // Chain
        1'b1,            // src_data_valid
        1'b1,            // dst_data_ready
        1'b0,            // External descriptor next
        32'h00000000     // Next descriptor number/address
    );
    
    // Kick-off the operation by writing to the Start operation register
    start_operation(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0                // Internal descriptor number
    );
    
    // Wait for the associated interrupt output to be asserted
    wait_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        6'd0,           // Internal descriptor number
        0,               // External descriptor
        32'h0,           // External descriptor address
        4'b0001          // Interrupt status
    ); // Opdone status expected
    
    // Clear the interrupt by writing one to the associated bits in the interrupt clear register
    clr_irq(
        DMA_0_BASE_ADDR, // Base addresss of CoreAXI4DMAController instance
        0,               // Interrupt number
        4'b0001          // Clear
    );
    $display ($time, "Completed executing test case 6");
`endif
$display ("****************************************************************");
$display ("** CoreAXI4DMAController - User testbench simulation complete   ");
$display ("****************************************************************");