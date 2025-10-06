`include "uvm_macros.svh"
import uvm_pkg::*;
import uvm_axi4lite_pkg::*;

// Basit yönlendirilmiş sekans: ODR'ye yaz, ODR'yi oku, IDR'yi oku.
class gpio_smoke_seq extends uvm_axi4lite_base_seq;
  `uvm_object_utils(gpio_smoke_seq)

  function new(string name="gpio_smoke_seq");
    super.new(name);
  endfunction

  virtual task body();
    uvm_axi4lite_txn t;

    `uvm_info("SEQ", "Starting GPIO smoke sequence", UVM_LOW)

    // ODR (0x04) <- 0xA5
    `uvm_info("SEQ", "Creating WRITE transaction to ODR", UVM_LOW)
    `uvm_create(t)
    t.trans  = WRITE;
    t.addr   = 16'h0004;     // regblock decode: {addr[2],2'b0} -> 0x00 & 0x04
    t.data   = 32'h0000_00A5;
    t.cycles = 1;
    `uvm_send(t)

    // ODR (0x04) oku
    `uvm_info("SEQ", "Creating READ transaction to ODR", UVM_LOW)
    `uvm_create(t)
    t.trans  = READ;
    t.addr   = 16'h0004;
    t.cycles = 1;
    `uvm_send(t)

    // IDR (0x00) oku
    `uvm_info("SEQ", "Creating READ transaction to IDR", UVM_LOW)
    `uvm_create(t)
    t.trans  = READ;
    t.addr   = 16'h0000;
    t.cycles = 1;
    `uvm_send(t)

    `uvm_info("SEQ", "GPIO smoke sequence completed", UVM_LOW)
  endtask
endclass
