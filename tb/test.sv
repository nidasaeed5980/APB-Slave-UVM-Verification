


class apb_successive_wr_test extends apb_model_base_test;

  `uvm_component_utils(apb_successive_wr_test)


  // ---------------------------------------
  // Sequence instance
  // ---------------------------------------
  apb_successive_wr_sequence seq;


  // ---------------------------------------
  // Constructor
  // ---------------------------------------
  function new(
    string name = "apb_successive_wr_test",
    uvm_component parent = null
  );

    super.new(name, parent);

  endfunction


  // ---------------------------------------
  // Build phase
  // ---------------------------------------
  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq = apb_successive_wr_sequence::type_id::create("seq");

    `uvm_info(
      get_type_name(),
      "Build Phase Executed",
      UVM_LOW
    )

  endfunction


  // ---------------------------------------
  // Run phase
  // ---------------------------------------
  virtual task run_phase(uvm_phase phase);

    `uvm_info(
      get_type_name(),
      "Successive Write/Read Test Started",
      UVM_LOW
    )


    phase.raise_objection(this);


    // Start successive write/read sequence
    seq.start(environment.agent.sequncer);


    phase.drop_objection(this);


    `uvm_info(
      get_type_name(),
      "Successive Write/Read Test Finished",
      UVM_LOW
    )

  endtask


endclass
class apb_b2b_wr_test extends apb_model_base_test;

  `uvm_component_utils(apb_b2b_wr_test)

  // ---------------------------------------
  // Sequence instance
  // ---------------------------------------
  apb_b2b_wr_sequence seq;


  // ---------------------------------------
  // Constructor
  // ---------------------------------------
  function new(
    string name = "apb_b2b_wr_test",
    uvm_component parent = null
  );

    super.new(name, parent);

  endfunction


  // ---------------------------------------
  // Build Phase
  // ---------------------------------------
  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq = apb_b2b_wr_sequence::type_id::create("seq");

    `uvm_info(
      get_type_name(),
      "Build Phase Executed",
      UVM_LOW
    )

  endfunction


  // ---------------------------------------
  // Run Phase
  // ---------------------------------------
  virtual task run_phase(uvm_phase phase);

    `uvm_info(
      get_type_name(),
      "Back-to-Back Write/Read Test Started",
      UVM_LOW
    )

    phase.raise_objection(this);


    // Start b2b sequence
    seq.start(environment.agent.sequncer);


    phase.drop_objection(this);


    `uvm_info(
      get_type_name(),
      "Back-to-Back Write/Read Test Finished",
      UVM_LOW
    )

  endtask


endclass
class apb_slave_error_aor_test extends apb_model_base_test;

  `uvm_component_utils(apb_slave_error_aor_test)

  apb_slave_error_aor_sequence seq;

  function new(string name = "apb_slave_error_aor_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    seq = apb_slave_error_aor_sequence::type_id::create("seq");

    `uvm_info(get_type_name(),
              "Build Phase Executed",
              UVM_LOW)
  endfunction

  virtual task run_phase(uvm_phase phase);

    `uvm_info(get_type_name(),
              "APB Slave Error AOR Test Started",
              UVM_LOW)

    phase.raise_objection(this);

    seq.start(environment.agent.sequncer);

    phase.drop_objection(this);

    `uvm_info(get_type_name(),
              "APB Slave Error AOR Test Finished",
              UVM_LOW)

  endtask

endclass
class apb_random_addr_wr_test extends apb_model_base_test;

  `uvm_component_utils(apb_random_addr_wr_test)

  apb_random_addr_wr_sequence seq;


  function new(string name = "apb_random_addr_wr_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq = apb_random_addr_wr_sequence::type_id::create("seq");

    `uvm_info(get_type_name(),
              "Build Phase Executed",
              UVM_LOW)

  endfunction


  virtual task run_phase(uvm_phase phase);

    `uvm_info(get_type_name(),
              "APB Random Address Write/Read Test Started",
              UVM_LOW)

    phase.raise_objection(this);

    seq.start(environment.agent.sequncer);

    phase.drop_objection(this);

    `uvm_info(get_type_name(),
              "APB Random Address Write/Read Test Finished",
              UVM_LOW)

  endtask

