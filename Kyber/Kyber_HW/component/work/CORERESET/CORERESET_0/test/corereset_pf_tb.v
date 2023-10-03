`timescale 1ns/100ps

module corereset_pf_tb;

parameter SYSCLK_PERIOD = 100;// 10MHZ

reg SYSCLK;
reg EXT_RST_N;
reg PLL_LOCK;
reg BANK_x_VDDI_STATUS;
reg BANK_y_VDDI_STATUS;
reg FPGA_POR_N;
reg SS_BUSY;
reg INIT_DONE;
reg FF_US_RESTORE;
wire FABRIC_RESET_N;
wire PLL_POWERDOWN_B;


initial
begin
    SYSCLK = 1'b0;
end

//////////////////////////////////////////////////////////////////////
// Reset Pulse
//////////////////////////////////////////////////////////////////////
initial
begin
   ext_rst();
   PLL_LOCK_rst();
   init_done_rst();
   pll_powerdown();
   $stop;
end

task ext_rst;
begin
   $display("External Reset test  :: time is %0t",$time); 
   EXT_RST_N = 1'b1;
   PLL_LOCK = 1'b1;
   SS_BUSY = 1'b1;
   FF_US_RESTORE = 1'b1;
   BANK_x_VDDI_STATUS = 1'b1;
   BANK_y_VDDI_STATUS = 1'b1;
   FPGA_POR_N= 1'b1;
   INIT_DONE = 1'b1;
   #100;
   EXT_RST_N = 1'b0;
   #100;
   FF_US_RESTORE = 1'b0;
   #100;
   SS_BUSY = 1'b0;
   #100;
   if (FABRIC_RESET_N == 1'b0)
      begin 
         $display("External Reset Test Success :: time is %0t",$time);
      end
   else
      begin
        $display("External Reset Test Failed :: time is %0t",$time);
      end
   #100;
    EXT_RST_N = 1'b1;
    begin
    repeat(32)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;
    end
if (FABRIC_RESET_N == 1'b1)
      begin
        $display("External reset deassertion Success :: time is %0t",$time);
      end
else
      begin
        $display("External reset deassertion error:: time is %0t",$time);
      end

end
endtask

task PLL_LOCK_rst;
begin
   $display("PLL_LOCK Reset test  :: time is %0t",$time); 
   EXT_RST_N = 1'b1;
   PLL_LOCK = 1'b1;
   SS_BUSY = 1'b1;
   FF_US_RESTORE = 1'b1;
   BANK_x_VDDI_STATUS = 1'b1;
   BANK_y_VDDI_STATUS = 1'b1;
   FPGA_POR_N= 1'b1;
   INIT_DONE = 1'b1;
   #100;
   PLL_LOCK = 1'b0;
    #100;
   FF_US_RESTORE = 1'b0;
   #100;
   SS_BUSY = 1'b0;
   #100;
   if (FABRIC_RESET_N == 1'b0)
      begin 
         $display("PLL Lock Reset Test Success :: time is %0t",$time);
      end
   else
      begin
        $display("PLL Lock Reset Test Failed :: time is %0t",$time);
      end
   #100;
    PLL_LOCK = 1'b1;
    begin
    repeat(32)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;
    end
if (FABRIC_RESET_N == 1'b1)
      begin
        $display("PLL lock deassertion Success :: time is %0t",$time);
      end
else
      begin
        $display("PLL lock deassertion error:: time is %0t",$time);
      end

end
endtask

task init_done_rst;
begin
   $display("Init Done Reset test  :: time is %0t",$time); 
   EXT_RST_N = 1'b1;
   PLL_LOCK = 1'b1;
   SS_BUSY = 1'b1;
   FF_US_RESTORE = 1'b1;
   BANK_x_VDDI_STATUS = 1'b1;
   BANK_y_VDDI_STATUS = 1'b1;
   FPGA_POR_N= 1'b1;
   INIT_DONE = 1'b1;
   #100;
   INIT_DONE = 1'b0;
   #100;
   FF_US_RESTORE = 1'b0;
   #100;
   SS_BUSY = 1'b0;
   #100;
   if (FABRIC_RESET_N == 1'b0)
      begin 
         $display("Init Done Reset Test Success :: time is %0t",$time);
      end
   else
      begin
        $display("Init Done Reset Test Failed :: time is %0t",$time);
      end
   #100
   INIT_DONE = 1'b1;
    begin
    repeat(32)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;
    end
if (FABRIC_RESET_N == 1'b1)
      begin
        $display("INIT Done deassertion Success :: time is %0t",$time);
      end
else
      begin
        $display("INIT Done deassertion error:: time is %0t",$time);
      end

end
endtask

task pll_powerdown;
begin
$display("PLL_POWERDOWN_B TEST  :: time is %0t",$time); 
#100 BANK_y_VDDI_STATUS = 1'b0;
      FPGA_POR_N= 1'b0;
    #1;   
     if(PLL_POWERDOWN_B == 1'b0)
       begin
         $display("PLL POWERDOWN Success");
       end
    else 
        begin
          $display("PLL POWERDOWN Error");
        end
#100 BANK_y_VDDI_STATUS = 1'b1;
    #1;
     if(PLL_POWERDOWN_B == 1'b0)
       begin
         $display("PLL POWERDOWN Success");
       end
    else 
        begin
          $display("PLL POWERDOWN Error");
        end
#100 FPGA_POR_N = 1'b1;
    #1;
     if(PLL_POWERDOWN_B == 1'b1)
       begin
         $display("PLL POWERDOWN Success");
       end
    else 
        begin
          $display("PLL POWERDOWN Error");
        end
#100 BANK_y_VDDI_STATUS = 1'b0;
    #1;
     if(PLL_POWERDOWN_B == 1'b0)
       begin
         $display("PLL POWERDOWN Success");
       end
    else 
        begin
          $display("PLL POWERDOWN Error");
        end
end
endtask

//////////////////////////////////////////////////////////////////////
// Clock Driver
//////////////////////////////////////////////////////////////////////
always @(SYSCLK)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;


//////////////////////////////////////////////////////////////////////
// Instantiate Unit Under Test:  CORERESET_PF
//////////////////////////////////////////////////////////////////////
CORERESET_CORERESET_0_CORERESET_PF CORERESET_PF_0 (
    .CLK(SYSCLK),
    .EXT_RST_N(EXT_RST_N),
    .PLL_LOCK(PLL_LOCK),
    .BANK_x_VDDI_STATUS(BANK_x_VDDI_STATUS),
    .BANK_y_VDDI_STATUS(BANK_y_VDDI_STATUS),
    .FPGA_POR_N(FPGA_POR_N),
    .SS_BUSY(SS_BUSY),
    .INIT_DONE(INIT_DONE),
    .FF_US_RESTORE(FF_US_RESTORE),

    // Outputs
    .FABRIC_RESET_N(FABRIC_RESET_N ),
    .PLL_POWERDOWN_B(PLL_POWERDOWN_B)
);

endmodule
