// =======================================================================================================================
// =======================================================================================================================

class data_packet;
	rand int id;
	rand int data[];

	constraint data_size {this.data.size() inside {[4:8]};}
	constraint data_sum {this.data.sum() inside {[20:40]};}
	constraint data_elem_1 {foreach (data[i])
		data[i] inside {[1:10]};
	}
	constraint data_elem_2 {foreach (this.data[i])
		this.data[i] > this.data[i - 1];
	}

	extern function void display();

endclass : data_packet

function void data_packet::display();
	$display("==================================");
	$display("packet id = %0d", this.id);
	$display("==================================");
	$display("data.sum() = %0d", this.data.sum());
	foreach (this.data[i]) begin
		$display("data[%0d] = %0d", i, this.data[i]);
	end
endfunction

class data_packet_queue;
	// local parameter int MAX_PACKETS = 6;

	rand data_packet data_packets[];

	constraint data_packets_size {this.data_packets.size() inside {[3:6]};}

	constraint data_packet_id_is_limited {foreach (data_packets[i])
		data_packets[i].id inside {[1:20]};
	}

	constraint data_packet_id_is_unique {
		foreach (data_packets[i])
			foreach (data_packets[j])
				if (i != j)
					data_packets[i].id != data_packets[j].id;
	}

	// random solver never constructs objects
	function new();
		// data_packets = new[MAX_PACKETS];
		data_packets = new[6];
		foreach (data_packets[i]) begin
			data_packets[i] = data_packet::new();
		end
	endfunction

endclass : data_packet_queue

// =======================================================================================================================
// =======================================================================================================================

typedef enum logic [2:0] {
	ADD = 0,
	SUB = 1,
	AND = 2,
	XOR = 3,
	MUL = 4,
	DIV = 5
} opcode_t;

class cmd;
	randc opcode_t opcode_e;
	rand logic [15:0] op_a;
	rand logic [15:0] op_b;
	rand int unsigned latency_in_ns;
	logic [15:0] result;

	constraint c_opcode_e {
		opcode_e inside {[0:5]};
	};

	constraint c_sub_args {
		(opcode_e == SUB) -> op_a >= op_b;
	}

	constraint c1_latency_in_ns {
		(opcode_e == ADD) -> latency_in_ns inside {[1:10]};
		(opcode_e == SUB) -> latency_in_ns inside {[1:10]};
		(opcode_e == AND) -> latency_in_ns inside {[1:10]};
		(opcode_e == XOR) -> latency_in_ns inside {[1:10]};
	};

	constraint c2_latency_in_ns {
		(opcode_e == MUL) -> latency_in_ns inside {[20:100]};
		(opcode_e == DIV) -> latency_in_ns inside {[20:100]};
	};

	constraint c_op_b {
		op_b == 0 -> op_a == 0;
	};

	constraint c_bit_width_add {
	    (opcode_e == ADD) -> op_a inside {[16'h0000 : 16'h7FFF]};
	    (opcode_e == ADD) -> op_b inside {[16'h0000 : 16'h7FFF]};
	}

	constraint c_bit_width_mul {
		(opcode_e == MUL) -> op_a inside {[0:255]};
		(opcode_e == MUL) -> op_b inside {[0:255]};
	}

endclass : cmd

task automatic execute_randomized_cmd(ref cmd ptr_cmd);
	begin
		realtime start_time, end_time;
		string op_code_like_str;
		if (!ptr_cmd.randomize()) begin
			$display("ERROR: FAIL of randomization is detected!");
			return;
		end
		start_time = $realtime;
		#(ptr_cmd.latency_in_ns);
		case (ptr_cmd.opcode_e)
			ADD: ptr_cmd.result = ptr_cmd.op_a + ptr_cmd.op_b;
			SUB: ptr_cmd.result = ptr_cmd.op_a - ptr_cmd.op_b;
			AND: ptr_cmd.result = ptr_cmd.op_a & ptr_cmd.op_b;
			XOR: ptr_cmd.result = ptr_cmd.op_a ^ ptr_cmd.op_b;
			MUL: ptr_cmd.result = ptr_cmd.op_a * ptr_cmd.op_b;
			DIV: ptr_cmd.result = ptr_cmd.op_a / ptr_cmd.op_b;
			default: ptr_cmd.result = 0;
		endcase
		end_time = $realtime;
		case (ptr_cmd.opcode_e)
			ADD: op_code_like_str = "ADD";
			SUB: op_code_like_str = "SUB";
			AND: op_code_like_str = "AND";
			XOR: op_code_like_str = "XOR";
			MUL: op_code_like_str = "MUL";
			DIV: op_code_like_str = "DIV";
			default: ptr_cmd.result = 0;
		endcase
		$display("%0d = %0d %s %0d, delta_time = %0t ns", ptr_cmd.result, ptr_cmd.op_a, op_code_like_str, ptr_cmd.op_b, end_time - start_time);
	end