endclass
class apb_strobe_test extends apb_model_base_test;

  `uvm_component_utils(apb_strobe_test)

  apb_strobe_sequence seq;


  function new(string name = "apb_strobe_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq = apb_strobe_sequence::type_id::create("seq");

    `uvm_info(get_type_name(),
              "Build Phase Executed",
              UVM_LOW)

  endfunction


  virtual task run_phase(uvm_phase phase);

    `uvm_info(get_type_name(),
              "APB Strobe Test Started",
              UVM_LOW)

    phase.raise_objection(this);

    seq.start(environment.agent.sequncer);

    phase.drop_objection(this);

    `uvm_info(get_type_name(),
              "APB Strobe Test Finished",
              UVM_LOW)

  endtask

endclass
class apb_addr_misaligned_test extends apb_model_base_test;

  `uvm_component_utils(apb_addr_misaligned_test)

  apb_addr_misaligned_sequence seq;


  function new(string name = "apb_addr_misaligned_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq = apb_addr_misaligned_sequence::type_id::create("seq");

    `uvm_info(get_type_name(),
              "Build Phase Executed",
              UVM_LOW)

  endfunction


  virtual task run_phase(uvm_phase phase);

    `uvm_info(get_type_name(),
              "APB Misaligned Address Test Started",
              UVM_LOW)

    phase.raise_objection(this);

    seq.start(environment.agent.sequncer);

    phase.drop_objection(this);

    `uvm_info(get_type_name(),
              "APB Misaligned Address Test Finished",
              UVM_LOW)

  endtask

endclass
class apb_boundary_test extends apb_model_base_test;

  `uvm_component_utils(apb_boundary_test)

  apb_boundary_sequence seq;


  function new(string name = "apb_boundary_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq = apb_boundary_sequence::type_id::create("seq");

    `uvm_info(get_type_name(),
              "Build Phase Executed",
              UVM_LOW)

  endfunction


  virtual task run_phase(uvm_phase phase);

    `uvm_info(get_type_name(),
              "APB Boundary Test Started",
              UVM_LOW)

    phase.raise_objection(this);

    seq.start(environment.agent.sequncer);

    phase.drop_objection(this);

    `uvm_info(get_type_name(),
              "APB Boundary Test Finished",
              UVM_LOW)

  endtask

endclass
class apb_random_stress_test extends apb_model_base_test;

  `uvm_component_utils(apb_random_stress_test)

  apb_random_stress_sequence seq;


  function new(string name = "apb_random_stress_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    seq = apb_random_stress_sequence::type_id::create("seq");

    `uvm_info(get_type_name(),
              "Build Phase Executed",
              UVM_LOW)

  endfunction


  virtual task run_phase(uvm_phase phase);

    `uvm_info(get_type_name(),
              "APB Random Stress Test Started",
              UVM_LOW)

    phase.raise_objection(this);

    seq.start(environment.agent.sequncer);

    phase.drop_objection(this);

    `uvm_info(get_type_name(),
              "APB Random Stress Test Finished",
              UVM_LOW)

  endtask

