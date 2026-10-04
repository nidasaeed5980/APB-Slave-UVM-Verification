class apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp #(transection, apb_scoreboard) item_collected_export;

  transection pkt_qu[$];

  // 64 KB memory / 8 bytes per location = 8192 locations
  logic [63:0] sc_mem [8192];

  // Tracks which bytes have actually been written
  bit [7:0] byte_valid [8192];


  function new(string name = "apb_scoreboard",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction


  // ---------------------------------------------------------
  // BUILD PHASE
  // ---------------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    item_collected_export =
      new("item_collected_export", this);

    // DUT memory itself is not reset/initialized,
    // therefore don't assume unwritten locations contain 0.
    foreach (sc_mem[i]) begin
      sc_mem[i]     = '0;
      byte_valid[i] = '0;
    end

    `uvm_info("APB_SB",
              "Scoreboard Build Phase Executed",
              UVM_LOW)

  endfunction


  // ---------------------------------------------------------
  // ANALYSIS WRITE
  // Monitor sends completed transactions here
  // ---------------------------------------------------------
  virtual function void write(transection pkt);

    transection pkt_copy;

    pkt_copy = transection::type_id::create("pkt_copy");

    pkt_copy.copy(pkt);

    pkt_qu.push_back(pkt_copy);

  endfunction


  // ---------------------------------------------------------
  // Helper:
  // Address should produce PSLVERR when:
  //
  // 1. Address is outside 64 KB memory
  // 2. Address is not 8-byte aligned
  // ---------------------------------------------------------
  function bit expected_error(logic [31:0] addr);

    if (addr > 32'h0000_FFFF)
      return 1'b1;

    if (addr[2:0] != 3'b000)
      return 1'b1;

    return 1'b0;

  endfunction


  // ---------------------------------------------------------
  // RUN PHASE
  // ---------------------------------------------------------
  virtual task run_phase(uvm_phase phase);

    transection mem_pkt;

    int unsigned index;

    bit exp_error;


    forever begin

      wait(pkt_qu.size() > 0);

      mem_pkt = pkt_qu.pop_front();


      // -----------------------------------------------------
      // Determine whether this address SHOULD generate error
      // -----------------------------------------------------
      exp_error = expected_error(mem_pkt.PADDR);


      // =====================================================
      // ERROR ACCESS
      // =====================================================
      if (exp_error) begin

        if (mem_pkt.PSLVERR === 1'b1) begin

          `uvm_info(
            "APB_SB",
            $sformatf(
              "EXPECTED PSLVERR: ADDR=0x%08h WRITE=%0b",
              mem_pkt.PADDR,
              mem_pkt.PWRITE
            ),
            UVM_LOW
          )

        end
        else begin

          `uvm_error(
            "APB_SB",
            $sformatf(
              "ERROR RESPONSE MISSING: ADDR=0x%08h WRITE=%0b EXPECTED_PSLVERR=1 ACTUAL_PSLVERR=%b",
              mem_pkt.PADDR,
              mem_pkt.PWRITE,
              mem_pkt.PSLVERR
            )
          )

        end

        // Never access scoreboard memory using illegal address
        continue;

      end


      // =====================================================
      // VALID ADDRESS but DUT returned PSLVERR
      // =====================================================
      if (mem_pkt.PSLVERR !== 1'b0) begin

        `uvm_error(
          "APB_SB",
          $sformatf(
            "UNEXPECTED PSLVERR: VALID ADDR=0x%08h WRITE=%0b PSLVERR=%b",
            mem_pkt.PADDR,
            mem_pkt.PWRITE,
            mem_pkt.PSLVERR
          )
        )

        continue;

      end


      // -----------------------------------------------------
      // Convert byte address to 64-bit memory index
      // -----------------------------------------------------
      index = mem_pkt.PADDR >> 3;


      // Defensive check
      if (index >= 8192) begin

        `uvm_error(
          "APB_SB",
          $sformatf(
            "INTERNAL SCOREBOARD INDEX ERROR: ADDR=0x%08h INDEX=%0d",
            mem_pkt.PADDR,
            index
          )
        )

        continue;

      end


      // =====================================================
      // WRITE
      // =====================================================
      if (mem_pkt.PWRITE) begin

        for (int byte_lane = 0;
             byte_lane < 8;
             byte_lane++) begin

          if (mem_pkt.PSTRB[byte_lane]) begin

            sc_mem[index][8*byte_lane +: 8]
              = mem_pkt.PWDATA[8*byte_lane +: 8];

            byte_valid[index][byte_lane]
              = 1'b1;

          end

        end


        `uvm_info(
          "APB_SB",
          $sformatf(
            "WRITE: ADDR=0x%08h INDEX=%0d PSTRB=0x%02h DATA=0x%016h EXPECTED_MEM=0x%016h VALID_BYTES=0x%02h",
            mem_pkt.PADDR,
            index,
            mem_pkt.PSTRB,
            mem_pkt.PWDATA,
            sc_mem[index],
            byte_valid[index]
          ),
          UVM_LOW
        )

      end


      // =====================================================
      // READ
      // =====================================================
      else begin

        bit mismatch;

        mismatch = 1'b0;


        // Compare only bytes whose expected value is known.
        //
        // Important:
        // mem_1024x32 does not initialize its memory array
        // during reset. Therefore an unwritten byte can legally
        // be X in simulation.
        for (int byte_lane = 0;
             byte_lane < 8;
             byte_lane++) begin

          if (byte_valid[index][byte_lane]) begin

            if (mem_pkt.PRDATA[8*byte_lane +: 8]
                !==
                sc_mem[index][8*byte_lane +: 8]) begin

              mismatch = 1'b1;

              `uvm_error(
                "APB_SB",
                $sformatf(
                  "READ BYTE MISMATCH: ADDR=0x%08h INDEX=%0d BYTE=%0d EXPECTED=0x%02h ACTUAL=0x%02h",
                  mem_pkt.PADDR,
                  index,
                  byte_lane,
                  sc_mem[index][8*byte_lane +: 8],
                  mem_pkt.PRDATA[8*byte_lane +: 8]
                )
              )

            end

          end

        end


        if (!mismatch) begin

          // At least one known byte exists
          if (byte_valid[index] != 8'h00) begin

            `uvm_info(
              "APB_SB",
              $sformatf(
                "READ MATCH: ADDR=0x%08h INDEX=%0d EXPECTED=0x%016h ACTUAL=0x%016h VALID_BYTES=0x%02h",
                mem_pkt.PADDR,
                index,
                sc_mem[index],
                mem_pkt.PRDATA,
                byte_valid[index]
              ),
              UVM_LOW
            )

          end

          // Nothing has ever been written at this location
          else begin

            `uvm_info(
              "APB_SB",
              $sformatf(
                "READ FROM UNWRITTEN LOCATION: ADDR=0x%08h INDEX=%0d PRDATA=0x%016h -- comparison skipped",
                mem_pkt.PADDR,
                index,
                mem_pkt.PRDATA
              ),
              UVM_LOW
            )

          end

        end

      end

    end

  endtask

endclass