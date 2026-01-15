// Randomization

module home_work_4;
  histogram_if histogram_if_tb();
  distribution_model tst_dist_model;
  cmd tst_cmd;
  data_packet tst_data_packet;
  data_packet_queue tst_data_packet_queue;

  // Clocking
  logic [7:0] clk_period = 20;
  always
      begin
        histogram_if_tb.clk = 1; #(clk_period / 2); histogram_if_tb.clk = 0; #(clk_period / 2);
      end

  initial begin
	tst_dist_model = new(histogram_if_tb);
	repeat (10_000) begin
		randomize_rand_values(tst_dist_model);
	end
	visualize_hist(tst_dist_model, tst_dist_model.stats_rand);
	visualize_hist(tst_dist_model, tst_dist_model.stats_randc);
	visualize_hist(tst_dist_model, tst_dist_model.stats_dist);

	repeat (100_000) begin
		randomize_rand_values(tst_dist_model);
	end
	visualize_hist(tst_dist_model, tst_dist_model.stats_rand);
	visualize_hist(tst_dist_model, tst_dist_model.stats_randc);
	visualize_hist(tst_dist_model, tst_dist_model.stats_dist);
  end

  initial begin
    tst_cmd = new();
    repeat (20) begin
      execute_randomized_cmd(tst_cmd);
    end
  end

  initial begin
    // no id constraints in data_packet
    tst_data_packet = new();
    repeat (3) begin
      if (tst_data_packet.randomize()) begin
        tst_data_packet.display();
      end else begin
        $display("ERROR: FAIL of randomization of tst_data_packet is detected!");
      end
    end
    $display("\n=== tst_data_packet_queue example ===");
    repeat (3) begin
      tst_data_packet_queue = new();
      if (tst_data_packet_queue.randomize()) begin
        $display("================ queue start ============");
        foreach (tst_data_packet_queue.data_packets[i]) begin
          tst_data_packet_queue.data_packets[i].display();
        end
        $display("================ queue end ==============");
      end else begin
        $display("ERROR: FAIL of randomization of tst_data_packet_queue is detected!");
      end
    end
    $display("\n=== inline constraints example ===");
    tst_data_packet_queue = new();
    tst_data_packet_queue.randomize() with {data_packets.size() == 4;};
    foreach (tst_data_packet_queue.data_packets[i]) begin
      tst_data_packet_queue.data_packets[i].display();
    end
  end
  // Waveform dump and finish
  initial begin
    $dumpfile("wave1.vcd");
    $dumpvars(0);  // Dump everything in this module
    #30_000;  // adjust as needed
    $finish();
  end

endmodule