endclass
class apb_violation_test extends apb_model_base_test;

  `uvm_component_utils(apb_violation_test)

  virtual apb vif;

  bit [31:0] addr;
  bit [63:0] expected_data;


  function new(string name = "apb_violation_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual apb)::get(
          null, "uvm_test_top", "interface", vif)) begin

      `uvm_fatal("APB_VIOL_TEST",
                 "Virtual interface not found")

    end

    `uvm_info(get_type_name(),
              "Build Phase Executed",
              UVM_LOW)

  endfunction


  // ============================================================
  // LEGAL WRITE
  // ============================================================
  task legal_write(
    bit [31:0] address,
    bit [63:0] data
  );

    @(posedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b1;
    vif.PADDR   = address;
    vif.PWDATA  = data;
    vif.PSTRB   = 8'hFF;


    @(posedge vif.PCLK);

    vif.PENABLE = 1'b1;


    while (vif.PREADY !== 1'b1)
      @(posedge vif.PCLK);


    @(posedge vif.PCLK);

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;

  endtask


  // ============================================================
  // ILLEGAL WRITE
  // PENABLE ALWAYS 0
  // ============================================================
  task illegal_write(
    bit [31:0] address,
    bit [63:0] data
  );

    `uvm_info("APB_VIOL_TEST",
              "Illegal WRITE started with PENABLE=0",
              UVM_LOW)

    @(posedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b1;
    vif.PADDR   = address;
    vif.PWDATA  = data;
    vif.PSTRB   = 8'hFF;


    // Keep enable OFF
    repeat (4) begin

      @(posedge vif.PCLK);

      vif.PENABLE = 1'b0;

      if (vif.PREADY === 1'b1) begin

        `uvm_error("APB_VIOL_TEST",
                   "FAIL: Slave completed WRITE while PENABLE=0")

      end

    end


    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;

    @(posedge vif.PCLK);

  endtask


  // ============================================================
  // LEGAL READ AND DATA CHECK
  // ============================================================
  task legal_read_check(
    bit [31:0] address,
    bit [63:0] expected
  );

    bit [63:0] actual;


    @(posedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;
    vif.PADDR   = address;
    vif.PWDATA  = '0;
    vif.PSTRB   = 8'h00;


    @(posedge vif.PCLK);

    vif.PENABLE = 1'b1;


    while (vif.PREADY !== 1'b1)
      @(posedge vif.PCLK);


    actual = vif.PRDATA;


    if (actual === expected) begin

      `uvm_info("APB_VIOL_TEST",
                $sformatf(
                  "READ MATCH: EXPECTED=0x%016h ACTUAL=0x%016h",
                  expected,
                  actual),
                UVM_LOW)

    end
    else begin

      `uvm_error("APB_VIOL_TEST",
                 $sformatf(
                   "READ MISMATCH: EXPECTED=0x%016h ACTUAL=0x%016h",
                   expected,
                   actual))

    end


    @(posedge vif.PCLK);

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;

  endtask


  // ============================================================
  // ILLEGAL READ
  // PENABLE ALWAYS 0
  // ============================================================
  task illegal_read(
    bit [31:0] address
  );

    `uvm_info("APB_VIOL_TEST",
              "Illegal READ started with PENABLE=0",
              UVM_LOW)

    @(posedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;
    vif.PADDR   = address;
    vif.PWDATA  = '0;
    vif.PSTRB   = 8'h00;


    repeat (4) begin

      @(posedge vif.PCLK);

      vif.PENABLE = 1'b0;

      if (vif.PREADY === 1'b1) begin

        `uvm_error("APB_VIOL_TEST",
                   "FAIL: Slave completed READ while PENABLE=0")

      end

    end


    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;

    @(posedge vif.PCLK);

  endtask


  // ============================================================
  // RUN PHASE
  // ============================================================
  virtual task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    `uvm_info(get_type_name(),
              "APB Violation Test Started",
              UVM_LOW)


    addr          = 32'h0000_0300;
    expected_data = 64'h1111_2222_3333_4444;


    // Legal initialization
    legal_write(
      addr,
      expected_data
    );


    // Try illegal write with PENABLE = 0
    illegal_write(
      addr,
      64'hAAAA_BBBB_CCCC_DDDD
    );


    // Verify illegal write did NOT happen
    legal_read_check(
      addr,
      expected_data
    );


    // Try illegal read with PENABLE = 0
    illegal_read(
      addr
    );


    `uvm_info(get_type_name(),
              "APB Violation Test Finished",
              UVM_LOW)

    phase.drop_objection(this);

  endtask

endclass
class apb_reset_test extends apb_model_base_test;

  `uvm_component_utils(apb_reset_test)

  virtual apb vif;

  bit [31:0] addr;


  function new(string name = "apb_reset_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual apb)::get(
         null, "uvm_test_top", "interface", vif)) begin

      `uvm_fatal("APB_RESET_TEST",
                 "Virtual interface not found")

    end

    `uvm_info(get_type_name(),
              "Build Phase Executed",
              UVM_LOW)

  endfunction


  virtual task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    `uvm_info(get_type_name(),
              "APB Reset Test Started",
              UVM_LOW)

    addr = 32'h0000_0100;


    // =========================================================
    // STEP 1: ASSERT RESET
    // =========================================================
    @(negedge vif.PCLK);

    vif.PRESETn = 1'b0;

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;
    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;


    // Allow reset to be sampled
    repeat (2)
      @(posedge vif.PCLK);


    `uvm_info("APB_RESET_TEST",
              $sformatf("Reset asserted: PRESETn=%b",
                        vif.PRESETn),
              UVM_LOW)


    // =========================================================
    // STEP 2: WRITE ATTEMPT DURING RESET
    // =========================================================
    `uvm_info("APB_RESET_TEST",
              "Write attempt while PRESETn=0",
              UVM_LOW)


    @(negedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b1;
    vif.PADDR   = addr;
    vif.PWDATA  = 64'hAAAA_BBBB_CCCC_DDDD;
    vif.PSTRB   = 8'hFF;


    @(negedge vif.PCLK);

    vif.PENABLE = 1'b1;


    // Keep write attempt for some clocks
    repeat (2)
      @(posedge vif.PCLK);


    // =========================================================
    // Return to idle
    // =========================================================
    @(negedge vif.PCLK);

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;


    // =========================================================
    // STEP 3: READ ATTEMPT DURING RESET
    // =========================================================
    `uvm_info("APB_RESET_TEST",
              "Read attempt while PRESETn=0",
              UVM_LOW)


    @(negedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;
    vif.PADDR   = addr;
    vif.PWDATA  = '0;
    vif.PSTRB   = 8'h00;


    @(negedge vif.PCLK);

    vif.PENABLE = 1'b1;


    // Keep read attempt active
    repeat (2)
      @(posedge vif.PCLK);


    // =========================================================
    // PASS CONDITION
    //
    // RTL behavior during RESET / IDLE:
    //
    // PRDATA  = Z
    // PREADY  = 0
    // PSLVERR = 0
    // =========================================================
    if ((vif.PRDATA  === 64'hzzzz_zzzz_zzzz_zzzz) &&
        (vif.PREADY  === 1'b0) &&
        (vif.PSLVERR === 1'b0)) begin

      `uvm_info("APB_RESET_TEST",
                $sformatf(
                  "PASS: Reset values correct PRDATA=%h PREADY=%b PSLVERR=%b",
                  vif.PRDATA,
                  vif.PREADY,
                  vif.PSLVERR),
                UVM_LOW)

    end
    else begin

      `uvm_error("APB_RESET_TEST",
                 $sformatf(
                   "FAIL: Reset values incorrect PRDATA=%h PREADY=%b PSLVERR=%b",
                   vif.PRDATA,
                   vif.PREADY,
                   vif.PSLVERR))

    end


    // =========================================================
    // RELEASE BUS SIGNALS
    // =========================================================
    @(negedge vif.PCLK);

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;
    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;


    `uvm_info(get_type_name(),
              "APB Reset Test Finished",
              UVM_LOW)

    phase.drop_objection(this);

  endtask

endclass

class apb_reset_while_trans_test extends apb_model_base_test;

  `uvm_component_utils(apb_reset_while_trans_test)

  virtual apb vif;

  bit [31:0] addr;


  function new(string name = "apb_reset_while_trans_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(virtual apb)::get(
         null, "uvm_test_top", "interface", vif)) begin

      `uvm_fatal("APB_RESET_TRANS_TEST",
                 "Virtual interface not found")

    end

    `uvm_info(get_type_name(),
              "Build Phase Executed",
              UVM_LOW)

  endfunction


  virtual task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    `uvm_info(get_type_name(),
              "APB Reset While Transaction Test Started",
              UVM_LOW)

    addr = 32'h0000_0400;


    // =========================================================
    // Make sure reset is initially released
    // =========================================================
    @(negedge vif.PCLK);

    vif.PRESETn = 1'b1;

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;
    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;

    repeat (2)
      @(posedge vif.PCLK);


    // =========================================================
    // STEP 1: START WRITE TRANSACTION
    // =========================================================
    `uvm_info("APB_RESET_TRANS_TEST",
              "Starting WRITE transaction",
              UVM_LOW)

    // SETUP phase
    @(negedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b1;
    vif.PADDR   = addr;
    vif.PWDATA  = 64'hAAAA_BBBB_CCCC_DDDD;
    vif.PSTRB   = 8'hFF;


    // ACCESS phase
    @(negedge vif.PCLK);

    vif.PENABLE = 1'b1;


    // =========================================================
    // STEP 2:
    // ASSERT RESET WHILE PENABLE IS HIGH
    // =========================================================
    @(negedge vif.PCLK);

    `uvm_info("APB_RESET_TRANS_TEST",
              $sformatf(
                "Asserting RESET during transaction: PENABLE=%b",
                vif.PENABLE),
              UVM_LOW)

    vif.PRESETn = 1'b0;


    // Keep reset asserted for few clocks
    repeat (2)
      @(posedge vif.PCLK);


    // =========================================================
    // Check reset state
    // =========================================================
    if ((vif.PRDATA  === 64'hzzzz_zzzz_zzzz_zzzz) &&
        (vif.PREADY  === 1'b0) &&
        (vif.PSLVERR === 1'b0)) begin

      `uvm_info("APB_RESET_TRANS_TEST",
                $sformatf(
                  "RESET STATE OK: PRDATA=%h PREADY=%b PSLVERR=%b",
                  vif.PRDATA,
                  vif.PREADY,
                  vif.PSLVERR),
                UVM_LOW)

    end
    else begin

      `uvm_error("APB_RESET_TRANS_TEST",
                 $sformatf(
                   "RESET STATE WRONG: PRDATA=%h PREADY=%b PSLVERR=%b",
                   vif.PRDATA,
                   vif.PREADY,
                   vif.PSLVERR))

    end


    // =========================================================
    // End interrupted transaction
    // =========================================================
    @(negedge vif.PCLK);

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;
    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;


    // =========================================================
    // RELEASE RESET
    // =========================================================
    @(negedge vif.PCLK);

    vif.PRESETn = 1'b1;

    repeat (2)
      @(posedge vif.PCLK);


    `uvm_info("APB_RESET_TRANS_TEST",
              "Reset released - starting READ",
              UVM_LOW)


    // =========================================================
    // STEP 3: PERFORM READ AFTER RESET
    // =========================================================

    // SETUP
    @(negedge vif.PCLK);

    vif.PSELx   = 1'b1;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;
    vif.PADDR   = addr;
    vif.PWDATA  = '0;
    vif.PSTRB   = 8'h00;


    // ACCESS
    @(negedge vif.PCLK);

    vif.PENABLE = 1'b1;


    // Wait for normal read completion
    while (vif.PREADY !== 1'b1)
      @(posedge vif.PCLK);


    // =========================================================
    // PASS CONDITION
    //
    // Interrupted write must NOT complete.
    //
    // Since memory itself is not initialized by reset,
    // PRDATA may be X/Z for an unwritten address.
    // The important check is that AAAA... was NOT written.
    // =========================================================
    if (vif.PRDATA !== 64'hAAAA_BBBB_CCCC_DDDD) begin

      `uvm_info("APB_RESET_TRANS_TEST",
                $sformatf(
                  "PASS: Interrupted WRITE did not complete. PRDATA=%h",
                  vif.PRDATA),
                UVM_LOW)

    end
    else begin

      `uvm_error("APB_RESET_TRANS_TEST",
                 $sformatf(
                   "FAIL: WRITE completed despite reset. PRDATA=%h",
                   vif.PRDATA))

    end


    // =========================================================
    // Return bus to idle
    // =========================================================
    @(negedge vif.PCLK);

    vif.PSELx   = 1'b0;
    vif.PENABLE = 1'b0;
    vif.PWRITE  = 1'b0;
    vif.PADDR   = '0;
    vif.PWDATA  = '0;
    vif.PSTRB   = '0;


    `uvm_info(get_type_name(),
              "APB Reset While Transaction Test Finished",
              UVM_LOW)

    phase.drop_objection(this);

  endtask

endclass
