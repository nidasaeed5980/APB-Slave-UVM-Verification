
class apb_agent extends uvm_agent;
`uvm_component_utils(apb_agent)
 
 function new(input string inst = "apb_agent", uvm_component c);
super.new(inst,c);
endfunction

apb_driver driver;
apb_sequencer#(transection) sequncer;
apb_monitor monitor;
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor= apb_monitor::type_id::create("monitor",this);
    if(get_is_active() == UVM_ACTIVE) begin
        driver = apb_driver::type_id::create("driver",this);
   
        sequncer = apb_sequencer::type_id::create("sequncer", this);

    `uvm_info("apb_agent","Test build Phase Executed In apb_agent", UVM_NONE);
    end
    

    `uvm_info("apb_agent","build phase", UVM_NONE);
endfunction
function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequncer.seq_item_export);
    end
    `uvm_info("apb_agent","connect Phase Executed In apb_agent", UVM_NONE);
  endfunction 
endclass
///////////////////////////////////////////////////
