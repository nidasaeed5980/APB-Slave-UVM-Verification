`include "uvm_macros.svh"
import uvm_pkg::*;


class transection extends uvm_sequence_item;

    // ---------------------------------------------
    // APB signals
    // ---------------------------------------------

    bit                 PRESETn;
    bit                 PSELx;
    bit                 PENABLE;

    rand bit            PWRITE;
    rand bit [63:0]     PWDATA;
    rand bit [7:0]      PSTRB;
    rand bit [31:0]     PADDR;

    logic [63:0]        PRDATA;
    logic               PREADY;
    logic               PSLVERR;


    // ---------------------------------------------
    // Constructor
    // ---------------------------------------------

    function new(string name = "transection");
        super.new(name);
    endfunction


    // ---------------------------------------------
    // Address Constraint
    //
    // Normal APB accesses:
    // 0x0000 - 0xFFF8
    // 8-byte aligned
    //
    // soft is used so error tests can override it
    // ---------------------------------------------

    constraint addr_range_c {

        soft PADDR inside {
            [32'h0000_0000 : 32'h0000_FFF8]
        };

        soft PADDR[2:0] == 3'b000;

    }


    // ---------------------------------------------
    // PSTRB Constraint
    // ---------------------------------------------

    constraint strobe_c {
    if (PWRITE)
        PSTRB inside {[8'h01:8'hFF]};
    else
        PSTRB == 8'h00;
}


    // ---------------------------------------------
    // Write Data Constraint
    // ---------------------------------------------

    constraint data_dist_c {

        PWDATA dist {

            64'h0000_0000_0000_0000 := 10,

            64'hFFFF_FFFF_FFFF_FFFF := 10,

            64'hAAAA_AAAA_AAAA_AAAA := 10,

            64'h5555_5555_5555_5555 := 10,

            64'h0123_4567_89AB_CDEF := 5,

            64'hFEDC_BA98_7654_3210 := 5,

            64'h8000_0000_0000_0000 := 5,

            64'h0000_0000_0000_0001 := 5,

            [64'h0000_0000_0000_0001 :
             64'hFFFF_FFFF_FFFF_FFFE] := 35

        };

    }


    // ---------------------------------------------
    // UVM Factory + Field Registration
    // ---------------------------------------------

    `uvm_object_utils_begin(transection)

        `uvm_field_int(PRESETn,  UVM_DEFAULT)

        `uvm_field_int(PSELx,    UVM_DEFAULT)
        `uvm_field_int(PENABLE,  UVM_DEFAULT)

        `uvm_field_int(PWRITE,   UVM_DEFAULT)
        `uvm_field_int(PWDATA,   UVM_DEFAULT)
        `uvm_field_int(PSTRB,    UVM_DEFAULT)
        `uvm_field_int(PADDR,    UVM_DEFAULT)

        `uvm_field_int(PRDATA,   UVM_DEFAULT)
        `uvm_field_int(PREADY,   UVM_DEFAULT)
        `uvm_field_int(PSLVERR,  UVM_DEFAULT)

    `uvm_object_utils_end


endclass