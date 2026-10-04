class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)

  virtual apb vif1;

  uvm_analysis_port #(transection) item_collected_port;

  transection trans_collected;


  function new(string name, uvm_component parent);
    super.new(name, parent);

    item_collected_port =
      new("item_collected_port", this);
  endfunction


  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    `uvm_info(
      "APB_MON",
      "Build Phase Executed",
      UVM_NONE
    )

    if (!uvm_config_db#(virtual apb)::get(
          null,
          "uvm_test_top",
          "interface",
          vif1
        )) begin

      `uvm_fatal(
        "APB_MON",
        "Unable to access interface"
      )

    end
    else begin

      `uvm_info(
        "APB_MON",
        "Interface connected",
        UVM_NONE
      )

    end

  endfunction


  virtual task run_phase(uvm_phase phase);

    forever begin

      @(vif1.monitor_cb);


      // Valid APB transfer completes only when
      // PSEL = 1
      // PENABLE = 1
      // PREADY = 1

      if (vif1.monitor_cb.PSELx   === 1'b1 &&
          vif1.monitor_cb.PENABLE === 1'b1 &&
          vif1.monitor_cb.PREADY  === 1'b1) begin


        // Create NEW transaction for every transfer
        trans_collected = transection::type_id::create(
                            "trans_collected",
                            this
                          );


        // Common APB fields
        trans_collected.PADDR    =vif1.monitor_cb.PADDR;

        trans_collected.PWRITE   = vif1.monitor_cb.PWRITE;

        trans_collected.PSTRB    =vif1.monitor_cb.PSTRB;

        trans_collected.PSLVERR  =vif1.monitor_cb.PSLVERR;

        trans_collected.PSELx    =vif1.monitor_cb.PSELx;

        trans_collected.PENABLE  = vif1.monitor_cb.PENABLE;

        trans_collected.PREADY   = vif1.monitor_cb.PREADY;


        // WRITE transaction
        if (vif1.monitor_cb.PWRITE) begin

          trans_collected.PWDATA =vif1.monitor_cb.PWDATA;

        end


        // READ transaction
        else begin

          trans_collected.PRDATA =vif1.monitor_cb.PRDATA;

        end


        `uvm_info(
          "APB_MON",
          $sformatf(
            "Transaction captured: ADDR=0x%08h WRITE=%0b WDATA=0x%016h RDATA=0x%016h PSLVERR=%0b",
            trans_collected.PADDR,
            trans_collected.PWRITE,
            trans_collected.PWDATA,
            trans_collected.PRDATA,
            trans_collected.PSLVERR
          ),
          UVM_MEDIUM
        )


        // Send ONLY completed transaction
        // to scoreboard/subscribers

        item_collected_port.write( trans_collected);

      end

    end

  endtask : run_phase


endclass