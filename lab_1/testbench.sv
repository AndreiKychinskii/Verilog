module home_work_1;
  logic clk = 1'b0;
  always
      begin
          clk = 1; #5; clk = 0; #5;
      end

	// Work with variables
	initial begin
		// 1
		bit [3:0] just_bit_var = 4'b1111;
		int just_int_var = just_bit_var;
        $display("just_bit_var (decimal) = %0d", just_bit_var);
        $display("just_int_var (decimal) = %0d", just_int_var);
        // Поясніть, чому результат завжди інтерпретується як unsigned.
	end
	initial begin
		// 2
		logic [3:0] just_logic_value = 4'b1111;
		logic signed [3:0] just_signed_logic_value = just_logic_value;
        $display("just_logic_value (decimal) = %0d", just_logic_value);
        $display("just_signed_logic_value (decimal) = %0d", just_signed_logic_value);
	end
	initial begin
		// 3
		logic [3:0] logic_with_x_bit = 4'b10x1;
		logic [3:0] logic_with_z_bit = 4'b01z0;
        $display("logic_with_x_bit (decimal) = %0d", logic_with_x_bit);
        $display("logic_with_z_bit (decimal) = %0d", logic_with_z_bit);
	end
	initial begin
		// 4
		bit just_bit_var_1 = 1'b1;
		bit just_bit_var_2 = 1'b1;
		bit one_bit_width_sum = just_bit_var_1 + just_bit_var_2;
		bit [1:0] two_bit_width_sum = just_bit_var_1 + just_bit_var_2;
        $display("one_bit_width_sum (decimal) = %0d", one_bit_width_sum);
        $display("two_bit_width_sum (decimal) = %0d", two_bit_width_sum);
    end

    // Packed array
    // A multidimensional packed array is still a set of contiguous bits but are also segmented into smaller groups.
    initial begin
	    logic [3:0][7:0] registers;
	    logic [1:0][7:0] msb_slice;
	    logic [1:0][7:0] lsb_slice;
	    registers = 32'hFACE_CAFE;
	    for (int i = 0; i < $size(registers); i++) begin
		    $display ("registers[%0d] = %b (0x%0h)", i, registers[i], registers[i]);
	    end
        msb_slice = registers[3:2];
	    lsb_slice = registers[1:0];
	    // Print msb_slice and lsb_slice
        $display("msb_slice = 0x%0h", msb_slice);
        $display("lsb_slice = 0x%0h", lsb_slice);
        // Print MSB & LSB of msb_slice
        $display("MSB of msb_slice = 0x%0h", msb_slice[1]);
        $display("LSB of msb_slice = 0x%0h", msb_slice[0]);
    end

    // Unpacked array
    initial begin
	    byte image[4][4];
	    // Create matrix
	    foreach (image[row_idx]) begin
		    foreach (image[row_idx][col_idx]) begin
		    	image[row_idx][col_idx] = row_idx * col_idx;
		    end
	    end
	    // Print matrix
	    foreach (image[row_idx]) begin
		    foreach (image[row_idx][col_idx]) begin
			    $display ("image[%0d][%0d] = 0x%0h", row_idx, col_idx, image[row_idx][col_idx]);
		    end
	    end 
    end

    // Associative array
    initial begin
      string key;
	    byte mac_addresses[string];
	    mac_addresses["AA:BB:CC:DD:EE:01"] = 1;
	    mac_addresses["AA:BB:CC:DD:EE:02"] = 2;
	    mac_addresses["AA:BB:CC:DD:EE:03"] = 3;
	    mac_addresses["AA:BB:CC:DD:EE:04"] = 9;
	    mac_addresses["AA:BB:CC:DD:EE:05"] = 7;
	    mac_addresses["AA:BB:CC:DD:EE:06"] = 8;
	    key = "AA:BB:CC:DD:EE:02";
	    if (mac_addresses.exists(key)) begin
	    	$display ("mac_addresses[%s] = 0x%0h", key, mac_addresses[key]);
	    end
	    else begin
		    $display ("mac_addresses[%s] doesn't exist!", key);
	    end
			key = "AA:BB:CC:DD:EE:11";
	    if (mac_addresses.exists(key)) begin
	    	$display ("mac_addresses[%s] = 0x%0h", key, mac_addresses[key]);
	    end
	    else begin
		    $display ("mac_addresses[%s] doesn't exist!", key);
	    end
	    mac_addresses["AA:BB:CC:DD:EE:10"] = 5;
	    mac_addresses.delete("AA:BB:CC:DD:EE:01");
	    mac_addresses["AA:BB:CC:DD:EE:05"] = 10;
      $display ("Iterate over all members of associative array");
	    if (mac_addresses.first(key)) begin
		    $display ("mac_addresses[%s] = 0x%0h", key, mac_addresses[key]);
          for (byte address = 0; address < mac_addresses.size() - 1; address++) begin
            mac_addresses.next(key);
						$display ("mac_addresses[%s] = 0x%0h", key, mac_addresses[key]);
					end
	    end
    end

    // Queue
    initial begin
	    int unbounded_queue[$] = {101, 102, 103, 104};
	    unbounded_queue.push_back(105);
	    unbounded_queue.push_back(106);
	    unbounded_queue.push_front(200);
	    $display("1st element from front of queue is %0d", unbounded_queue.pop_front());
	    $display("2nd element from front of queue is %0d", unbounded_queue.pop_front());
	    $display("last element from end of queue is %0d", unbounded_queue.pop_back());
	    for (int idx = 0, limit = unbounded_queue.size(); idx < limit; idx++ ) begin
		    $display("unbounded_queue[%0d] is %0d", idx, unbounded_queue[idx]);
	    end
	    $display("unbounded_queue.size() before unbounded_queue.delete() is %0d", unbounded_queue.size());
	    unbounded_queue.delete();
	    $display("unbounded_queue.size() after unbounded_queue.delete() is %0d", unbounded_queue.size());
    end

    // Function
    initial begin
	    logic [7:0] result;
	    real voltages[7] = {-0.1, 0.0, 0.25, 0.5, 0.75, 1.0, 1.1};
	    for (int idx = 0; idx < 7; idx++) begin
		    $display("adc_convert(%.2f) returns %0d", voltages[idx], adc_convert(voltages[idx], result));
	    end
    end

    // Generate Pulse Task
    initial begin
	        logic signal = 1'b0;
          typedef struct {
              int delay_before_rising_edge;
              int pulse_duration;
              int repeat_cnt;
          } generate_pulse_args_t;

      generate_pulse_args_t generate_pulse_args[3] = '{
		        '{delay_before_rising_edge: 2, pulse_duration: 5, repeat_cnt: 1},
		        '{delay_before_rising_edge: 2, pulse_duration: 2, repeat_cnt: 3},
		        '{delay_before_rising_edge: 6, pulse_duration: 6, repeat_cnt: 2}
          };

          foreach(generate_pulse_args[i])
              begin
                generate_pulse(generate_pulse_args[i].delay_before_rising_edge,
                               generate_pulse_args[i].pulse_duration,
                               generate_pulse_args[i].repeat_cnt,
                               signal);
              end
    end

    initial begin
        $dumpfile("wave1.vcd");
        $dumpvars(0);
        #550;
        $finish();
    end

  	// Execute Task
    initial begin
	    logic [6:0] result;
	    cmd cmd_queue[$] = '{
	    	'{ADD, 10, 3},
	    	'{SUBTRACT, 20, 5},
	    	'{XOR, 7, 3},
	    	'{AND, 15, 7}
	    };
	    while (cmd_queue.size()) begin
        execute_cmd(cmd_queue.pop_front(), 10, result);
			  $display("cmd_queue: time of execution is [%0d], result is %0d", 10, result);
	    end
    end
endmodule
