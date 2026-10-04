class apb_sequence extends uvm_sequence#(transection);
  
  `uvm_object_utils(apb_sequence)
  
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "apb_sequence");
    super.new(name);
  endfunction
  
  `uvm_declare_p_sequencer(apb_sequencer)
  
  //---------------------------------------
  // create, randomize and send the item to driver
  //---------------------------------------
  virtual task body();
   repeat(2) begin
    req = transection::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
   end 
  endtask
  endclass
 class apb_successive_wr_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_successive_wr_sequence)

  function new(string name = "apb_successive_wr_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transection req;

    bit [31:0] addr;
    bit [63:0] data;


    `uvm_info(
      get_type_name(),
      "Successive Write/Read Sequence Started",
      UVM_LOW
    )


    // =====================================================
    // WRITE FULL MEMORY
    //
    // Valid aligned address range:
    // 0x0000 to 0xFFF8
    // Increment = 8 bytes
    // =====================================================

    for (int i = 0; i < 31; i++) begin

      addr = i * 8;

      // simple unique data for each address
      data = 64'h1000_0000_0000_0000 + i;


      req = transection::type_id::create(
              $sformatf("write_req_%0d", i)
            );


      start_item(req);

      req.PWRITE = 1'b1;
      req.PADDR  = addr;
      req.PWDATA = data;
      req.PSTRB  = 8'hFF;

      finish_item(req);

    end


    `uvm_info(
      get_type_name(),
      "All successive WRITE transactions completed",
      UVM_LOW
    )


    // =====================================================
    // READ FULL MEMORY
    //
    // Read same addresses again
    // Scoreboard will compare PRDATA with reference memory
    // =====================================================

    for (int i = 0; i < 31; i++) begin

      addr = i * 8;


      req = transection::type_id::create(
              $sformatf("read_req_%0d", i)
            );


      start_item(req);

      req.PWRITE = 1'b0;
      req.PADDR  = addr;
      req.PSTRB  = 8'h00;

      finish_item(req);

    end


    `uvm_info(
      get_type_name(),
      "Successive Write/Read Sequence Finished",
      UVM_LOW
    )

  endtask


endclass

class apb_b2b_wr_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_b2b_wr_sequence)

  // ---------------------------------------
  // Constructor
  // ---------------------------------------
  function new(string name = "apb_b2b_wr_sequence");
    super.new(name);
  endfunction


  // ---------------------------------------
  // Body
  // ---------------------------------------
  virtual task body();

    transection req;

    bit [31:0] target_addr;
    bit [63:0] write_data;


    `uvm_info(
      get_type_name(),
      "Back-to-Back Write/Read Sequence Started",
      UVM_LOW
    )


    // Use one valid aligned address
    target_addr = 32'h0000_0100;


    // =====================================================
    // Multiple WRITE -> READ operations on same address
    // =====================================================

    for (int i = 0; i < 10; i++) begin

      // Different data every time
      write_data = 64'hA000_0000_0000_0000 + i;


      // ===================================================
      // WRITE
      // ===================================================

      req = transection::type_id::create(
              $sformatf("b2b_write_req_%0d", i)
            );

      start_item(req);

      req.PWRITE = 1'b1;
      req.PADDR  = target_addr;
      req.PWDATA = write_data;
      req.PSTRB  = 8'hFF;

      finish_item(req);


      // ===================================================
      // READ SAME ADDRESS
      // ===================================================

      req = transection::type_id::create(
              $sformatf("b2b_read_req_%0d", i)
            );

      start_item(req);

      req.PWRITE = 1'b0;
      req.PADDR  = target_addr;
      req.PSTRB  = 8'h00;

      finish_item(req);

    end


    `uvm_info(
      get_type_name(),
      "Back-to-Back Write/Read Sequence Finished",
      UVM_LOW
    )

  endtask


endclass
class apb_slave_error_aor_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_slave_error_aor_sequence)

  function new(string name = "apb_slave_error_aor_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transection req;

    `uvm_info(get_type_name(),
              "APB Slave Error Sequence Started",
              UVM_LOW)


    // =========================================================
    // CASE 1: OUT OF RANGE WRITE
    // Valid range = 0x0000_0000 to 0x0000_FFFF
    // Expected: PSLVERR = 1
    // =========================================================
    req = transection::type_id::create("aor_write_req_0");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = 32'h0001_0000;
    req.PWDATA = 64'hAAAA_BBBB_CCCC_DDDD;
    req.PSTRB  = 8'hFF;

    finish_item(req);


    // =========================================================
    // CASE 2: OUT OF RANGE READ
    // Expected: PSLVERR = 1
    // =========================================================
    req = transection::type_id::create("aor_read_req_0");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = 32'h0001_0000;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    // =========================================================
    // CASE 3: ANOTHER OUT OF RANGE WRITE
    // Expected: PSLVERR = 1
    // =========================================================
    req = transection::type_id::create("aor_write_req_1");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = 32'h0001_0008;
    req.PWDATA = 64'h1111_2222_3333_4444;
    req.PSTRB  = 8'hFF;

    finish_item(req);


    // =========================================================
    // CASE 4: ANOTHER OUT OF RANGE READ
    // Expected: PSLVERR = 1
    // =========================================================
    req = transection::type_id::create("aor_read_req_1");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = 32'h0001_0008;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    // =========================================================
    // CASE 5: MISALIGNED WRITE
    // Expected: PSLVERR = 1
    // =========================================================
    req = transection::type_id::create("misaligned_write_req");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = 32'h0000_0004;
    req.PWDATA = 64'h5555_AAAA_1234_5678;
    req.PSTRB  = 8'hFF;

    finish_item(req);


    // =========================================================
    // CASE 6: MISALIGNED READ
    // Expected: PSLVERR = 1
    // =========================================================
    req = transection::type_id::create("misaligned_read_req");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = 32'h0000_0004;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    // =========================================================
    // EXTRA CASES FOR CODE COVERAGE
    //
    // Toggle addr[31:17]
    // All generated addresses are outside 64KB range
    // Expected: PSLVERR = 1
    // =========================================================
    for (int bit_no = 17; bit_no <= 31; bit_no++) begin

      // -------------------------------------------------------
      // HIGH OUT-OF-RANGE WRITE
      // -------------------------------------------------------
      req = transection::type_id::create(
              $sformatf("high_aor_write_%0d", bit_no));

      start_item(req);

      req.PWRITE = 1'b1;
      req.PADDR  = (32'h1 << bit_no);
      req.PWDATA = 64'hAAAA_0000_0000_0000 + bit_no;
      req.PSTRB  = 8'hFF;

      finish_item(req);


      // -------------------------------------------------------
      // HIGH OUT-OF-RANGE READ
      // -------------------------------------------------------
      req = transection::type_id::create(
              $sformatf("high_aor_read_%0d", bit_no));

      start_item(req);

      req.PWRITE = 1'b0;
      req.PADDR  = (32'h1 << bit_no);
      req.PWDATA = '0;
      req.PSTRB  = 8'h00;

      finish_item(req);

    end


    `uvm_info(get_type_name(),
              "APB Slave Error Sequence Finished",
              UVM_LOW)

  endtask

endclass
class apb_random_addr_wr_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_random_addr_wr_sequence)

  function new(string name = "apb_random_addr_wr_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transection req;

    bit [31:0] addr;
    bit [63:0] data;

    `uvm_info(get_type_name(),
              "APB Random Address Write/Read Sequence Started",
              UVM_LOW)


    // 20 random valid accesses
    repeat (20) begin

      // -------------------------------------------------------
      // Generate random valid aligned address
      // Range: 0x0000_0000 to 0x0000_FFF8
      // Alignment: 8-byte
      // -------------------------------------------------------
      addr = $urandom_range(0, 8191) * 8;

      // Random 64-bit data
      data = {$urandom(), $urandom()};


      // =======================================================
      // WRITE
      // =======================================================
      req = transection::type_id::create("random_write_req");

      start_item(req);

      req.PWRITE = 1'b1;
      req.PADDR  = addr;
      req.PWDATA = data;
      req.PSTRB  = 8'hFF;

      finish_item(req);


      // =======================================================
      // READ SAME ADDRESS
      // =======================================================
      req = transection::type_id::create("random_read_req");

      start_item(req);

      req.PWRITE = 1'b0;
      req.PADDR  = addr;
      req.PWDATA = '0;
      req.PSTRB  = 8'h00;

      finish_item(req);

    end


    `uvm_info(get_type_name(),
              "APB Random Address Write/Read Sequence Finished",
              UVM_LOW)

  endtask

endclass
class apb_strobe_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_strobe_sequence)

  function new(string name = "apb_strobe_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transection req;

    bit [31:0] addr;

    `uvm_info(get_type_name(),
              "APB Strobe Sequence Started",
              UVM_LOW)

    // Use one valid aligned address
    addr = 32'h0000_0200;


    // =========================================================
    // STEP 1: Initialize complete 64-bit location
    // Initial expected memory:
    // 11 22 33 44 55 66 77 88
    // =========================================================
    req = transection::type_id::create("initial_full_write");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = addr;
    req.PWDATA = 64'h1122_3344_5566_7788;
    req.PSTRB  = 8'hFF;

    finish_item(req);


    // Read initial value
    req = transection::type_id::create("initial_read");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = addr;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    // =========================================================
    // STEP 2: Update only BYTE 0
    //
    // PSTRB = 0000_0001
    // PWDATA byte0 = AA
    //
    // Expected:
    // 11 22 33 44 55 66 77 AA
    // =========================================================
    req = transection::type_id::create("strobe_byte0_write");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = addr;
    req.PWDATA = 64'h0000_0000_0000_00AA;
    req.PSTRB  = 8'b0000_0001;

    finish_item(req);


    req = transection::type_id::create("strobe_byte0_read");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = addr;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    // =========================================================
    // STEP 3: Update only BYTE 7
    //
    // PSTRB = 1000_0000
    //
    // Expected:
    // BB 22 33 44 55 66 77 AA
    // =========================================================
    req = transection::type_id::create("strobe_byte7_write");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = addr;
    req.PWDATA = 64'hBB00_0000_0000_0000;
    req.PSTRB  = 8'b1000_0000;

    finish_item(req);


    req = transection::type_id::create("strobe_byte7_read");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = addr;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    // =========================================================
    // STEP 4: Update lower 4 bytes
    //
    // PSTRB = 0000_1111
    //
    // Expected:
    // BB 22 33 44 DE AD BE EF
    // =========================================================
    req = transection::type_id::create("strobe_lower4_write");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = addr;
    req.PWDATA = 64'h0000_0000_DEAD_BEEF;
    req.PSTRB  = 8'b0000_1111;

    finish_item(req);


    req = transection::type_id::create("strobe_lower4_read");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = addr;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    // =========================================================
    // STEP 5: Update upper 4 bytes
    //
    // PSTRB = 1111_0000
    //
    // Expected:
    // CA FE BA BE DE AD BE EF
    // =========================================================
    req = transection::type_id::create("strobe_upper4_write");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = addr;
    req.PWDATA = 64'hCAFE_BABE_0000_0000;
    req.PSTRB  = 8'b1111_0000;

    finish_item(req);


    req = transection::type_id::create("strobe_upper4_read");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = addr;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    // =========================================================
    // STEP 6: Alternate byte lanes
    //
    // PSTRB = 0101_0101
    // Enables byte lanes 0,2,4,6
    // =========================================================
    req = transection::type_id::create("strobe_alternate_write");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = addr;
    req.PWDATA = 64'h0102_0304_0506_0708;
    req.PSTRB  = 8'b0101_0101;

    finish_item(req);


    req = transection::type_id::create("strobe_alternate_read");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = addr;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    `uvm_info(get_type_name(),
              "APB Strobe Sequence Finished",
              UVM_LOW)

  endtask

endclass
class apb_addr_misaligned_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_addr_misaligned_sequence)

  function new(string name = "apb_addr_misaligned_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transection req;

    bit [31:0] misaligned_addr[7];

    `uvm_info(get_type_name(),
              "APB Misaligned Address Sequence Started",
              UVM_LOW)

    // All are inside valid 64KB range
    // but NOT 8-byte aligned
    misaligned_addr[0] = 32'h0000_0001;
    misaligned_addr[1] = 32'h0000_0002;
    misaligned_addr[2] = 32'h0000_0003;
    misaligned_addr[3] = 32'h0000_0004;
    misaligned_addr[4] = 32'h0000_0005;
    misaligned_addr[5] = 32'h0000_0006;
    misaligned_addr[6] = 32'h0000_0007;

    for (int i = 0; i < 7; i++) begin


      // =====================================================
      // MISALIGNED WRITE
      // Expected: PSLVERR = 1
      // =====================================================
      req = transection::type_id::create(
              $sformatf("misaligned_write_req_%0d", i));

      start_item(req);

      req.PWRITE = 1'b1;
      req.PADDR  = misaligned_addr[i];
      req.PWDATA = 64'hA100_0000_0000_0000 + i;
      req.PSTRB  = 8'hFF;

      finish_item(req);


      // =====================================================
      // MISALIGNED READ
      // Expected: PSLVERR = 1
      // =====================================================
      req = transection::type_id::create(
              $sformatf("misaligned_read_req_%0d", i));

      start_item(req);

      req.PWRITE = 1'b0;
      req.PADDR  = misaligned_addr[i];
      req.PWDATA = '0;
      req.PSTRB  = 8'h00;

      finish_item(req);

    end


    `uvm_info(get_type_name(),
              "APB Misaligned Address Sequence Finished",
              UVM_LOW)

  endtask

endclass
class apb_boundary_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_boundary_sequence)

  function new(string name = "apb_boundary_sequence");
    super.new(name);
  endfunction


  virtual task body();

    transection req;

    `uvm_info(get_type_name(),
              "APB Boundary Sequence Started",
              UVM_LOW)


    // =========================================================
    // WRITE TO LOWEST VALID ADDRESS : 0x0000_0000
    // =========================================================
    req = transection::type_id::create("low_boundary_write");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = 32'h0000_0000;
    req.PWDATA = 64'h1111_2222_3333_4444;
    req.PSTRB  = 8'hFF;

    finish_item(req);


    // =========================================================
    // WRITE TO HIGHEST VALID ALIGNED ADDRESS : 0x0000_FFF8
    // =========================================================
    req = transection::type_id::create("high_boundary_write");

    start_item(req);

    req.PWRITE = 1'b1;
    req.PADDR  = 32'h0000_FFF8;
    req.PWDATA = 64'hAAAA_BBBB_CCCC_DDDD;
    req.PSTRB  = 8'hFF;

    finish_item(req);


    // =========================================================
    // READ LOWEST VALID ADDRESS
    // Expected = 0x1111_2222_3333_4444
    // =========================================================
    req = transection::type_id::create("low_boundary_read");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = 32'h0000_0000;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    // =========================================================
    // READ HIGHEST VALID ALIGNED ADDRESS
    // Expected = 0xAAAA_BBBB_CCCC_DDDD
    // =========================================================
    req = transection::type_id::create("high_boundary_read");

    start_item(req);

    req.PWRITE = 1'b0;
    req.PADDR  = 32'h0000_FFF8;
    req.PWDATA = '0;
    req.PSTRB  = 8'h00;

    finish_item(req);


    `uvm_info(get_type_name(),
              "APB Boundary Sequence Finished",
              UVM_LOW)

  endtask

endclass
class apb_random_stress_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_random_stress_sequence)

  function new(string name = "apb_random_stress_sequence");
    super.new(name);
  endfunction


  virtual task body();

    int test_order[$];

    apb_successive_wr_sequence       successive_seq;
    apb_b2b_wr_sequence             b2b_seq;
    apb_slave_error_aor_sequence    slave_error_seq;
    apb_random_addr_wr_sequence     random_addr_seq;
    apb_strobe_sequence             strobe_seq;
    apb_addr_misaligned_sequence    misaligned_seq;
    apb_boundary_sequence           boundary_seq;


    `uvm_info(get_type_name(),
              "APB Random Stress Sequence Started",
              UVM_LOW)


    // Run all tests multiple times
    for (int round = 0; round < 2; round++) begin

      `uvm_info(get_type_name(),
                $sformatf("Stress Round %0d Started", round + 1),
                UVM_LOW)


      // -------------------------------------------------------
      // Test IDs
      // 0 = Successive Write/Read
      // 1 = Back-to-Back Write/Read
      // 2 = Slave Error
      // 3 = Random Address Write/Read
      // 4 = Strobe
      // 5 = Misaligned Address
      // 6 = Boundary
      // -------------------------------------------------------
      test_order.delete();

      test_order.push_back(0);
      test_order.push_back(1);
      test_order.push_back(2);
      test_order.push_back(3);
      test_order.push_back(4);
      test_order.push_back(5);
      test_order.push_back(6);

      // Randomize order
      test_order.shuffle();


      foreach (test_order[i]) begin

        case (test_order[i])

          // ===================================================
          // SUCCESSIVE WRITE/READ
          // ===================================================
          0: begin

            `uvm_info(get_type_name(),
                      "Running Successive Write/Read Sequence",
                      UVM_LOW)

            successive_seq =
              apb_successive_wr_sequence::type_id::create(
                $sformatf("successive_seq_round_%0d", round));

            successive_seq.start(m_sequencer);

          end


          // ===================================================
          // BACK-TO-BACK
          // ===================================================
          1: begin

            `uvm_info(get_type_name(),
                      "Running Back-to-Back Sequence",
                      UVM_LOW)

            b2b_seq =
              apb_b2b_wr_sequence::type_id::create(
                $sformatf("b2b_seq_round_%0d", round));

            b2b_seq.start(m_sequencer);

          end


          // ===================================================
          // SLAVE ERROR
          // ===================================================
          2: begin

            `uvm_info(get_type_name(),
                      "Running Slave Error Sequence",
                      UVM_LOW)

            slave_error_seq =
              apb_slave_error_aor_sequence::type_id::create(
                $sformatf("slave_error_seq_round_%0d", round));

            slave_error_seq.start(m_sequencer);

          end


          // ===================================================
          // RANDOM ADDRESS WRITE/READ
          // ===================================================
          3: begin

            `uvm_info(get_type_name(),
                      "Running Random Address Sequence",
                      UVM_LOW)

            random_addr_seq =
              apb_random_addr_wr_sequence::type_id::create(
                $sformatf("random_addr_seq_round_%0d", round));

            random_addr_seq.start(m_sequencer);

          end


          // ===================================================
          // STROBE
          // ===================================================
          4: begin

            `uvm_info(get_type_name(),
                      "Running Strobe Sequence",
                      UVM_LOW)

            strobe_seq =
              apb_strobe_sequence::type_id::create(
                $sformatf("strobe_seq_round_%0d", round));

            strobe_seq.start(m_sequencer);

          end


          // ===================================================
          // MISALIGNED ADDRESS
          // ===================================================
          5: begin

            `uvm_info(get_type_name(),
                      "Running Misaligned Address Sequence",
                      UVM_LOW)

            misaligned_seq =
              apb_addr_misaligned_sequence::type_id::create(
                $sformatf("misaligned_seq_round_%0d", round));

            misaligned_seq.start(m_sequencer);

          end


          // ===================================================
          // BOUNDARY
          // ===================================================
          6: begin

            `uvm_info(get_type_name(),
                      "Running Boundary Sequence",
                      UVM_LOW)

            boundary_seq =
              apb_boundary_sequence::type_id::create(
                $sformatf("boundary_seq_round_%0d", round));

            boundary_seq.start(m_sequencer);

          end

        endcase

      end


      `uvm_info(get_type_name(),
                $sformatf("Stress Round %0d Finished", round + 1),
                UVM_LOW)

    end


    `uvm_info(get_type_name(),
              "APB Random Stress Sequence Finished",
              UVM_LOW)

  endtask

endclass
class apb_violation_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_violation_sequence)

  function new(string name = "apb_violation_sequence");
    super.new(name);
  endfunction

  virtual task body();

    `uvm_info(get_type_name(),
              "APB Violation Sequence Started",
              UVM_LOW)

    // Actual protocol violation is driven directly
    // from apb_violation_test because driver is unchanged.

    `uvm_info(get_type_name(),
              "APB Violation Sequence Finished",
              UVM_LOW)

  endtask

endclass
class apb_reset_sequence extends uvm_sequence #(transection);

  `uvm_object_utils(apb_reset_sequence)

  function new(string name = "apb_reset_sequence");
    super.new(name);
  endfunction

  virtual task body();

    `uvm_info(get_type_name(),
              "APB Reset Sequence Started",
              UVM_LOW)

    // Reset stimulus is driven directly from apb_reset_test
    // because the normal APB driver does not control PRESETn.

    `uvm_info(get_type_name(),
              "APB Reset Sequence Finished",
              UVM_LOW)

  endtask

endclass
