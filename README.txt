############################################################

DSIM UVM Simulation Setup (Non-Commercial)
Project: SUMERMCU GPIO + AXI4-Lite UVM Testbench

############################################################

#############################

1. Libraries and Packages

#############################

Using UVM 1.2

+define+UVM
+UVM_NO_DEPRECATED
+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
-uvm 1.2

#############################

2. Compilation Order

#############################
#tb/axi_pkg.sv

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

#############################

3. Simulation Script

#############################

Elaboration test

dsim -elab tb_top -L work -uvm 1.2 -genimage simv.elab

For Sim_smoke

dsim -elab tb_top -L work -uvm 1.2 -timescale=1ns/1ps \
-genimage simv.smoke \
-debug

dsim -run simv.smoke +UVM_TESTNAME=smoke_test +UVM_VERBOSITY=UVM_MEDIUM

Elaboration test

dsim -elab tb_top -L work -uvm 1.2 -genimage simv.elab

#############################

4. Test Files

#############################

smoke_test.sv -> The simplest GPIO register read/write test, UVM Handshake test.
elab_test.sv -> Design elaboration check (are the connections correct?).

#############################

5. Waveform

#############################

In waves.mxd you can add the following to access waveforms:
- tb_top.u_gpio_dut.irq
- tb_top.axi_if
- tb_top.vip_if

dsim -run simv.smoke -waves waves.mxd
#############################
#############################