endtask

// =======================================================================================================================
// =======================================================================================================================

interface histogram_if;
	logic clk;
	real generated_cnt;
	int generated_value;
endinterface

class distribution_model;
	rand int unsigned rand_value;
	randc int unsigned randc_value;
	rand int unsigned rand_value_with_distribution;
    int unsigned stats_rand[int unsigned];
	int unsigned stats_randc[int unsigned];
	int unsigned stats_dist[int unsigned];

	virtual histogram_if hist_if;

	function new (virtual histogram_if v_hist_if);
		if (v_hist_if) begin
			this.hist_if = v_hist_if;
		end
	endfunction

	constraint c_rand_value {
		rand_value >= 1;
		rand_value <= 100;
	};
	constraint c_randc_value {
		randc_value >= 1;
		randc_value <= 100;
	};
	constraint c_rand_value_with_distribution {
		// rand_value_with_distribution >= 1;
		// rand_value_with_distribution <= 100;
		rand_value_with_distribution dist { [45:54] := 10, [1:44] :/ 45, [55:100] :/ 45};
	};
endclass : distribution_model

// =======================================================================================================================
// =======================================================================================================================

task automatic collect_stats(ref distribution_model ptr_dm);
  begin
    // rand_value
    if (ptr_dm.stats_rand.exists(ptr_dm.rand_value)) begin
      ptr_dm.stats_rand[ptr_dm.rand_value] = ptr_dm.stats_rand[ptr_dm.rand_value] + 1; 
    end else begin
      ptr_dm.stats_rand[ptr_dm.rand_value] = 1;
    end
    // randc_value
    if (ptr_dm.stats_randc.exists(ptr_dm.randc_value)) begin
      ptr_dm.stats_randc[ptr_dm.randc_value] = ptr_dm.stats_randc[ptr_dm.randc_value] + 1; 
    end else begin
      ptr_dm.stats_randc[ptr_dm.randc_value] = 1;
    end
     // randc_value
    if (ptr_dm.stats_dist.exists(ptr_dm.rand_value_with_distribution)) begin
      ptr_dm.stats_dist[ptr_dm.rand_value_with_distribution] = ptr_dm.stats_dist[ptr_dm.rand_value_with_distribution] + 1; 
    end else begin
      ptr_dm.stats_dist[ptr_dm.rand_value_with_distribution] = 1;
    end
  end
endtask

task automatic randomize_rand_values(ref distribution_model ptr_dm);
	begin
		if (ptr_dm.randomize()) begin
			collect_stats(ptr_dm);
		end else begin
			$display("ERROR: FAIL of randomization is detected!");
		end
	end
endtask

task automatic visualize_hist(ref distribution_model ptr_dm, int unsigned stats_rand[int unsigned]);
	int unsigned key_idx = 1;
    repeat(100) begin
	    @(posedge ptr_dm.hist_if.clk);
    end
	repeat (100) begin
		@(posedge ptr_dm.hist_if.clk);
		ptr_dm.hist_if.generated_value = key_idx;
		ptr_dm.hist_if.generated_cnt = stats_rand[key_idx];
		key_idx = key_idx + 1;
	end
endtask

// =======================================================================================================================
// =======================================================================================================================

task automatic print_rand_values (ref distribution_model ptr_dm);
  $display("dm.rand_value = %0d", ptr_dm.rand_value);
  $display("dm.randc_value = %0d", ptr_dm.randc_value);
  $display("dm.rand_value_with_distribution = %0d", ptr_dm.rand_value_with_distribution);
endtask

task automatic print_stats (ref distribution_model ptr_dm);
  $display("dm.stats_rand[%0d] = %0d", ptr_dm.rand_value, ptr_dm.stats_rand[ptr_dm.rand_value]);
  $display("dm.stats_randc[%0d] = %0d", ptr_dm.randc_value, ptr_dm.stats_randc[ptr_dm.randc_value]);
  $display("dm.stats_dist[%0d] = %0d", ptr_dm.rand_value_with_distribution, ptr_dm.stats_dist[ptr_dm.rand_value_with_distribution]);
endtask

task automatic print_report(ref distribution_model ptr_dm);
	print_rand_values(ptr_dm);
	print_stats(ptr_dm);
endtask
