module home_work_1;
	initial begin
		// 1
		bit [3:0] just_bit_var = 4'b1111;
		int just_int_var = just_bit_var;
		// just_bit_var = 4'b1111;
		// just_int_var = just_bit_var;
        $display("just_bit_var (decimal) = %0d", just_bit_var);
        $display("just_int_var (decimal) = %0d", just_int_var);
        // Поясніть, чому результат завжди інтерпретується як unsigned.
	end
	initial begin
		// 2
		logic [3:0] just_logic_value = 4'b1111;
		logic signed [3:0] just_signed_logic_value = just_logic_value;
        // 2
        // logic [3:0] just_logic_value;
        // logic signed just_signed_logic_value;
        // just_logic_value = 4'b1111;
        // just_signed_logic_value = just_logic_value;
        $display("just_logic_value (decimal) = %0d", just_logic_value);
        $display("just_signed_logic_value (decimal) = %0d", just_signed_logic_value);
	end
	initial begin
		// 3
		logic [3:0] logic_with_x_bit = 4'b10x1;
		logic [3:0] logic_with_z_bit = 4'b01z0;
		// logic_with_x_bit = 4'b10x1;
		// logic_with_z_bit = 4'b01z0;
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
endmodule
