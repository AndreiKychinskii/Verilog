module home_work_2;
  // Instantiate the interfaces
  clk_if test_clk_if();
//   initial begin
//     //testcase1 
//     test_clk_if.set_frequency_in_Mhz(100);
//     test_clk_if.start_clock();
//     test_clk_if.drive_reset_async(10, 20);
//     #50;
//     test_clk_if.drive_reset(10, 5);
//     #50;
//     test_clk_if.stop_clock();
//     #20;
//   end

  counter_if test_counter_if();

  assign test_counter_if.clk = test_clk_if.clk;
  assign test_counter_if.rstb = test_clk_if.rstb;
  
  counter test_counter (
    .clk(test_counter_if.clk),
    .rstb(test_counter_if.rstb),
    .cnt_en(test_counter_if.cnt_en),
    .cnt(test_counter_if.cnt)
  );

  initial begin
//     #500;
    // Frequency setup
    test_clk_if.set_frequency_in_Mhz(10);
    // Run clock generation
    test_clk_if.start_clock();
    // Clock sync reset
    test_clk_if.drive_reset(5, 5);
    // Enable counter interface
    test_counter_if.cnt_en <= 1;
    // A few clocks pause
    repeat(5) @(test_counter_if.cb0);
    // Analysis via fork-join
    fork
      begin
        @(test_counter_if.cb0);
        $display ("cb0.cnt = 0x%0h", test_counter_if.cb0.cnt);
      end
      begin
        @(test_counter_if.cb1);
        $display ("cb1.cnt = 0x%0h", test_counter_if.cb1.cnt);
      end
      begin
        @(test_counter_if.cb2);
        $display ("cb2.cnt = 0x%0h", test_counter_if.cb2.cnt);
      end
      begin
        @(test_counter_if.cb3);
        $display ("cb3.cnt = 0x%0h", test_counter_if.cb3.cnt);
      end
    join
    test_counter_if.cnt_en <= 0;
    
    // Set cnt_en via different clocking block
    @(test_counter_if.cb0); test_counter_if.cb0.cnt_en <= 1;
    @(test_counter_if.cb0); test_counter_if.cb0.cnt_en <= 0;
    @(test_counter_if.cb1); test_counter_if.cb1.cnt_en <= 1;
    @(test_counter_if.cb1); test_counter_if.cb1.cnt_en <= 0;
    @(test_counter_if.cb2); test_counter_if.cb2.cnt_en <= 1;
    @(test_counter_if.cb2); test_counter_if.cb2.cnt_en <= 0;
    @(test_counter_if.cb3); test_counter_if.cb3.cnt_en <= 1;
    @(test_counter_if.cb3); test_counter_if.cb3.cnt_en <= 0;

  end

  // Waveform dump and finish
  initial begin
    $dumpfile("wave1.vcd");
    $dumpvars(0);  // Dump everything in this module
    #5000;  // adjust as needed
    $finish();
  end
endmodule
