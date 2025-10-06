/*
 * GPIO module with AXI4-Lite interface and 16 inputs + 16 outputs.
 */
`timescale 1ns/1ps

import sumermcu_gpio_reg_pkg::*;

module sumermcu_gpio (
	input clk,
	input rst,

	AXI_LITE.Slave s_axil,

	output logic irq,
	input logic irq_ack,

	input[15:0] pin_i,
	output[15:0] pin_o
);
	sumermcu_gpio_reg_pkg::sumermcu_gpio_reg__in_t hwif_in;
	sumermcu_gpio_reg_pkg::sumermcu_gpio_reg__out_t hwif_out;

	sumermcu_gpio_reg regblock (
		.clk		(clk),
		.rst		(rst),

		.s_axil		(s_axil),

		.hwif_in	(hwif_in),
		.hwif_out	(hwif_out)
	);

	assign pin_o = hwif_out.ODR.STATE.value;

	always_comb begin
		hwif_in.IDR.STATE.next <= pin_i;
	end

	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			irq <= 0;
		end else begin
			if (irq && irq_ack)
				irq <= 0;

			if (!irq && pin_i != hwif_out.IDR.STATE.value)
				irq <= 1;
		end
	end
endmodule
