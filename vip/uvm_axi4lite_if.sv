////////////////////////////////////////////////////////////////////////////////
//
// MIT License
//
// Copyright (c) 2025 Smartfox Data Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

interface uvm_axi4lite_if;
   logic            clk;
   logic            rst;

   logic [31:0]     AWADDR;
   logic [ 2:0]     AWPROT;
   logic 	    AWVALID;
   logic 	    AWREADY;
   logic [31:0]     WDATA;
   logic [ 3:0]     WSTRB;
   logic 	    WVALID;
   logic 	    WREADY;
   logic [1:0] 	    BRESP;
   logic 	    BVALID;
   logic 	    BREADY;
   logic [31:0]     ARADDR;
   logic [ 2:0]     ARPROT;
   logic 	    ARVALID;
   logic 	    ARREADY;
   logic [31:0]     RDATA;
   logic [ 1:0]     RRESP;
   logic 	    RVALID;
   logic 	    RREADY;

   // Signal initialization
   initial begin
      // AXI Master sinyalleri (UVM VIP tarafından kontrol edilir)
      AWADDR  = 32'h0;
      AWPROT  = 3'b0;
      AWVALID = 1'b0;
      WDATA   = 32'h0;
      WSTRB   = 4'b0;
      WVALID  = 1'b0;
      BREADY  = 1'b0;
      ARADDR  = 32'h0;
      ARPROT  = 3'b0;
      ARVALID = 1'b0;
      RREADY  = 1'b0;

      // AXI Slave sinyalleri (DUT tarafından kontrol edilir, başlangıç değeri)
      AWREADY = 1'b0;
      WREADY  = 1'b0;
      BRESP   = 2'b0;
      BVALID  = 1'b0;
      ARREADY = 1'b0;
      RDATA   = 32'h0;
      RRESP   = 2'b0;
      RVALID  = 1'b0;
   end

endinterface // uvm_axi4lite_if
