class apb_driver extends uvm_driver #(transection);

  `uvm_component_utils(apb_driver)

  virtual apb vif;

  function new(input string inst = "apb_driver",
               uvm_component c);
    super.new(inst, c);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    `uvm_info("apb_driver", "build phase", UVM_NONE)

    if (!uvm_config_db#(virtual apb)::get(
          null,
          "uvm_test_top",
          "interface",
          vif
        )) begin

      `uvm_fatal("APB_DRV", "Unable to access interface")

    end
    else begin

      `uvm_info("apb_driver",
                "interface connected",
                UVM_NONE)

    end

  endfunction


  virtual task run_phase(uvm_phase phase);

    forever begin

      // Get transaction from sequencer
      seq_item_port.get_next_item(req);

      // Drive transaction on APB interface
      drive();

      // Tell sequencer transaction is complete
      seq_item_port.item_done();

    end

  endtask


  task drive();

    int cycle;

    cycle = 0;


    // =========================================================
    // SETUP PHASE
    // =========================================================

    @(vif.driver_cb);

    vif.driver_cb.PSELx   <= 1'b1;
    vif.driver_cb.PENABLE <= 1'b0;

    vif.driver_cb.PWRITE  <= req.PWRITE;
    vif.driver_cb.PADDR   <= req.PADDR;
    vif.driver_cb.PWDATA  <= req.PWDATA;
    vif.driver_cb.PSTRB   <= req.PSTRB;


    `uvm_info(
      "APB_DRV",
      $sformatf(
        "SETUP: PADDR=0x%08h PWRITE=%0b PWDATA=0x%016h PSTRB=0x%02h",
        req.PADDR,
        req.PWRITE,
        req.PWDATA,
        req.PSTRB
      ),
      UVM_MEDIUM
    )


    // =========================================================
    // ACCESS PHASE
    // PSEL = 1
    // PENABLE = 1
    // =========================================================

    @(vif.driver_cb);

    vif.driver_cb.PENABLE <= 1'b1;


    // =========================================================
    // WAIT FOR PREADY
    //
    
    // PSTRB    stable
    // =========================================================

    while (vif.driver_cb.PREADY !== 1'b1) begin

      @(vif.driver_cb);

      cycle++;

      if (cycle > 50) begin
        `uvm_fatal(
          "APB_DRV",
          "Timeout: PREADY was not asserted within 50 cycles"
        )
      end

    end


    // =========================================================
    // RESPONSE CAPTURE
    //
    // Transfer completes when:
    // PSEL = 1
    // PENABLE = 1
    // PREADY = 1
    // =========================================================

    if (!req.PWRITE) begin

      req.PRDATA = vif.driver_cb.PRDATA;

      `uvm_info(
        "APB_DRV",
        $sformatf(
          "READ complete: PADDR=0x%08h PRDATA=0x%016h",
          req.PADDR,
          req.PRDATA
        ),
        UVM_MEDIUM
      )

    end
    else begin

      `uvm_info(
        "APB_DRV",
        $sformatf(
          "WRITE complete: PADDR=0x%08h PWDATA=0x%016h",
          req.PADDR,
          req.PWDATA
        ),
        UVM_MEDIUM
      )

    end


    // PSLVERR is valid at the end of ACCESS phase
    // for both READ and WRITE transfers

    req.PSLVERR = vif.driver_cb.PSLVERR;


    if (req.PSLVERR) begin

      `uvm_info(
        "APB_DRV",
        $sformatf(
          "PSLVERR asserted for address 0x%08h",
          req.PADDR
        ),
        UVM_MEDIUM
      )

    end


    // =========================================================
    // END TRANSFER / GO TO IDLE
    //
    // IMPORTANT:
    // No extra @(vif.driver_cb) before deasserting PSEL/PENABLE
    // =========================================================

    vif.driver_cb.PSELx   <= 1'b0;
    vif.driver_cb.PENABLE <= 1'b0;

    vif.driver_cb.PWRITE  <= 1'b0;
    vif.driver_cb.PADDR   <= '0;
    vif.driver_cb.PWDATA  <= '0;
    vif.driver_cb.PSTRB   <= '0;

  endtask


endclass