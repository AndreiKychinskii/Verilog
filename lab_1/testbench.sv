// Code your testbench here
// or browse Examples
`define HIGH_LEVEL 1
`define LOW_LEVEL 0
`define NUMBER_OF_STATES_TO_TEST 8

module enable_module;
	logic enable_i;
	logic clk_i;
	logic d_ff_1_out;
	logic d_ff_2_out;
	logic ov_fault_i;
	logic uv_fault_i;
	logic oc_fault_i;
	logic or_1_out;
	logic or_2_out;
	logic not_out;
	logic enable_o;

	element_d_flip_flop d_ff_1(.data(enable_i), .clock(clk_i), .out(d_ff_1_out));
	element_d_flip_flop d_ff_2(.data(d_ff_1_out), .clock(clk_i), .out(d_ff_2_out));
    element_or el_or_1(.a(ov_fault_i), .b(uv_fault_i), .out(or_1_out));
	element_or el_or_2(.a(or_1_out), .b(oc_fault_i), .out(or_2_out));
	element_not el_not(.a(or_2_out), .out(not_out));
	element_and el_and(.a(d_ff_2_out), .b(not_out), .out(enable_o));

	initial begin
	    enable_i = `HIGH_LEVEL;
        #80;
        enable_i = `LOW_LEVEL;
	end

	initial begin
		for (logic [3:0] fault_states = 0; fault_states < `NUMBER_OF_STATES_TO_TEST; fault_states++) begin
			ov_fault_i <= fault_states[0];
			uv_fault_i <= fault_states[1];
			oc_fault_i <= fault_states[2];
			#20;
		end
	end

	initial begin
		clk_i = 0;
		forever begin
		  #5 clk_i = !clk_i;
		end
	end

	initial begin
		$dumpfile("wave1.vcd");
		$dumpvars(0);
		#150;
		$finish();
	end

endmodule
