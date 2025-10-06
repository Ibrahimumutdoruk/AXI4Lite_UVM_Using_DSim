`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
import uvm_axi4lite_pkg::*; // env/agent/seq tanımları burada

class axi_smoke_test extends uvm_test;
  `uvm_component_utils(axi_smoke_test)

  uvm_axi4lite_env env;

  function new(string name="axi_smoke_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = uvm_axi4lite_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    gpio_smoke_seq seq;
    phase.raise_objection(this);

    // Basit duman testi
    seq = gpio_smoke_seq::type_id::create("seq");
    seq.start(env.agt.sqr);

    #(2_000ns);
    phase.drop_objection(this);
  endtask
endclass