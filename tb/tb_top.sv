`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;
import axi_pkg::*;
import uvm_axi4lite_pkg::*;

// Test Package
package test_pkg;
  import uvm_pkg::*;
  import uvm_axi4lite_pkg::*;
  `include "uvm_macros.svh"
  
  class gpio_smoke_seq extends uvm_axi4lite_base_seq;
    `uvm_object_utils(gpio_smoke_seq)
    
    function new(string name="gpio_smoke_seq");
      super.new(name);
    endfunction
    
    virtual task body();
      uvm_axi4lite_txn item;

      `uvm_info("SEQ", "Starting sequence", UVM_LOW)

      // Write ODR
      `uvm_create(item)
      item.trans  = WRITE;
      item.addr   = 16'h0004;
      item.data   = 32'h0000_00A5;
      item.cycles = 2;
      `uvm_send(item)

      // Read ODR
      `uvm_create(item)
      item.trans  = READ;
      item.addr   = 16'h0004;
      item.cycles = 2;
      `uvm_send(item)

      // Read IDR
      `uvm_create(item)
      item.trans  = READ;
      item.addr   = 16'h0000;
      item.cycles = 2;
      `uvm_send(item)
    endtask
  endclass
  
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
      
      // Reset'in bitmesini bekle
      wait(tb_top.rst == 1'b0);
      repeat(10) @(posedge tb_top.clk);
      
      seq = gpio_smoke_seq::type_id::create("seq");
      seq.start(env.agt.sqr);
      
      repeat(100) @(posedge tb_top.clk);
      
      phase.drop_objection(this);
    endtask
  endclass
endpackage

import test_pkg::*;

// Bridge
module axi4lite_bridge (
  input  logic clk,
  input  logic rst,
  uvm_axi4lite_if vif,
  AXI_LITE.Master axi
);

  // AXI Master sinyalleri - VIP'ten AXI interface'e
  assign axi.aw_addr  = rst ? 32'h0 : vif.AWADDR;
  assign axi.aw_prot  = rst ? 3'b0  : vif.AWPROT;
  assign axi.aw_valid = rst ? 1'b0  : vif.AWVALID;
  assign vif.AWREADY  = axi.aw_ready;

  assign axi.w_data   = rst ? 32'h0 : vif.WDATA;
  assign axi.w_strb   = rst ? 4'b0  : vif.WSTRB;
  assign axi.w_valid  = rst ? 1'b0  : vif.WVALID;
  assign vif.WREADY   = axi.w_ready;

  assign vif.BRESP    = axi.b_resp;
  assign vif.BVALID   = axi.b_valid;
  assign axi.b_ready  = rst ? 1'b0  : vif.BREADY;

  assign axi.ar_addr  = rst ? 32'h0 : vif.ARADDR;
  assign axi.ar_prot  = rst ? 3'b0  : vif.ARPROT;
  assign axi.ar_valid = rst ? 1'b0  : vif.ARVALID;
  assign vif.ARREADY  = axi.ar_ready;

  assign vif.RDATA    = axi.r_data;
  assign vif.RRESP    = axi.r_resp;
  assign vif.RVALID   = axi.r_valid;
  assign axi.r_ready  = rst ? 1'b0  : vif.RREADY;

endmodule

// Main Testbench
module tb_top;
  
  // Clock ve Reset sinyalleri
  reg clk;
  reg rst;
  
  // Clock generator - ALWAYS bloğu kullan
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end
  
  // Reset generator
  initial begin
    $display("Time=%0t: Starting reset sequence", $time);
    rst = 1'b1;
    repeat(20) @(posedge clk);  // 20 clock bekle
    rst = 1'b0;
    $display("Time=%0t: Reset released", $time);
  end
  
  // UVM VIP Interface
  uvm_axi4lite_if vip_if();
  
  // Clock ve reset bağlantıları
  always @(clk) vip_if.clk = clk;
  always @(rst) vip_if.rst = rst;
  
  // AXI-Lite Interface
  AXI_LITE #(
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32)
  ) axi_if();
  
  // Bridge
  axi4lite_bridge u_bridge (
    .clk(clk),
    .rst(rst),
    .vif(vip_if),
    .axi(axi_if)
  );
  
  // GPIO DUT
  logic irq, irq_ack;
  logic [15:0] pin_i, pin_o;

  sumermcu_gpio u_gpio_dut (
    .clk(clk),
    .rst(rst),
    .s_axil(axi_if.Slave),
    .irq(irq),
    .irq_ack(irq_ack),
    .pin_i(pin_i),
    .pin_o(pin_o)
  );

  // GPIO signals are now separate from AXI VIP interface
  // They are handled directly by the DUT and testbench stimulus
  
  // Pin stimulus
  initial begin
    pin_i = 16'h0000;
    irq_ack = 1'b0;

    // İlk değerler clock edge'de verilsin
    @(posedge clk);
    pin_i = 16'h0000;
    irq_ack = 1'b0;

    wait(rst == 1'b0);  // Reset bitmesini bekle
    repeat(50) @(posedge clk);

    pin_i = 16'hABCD;
    repeat(10) @(posedge clk);

    if(irq) begin
      irq_ack = 1'b1;
      @(posedge clk);
      irq_ack = 1'b0;
    end
  end
  
  // Waveform dump
  initial begin
    $dumpfile("waves.mxd");
    $dumpvars(0, tb_top);
    $dumpon;
    $display("Waveform dump started");
  end
  
  // Debug prints
  initial begin
    $monitor("Time=%0t clk=%b rst=%b", $time, clk, rst);
  end
  
 // UVM Configuration
  initial begin
    // VIP interface config
    uvm_config_db#(virtual uvm_axi4lite_if)::set(null, "*", "vif", vip_if);
    
    // Timeout ayarı
    uvm_top.set_timeout(50us, 0);
    
    // Debug
    $display("Starting UVM test");
    
    // Test başlat
    run_test("axi_smoke_test");
  end
  
  // Simülasyon süresi kontrolü
  initial begin
    #100us;
    $display("Simulation timeout at %0t", $time);
    $finish;
  end
  
endmodule