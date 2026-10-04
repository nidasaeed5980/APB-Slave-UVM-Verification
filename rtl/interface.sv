
interface apb(input logic PCLK);
    logic                  PRESETn;
    logic                  PSELx;
    logic                  PENABLE;
    logic                  PWRITE;
    logic [63:0]           PWDATA;
    logic [7:0]            PSTRB;
    logic [31:0]           PADDR;
    logic [63:0]           PRDATA;
    logic                  PREADY;
    logic                  PSLVERR;
    clocking driver_cb @(posedge PCLK);
    default input #1 output #1;
    output PSELx;
    output PENABLE;
    output PWRITE;
    output PWDATA;
    output PSTRB;
    output PADDR;
    input  PRDATA; 
    input  PREADY;
    input  PSLVERR;
  endclocking
  
  //---------------------------------------
  //monitor clocking block
  //---------------------------------------
  clocking monitor_cb @(posedge PCLK);
    default input #1 output #1;
    input PSELx;
    input PENABLE;
    input PWRITE;
    input PWDATA;
    input PSTRB;
    input PADDR;
    input  PRDATA; 
    input  PREADY;
    input  PSLVERR;
  endclocking
//   modport DRIVER  (clocking driver_cb,input PCLK,input PRESETn);
  
//   //---------------------------------------
//   //monitor modport  
//   //---------------------------------------
//   modport MONITOR (clocking monitor_cb,input PCLK,input PRESETn);
endinterface