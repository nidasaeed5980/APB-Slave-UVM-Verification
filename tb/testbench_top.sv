`include "interface.sv"
`include "apb_wrapper.sv"
// `include "uvm_macros.svh"
// import uvm_pkg::*;
module tb_top;
    logic PCLK;
    logic PRESETn;
    initial begin
        PCLK=0;
        forever #5 PCLK=~PCLK;
    end
    
    

    initial begin
        vif.PRESETn = 0;
        vif.PSELx   = 0;
        vif.PENABLE = 0;
        vif.PWRITE  = 0;
        vif.PADDR   = '0;
        vif.PWDATA  = '0;
        vif.PSTRB   = '0;
        #5;
        vif.PRESETn = 1;
        $display("[TB] Reset released at time %0t", $time);
    end
    apb vif (PCLK);
    initial begin
        uvm_config_db #(virtual apb)::set(null, "uvm_test_top", "interface", vif);
        $vcdplusfile("waveform.vpd"); 
        $vcdpluson;
    end
    apb_wrapper dut (
        .PCLK    (PCLK),
        .PRESETn (vif.PRESETn),
        .PSELx   (vif.PSELx),
        .PENABLE (vif.PENABLE),
        .PWRITE  (vif.PWRITE),
        .PWDATA  (vif.PWDATA),
        .PSTRB   (vif.PSTRB),
        .PADDR   (vif.PADDR),
        .PRDATA  (vif.PRDATA),
        .PREADY  (vif.PREADY),
        .PSLVERR (vif.PSLVERR)
    );
  initial begin
  uvm_top.set_timeout(50us, 1);
  run_test();
end
    

endmodule
