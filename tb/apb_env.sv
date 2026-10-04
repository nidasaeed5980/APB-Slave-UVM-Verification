class apb_environment extends uvm_env;
 `uvm_component_utils(apb_environment)

 function new(string path = "apb_environment", uvm_component parent = null);
   super.new(path,parent);
 endfunction

apb_agent agent;
apb_scoreboard scoreboard;
apb_coverage coverage;
 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent=apb_agent::type_id::create("agent",this);
    scoreboard=apb_scoreboard::type_id::create("scoreboard",this);
    coverage = apb_coverage::type_id::create("coverage", this);
    `uvm_info("apb_environment","build phase", UVM_NONE);
 endfunction
 function void connect_phase(uvm_phase phase);
    agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
   agent.monitor.item_collected_port.connect(coverage.analysis_export);
    `uvm_info("apb_environment","connect Phase Executed In apb_agent", UVM_NONE);

  endfunction : connect_phase
endclass
