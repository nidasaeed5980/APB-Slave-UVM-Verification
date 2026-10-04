// `include "uvm_macros.svh"
// import uvm_pkg::*;
class apb_sequencer extends uvm_sequencer#(transection);
 `uvm_component_utils(apb_sequencer)

 function new(string path = "apb_sequencer", uvm_component parent = null);
   super.new(path, parent);
 endfunction

 virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   `uvm_info("apb_sequencer"," Build Phase Executed", UVM_NONE);
 endfunction
 
endclass