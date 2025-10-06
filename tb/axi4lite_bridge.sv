
`timescale 1ns/1ps



module axi4lite_bridge (
  input  logic clk,
  input  logic rst,                     // aktif-yüksek, şimdilik kullanmıyoruz
  uvm_axi4lite_if            vif,
  AXI_LITE.Master            axi        // DUT’a giden master modport
);

  // Write address
  assign axi.aw_addr  = vif.AWADDR;
  assign axi.aw_prot  = vif.AWPROT;
  assign axi.aw_valid = vif.AWVALID;
  assign vif.AWREADY  = axi.aw_ready;

  // Write data
  assign axi.w_data   = vif.WDATA;
  assign axi.w_strb   = vif.WSTRB;
  assign axi.w_valid  = vif.WVALID;
  assign vif.WREADY   = axi.w_ready;

  // Write response
  assign vif.BRESP    = axi.b_resp;
  assign vif.BVALID   = axi.b_valid;
  assign axi.b_ready  = vif.BREADY;

  // Read address
  assign axi.ar_addr  = vif.ARADDR;
  assign axi.ar_prot  = vif.ARPROT;
  assign axi.ar_valid = vif.ARVALID;
  assign vif.ARREADY  = axi.ar_ready;

  // Read data
  assign vif.RDATA    = axi.r_data;
  assign vif.RRESP    = axi.r_resp;
  assign vif.RVALID   = axi.r_valid;
  assign axi.r_ready  = vif.RREADY;

endmodule
