module home_work_2;
  // Instantiate the interface
  clk_if test_clk_if();

  initial begin
      test_clk_if.set_frequency_in_Mhz(100);
      test_clk_if.start_clock();
//       test_clk_if.drive_reset(10, 5);
      #100;
      test_clk_if.drive_reset_async(20, 50);
      #100;
      test_clk_if.stop_clock();
      #50;
      test_clk_if.set_frequency_in_Mhz(10);
      test_clk_if.start_clock();
      #50;
      test_clk_if.stop_clock();
  end

  initial begin
      $dumpfile("wave1.vcd");
      $dumpvars(0);
      #550;
      $finish();
  end

endmodule
