# UVM AXI4-Lite GPIO Testbench with DSIM

UVM 1.2-based verification environment for SUMERMCU GPIO module with AXI4-Lite interface. Includes comprehensive testbench infrastructure and DSIM simulator support.

## Overview

 This project provides a complete UVM 1.2-based verification environment for the SUMERMCU GPIO peripheral module featuring an AXI4-Lite slave interface. The testbench implements industry-standard verification methodologies and leverages the Smartfox AXI4-Lite Verification IP (VIP) to thoroughly validate register access, data integrity, and protocol compliance.

AXI4-Lite Protocol Compliance** - Full handshake verification (AWVALID, AWREADY, WVALID, WREADY, BVALID, BREADY, ARVALID, ARREADY, RVALID, RREADY)
-  **Register Read/Write Operations** - Validates all GPIO registers including DATA, DIR, IRQ_EN, and IRQ_STS
-  **Interrupt Generation** - Tests GPIO interrupt functionality and status reporting
-  **Address Decoding** - Verifies correct register selection and address mapping
-  **Data Integrity** - Ensures written data matches read data with various patterns
-  **Error Responses** - Validates SLVERR for invalid addresses and transactions

**Key Features:**
-  UVM 1.2 compliant testbench
-  AXI4-Lite VIP integration
-  DSIM simulator support
-  Register read/write tests
-  Waveform analysis support
-  Smoke and elaboration tests

## Directory Structure
```
AXI4Lite_UVM_Test_DSim/
├── rtl/                          # RTL source files
│   ├── sumermcu_gpio.sv         # GPIO top module
│   ├── sumermcu_gpio_reg.sv     # Register block
│   └── sumermcu_gpio_reg_pkg.sv # Register package
├── tb/                          # Testbench files
│   ├── tb_top.sv               # Testbench top
│   ├── axi_intf.sv             # AXI interface
│   ├── axi4lite_bridge.sv      # AXI bridge
│   ├── gpio_smoke_seq.sv       # GPIO sequences
│   └── axi_smoke_test.sv       # Smoke test
├── vip/                        # Verification IP
│   ├── uvm_axi4lite_if.sv     # AXI4-Lite interface
│   └── axi4lite_pkg.sv        # AXI4-Lite package
└── README.md
```


##  Getting Started

### Prerequisites
- **DSIM Simulator** (Metrics Design Automation) - Non-Commercial Version
- **UVM 1.2** library
- **SystemVerilog** compiler

###  DSIM UVM Simulation Setup (Non-Commercial)

### 1. Libraries and Packages
Using UVM 1.2
+define+UVM
+UVM_NO_DEPRECATED
+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
-uvm 1.2

## Compilation Order
```
tb/axi_pkg.sv
tb/axi_intf.sv
vip/uvm_axi4lite_if.sv
vip/axi4lite_pkg.sv
tb/axi4lite_bridge.sv
tb/gpio_smoke_seq.sv
tb/axi_smoke_test.sv
tb/tb_top.sv
rtl/sumermcu_gpio_reg_pkg.sv
rtl/sumermcu_gpio.sv
rtl/sumermcu_gpio_reg.sv
```


### Simulation Script
Elobration
- dsim -elab tb_top -L work -uvm 1.2 -genimage simv.elab

-dsim -elab tb_top -L work -uvm 1.2 -timescale=1ns/1ps \
     -genimage simv.smoke \
     -debug
Run    
     dsim -run simv.smoke +UVM_TESTNAME=smoke_test +UVM_VERBOSITY=UVM_MEDIUM
UVM Define 
## References
- **Smartfox Data** for the [AXI4-Lite VIP](https://github.com/smartfoxdata/uvm_axi4lite)
- **Metrics Design Automation** for DSIM simulator
- **UVM Community** for verification methodology
