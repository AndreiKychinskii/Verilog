module home_work_4;
  histogram_if histogram_if_tb();
  distribution_model dm;

  // Clocking
  logic [7:0] clk_period = 20;
  always
      begin
        histogram_if_tb.clk = 1; #(clk_period / 2); histogram_if_tb.clk = 0; #(clk_period / 2);
      end

  initial begin
	dm = new(histogram_if_tb);
	repeat(10_000) begin
		randomize_rand_values(dm);
	end
	visualize_hist(dm, dm.stats_rand);
	visualize_hist(dm, dm.stats_randc);
	visualize_hist(dm, dm.stats_dist);

	repeat(100_000) begin
		randomize_rand_values(dm);
	end
	visualize_hist(dm, dm.stats_rand);
	visualize_hist(dm, dm.stats_randc);
	visualize_hist(dm, dm.stats_dist);
  end

  // // Waveform dump and finish
  // initial begin
  //   $dumpfile("wave1.vcd");
  //   $dumpvars(0);  // Dump everything in this module
  //   #1000;  // adjust as needed
  //   $finish();
  // end

endmodule
