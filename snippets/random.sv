module tb;
  reg [3:0] val;

  initial begin
    for (integer i = 0; i < 10; i += 1) begin
      // For the expression ($random % N) where N is greater than 0,
      // it returns a number in the following range [(-b + 1) : (b - 1)]
      // The randomization example shown above gave values between -1:1 because N=2 in the example above.
      // Note that val being 15 in signed format means that its value is -1.
      val = $random % 2;
      $display ("val=0x%0h val=%0d", val, val);

      // To remove the negative values and to get a range from 0:N, a concatenation operator should be added.
      val = {$random} % 10;
      $display ("val=0x%0h val=%0d", val, val);
    end
  end

endmodule
