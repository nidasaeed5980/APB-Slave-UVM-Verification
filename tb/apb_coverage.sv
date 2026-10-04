class apb_coverage extends uvm_subscriber #(transection);

  `uvm_component_utils(apb_coverage)

  transection tr;


  // ============================================================
  // COVERGROUP
  // ============================================================
  covergroup apb_cg;

    option.per_instance = 1;


    // ----------------------------------------------------------
    // READ / WRITE
    // ----------------------------------------------------------
    cp_write : coverpoint tr.PWRITE {
      bins READ  = {0};
      bins WRITE = {1};
    }


    // ----------------------------------------------------------
    // ADDRESS COVERAGE
    // Valid memory range = 0x0000_0000 - 0x0000_FFFF
    // ----------------------------------------------------------
    cp_addr : coverpoint tr.PADDR {

      bins low_boundary  = {32'h0000_0000};

      bins low_region    =
        {[32'h0000_0008 : 32'h0000_3FF8]};

      bins mid_region    =
        {[32'h0000_4000 : 32'h0000_BFF8]};

      bins high_region   =
        {[32'h0000_C000 : 32'h0000_FFF0]};

      bins high_boundary = {32'h0000_FFF8};

      bins out_of_range  =
        {[32'h0001_0000 : 32'hFFFF_FFFF]};
    }


    // ----------------------------------------------------------
    // ADDRESS ALIGNMENT
    // 64-bit bus => valid address aligned to 8 bytes
    // ----------------------------------------------------------
    cp_alignment : coverpoint tr.PADDR[2:0] {

      bins aligned = {3'b000};

      bins misaligned[] = {
        3'b001,
        3'b010,
        3'b011,
        3'b100,
        3'b101,
        3'b110,
        3'b111
      };

    }


    // ----------------------------------------------------------
    // WRITE STROBE
    // ----------------------------------------------------------
    cp_strobe : coverpoint tr.PSTRB iff (tr.PWRITE) {

      bins full_write   = {8'hFF};

      bins byte0        = {8'h01};
      bins byte7        = {8'h80};

      bins lower_half   = {8'h0F};
      bins upper_half   = {8'hF0};

      bins alternate_55 = {8'h55};

      bins other_strobe = default;
    }


    // ----------------------------------------------------------
    // SLAVE ERROR
    // ----------------------------------------------------------
    cp_slverr : coverpoint tr.PSLVERR {

      bins no_error = {0};
      bins error    = {1};

    }


    // ----------------------------------------------------------
    // CROSS COVERAGE
    // READ / WRITE vs ERROR
    // ----------------------------------------------------------
    write_error_cross : cross cp_write, cp_slverr;


    // ----------------------------------------------------------
    // READ / WRITE vs ADDRESS ALIGNMENT
    // ----------------------------------------------------------
    write_alignment_cross :
      cross cp_write, cp_alignment;


  endgroup



  // ============================================================
  // CONSTRUCTOR
  // ============================================================
  function new(string name = "apb_coverage",
               uvm_component parent = null);

    super.new(name, parent);

    apb_cg = new();

  endfunction



  // ============================================================
  // MONITOR TRANSACTION RECEIVED HERE
  // ============================================================
  virtual function void write(transection t);

    tr = t;

    apb_cg.sample();

    `uvm_info("APB_COV",
              $sformatf(
                "Coverage Sampled: ADDR=0x%08h WRITE=%0b PSTRB=0x%02h PSLVERR=%0b",
                tr.PADDR,
                tr.PWRITE,
                tr.PSTRB,
                tr.PSLVERR),
              UVM_HIGH)

  endfunction


  // ============================================================
  // REPORT COVERAGE
  // ============================================================
  virtual function void report_phase(uvm_phase phase);

    super.report_phase(phase);

    `uvm_info("APB_COV",
              $sformatf(
                "APB Functional Coverage = %0.2f%%",
                apb_cg.get_inst_coverage()),
              UVM_LOW)

  endfunction


endclass