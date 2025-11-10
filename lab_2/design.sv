interface clk_if();
  logic clk = 1'b0;
	logic rstb = 1'b1;
	logic clk_en;
	time period = 10;
  logic is_started = 1'b0;

	task start_clock();
    $display("Hello from start_clock(...)");
    if (!is_started) begin
      clk_en = 1'b1;
      is_started = 1'b1;
      fork
        forever begin
	          #(period / 2);
	          clk = clk_en ? ~clk : 1'b0;
        end
      join_none
    end else begin
      clk_en = 1'b1;
    end
	endtask

	task stop_clock();
    $display("Hello from stop_clock(...)");
		clk_en = 1'b0;
	endtask

	task set_frequency_in_Mhz(real freqMHz);
		// 1 ns * 1000 = 1 us
		// conversion MHz
		period = ((1.0 / freqMHz) * 1000.0);
	endtask

	task drive_reset(int delay_before_reset, int reset_duration);
		$display("Hello from drive_reset(...)");
		assert (clk_en === 1'b1) else $error("clock generation isn't enabled");
		assert (delay_before_reset > 0) else $error("delay_before_reset < 0");
	    fork begin
		    repeat(delay_before_reset) begin
			    @(posedge clk);
		    end
		    @(negedge clk);
			rstb = 1'b0;
		    repeat(reset_duration) begin
			    @(posedge clk);
		    end
		    @(negedge clk);
			rstb = 1'b1;
		end
		join_none
	endtask

	task drive_reset_async(time delay_before_reset, time reset_duration);
		$display("Hello from drive_reset_async(...)");
		fork begin
			#delay_before_reset;
			rstb = 1'b0;
			#reset_duration;
			rstb = 1'b1;
		end
		join_none
	endtask

endinterface

interface counter_if();
	logic clk;
	logic rstb;
	logic cnt_en;
  logic [3:0] cnt;

	clocking cb0 @(posedge clk);
		input #0 cnt;
		output #0 cnt_en;
	endclocking

	clocking cb1 @(posedge clk);
		input #1step cnt;
		output #20ns cnt_en;
	endclocking

	clocking cb2 @(posedge clk);
		input #100ns cnt;
		output #50 cnt_en;
	endclocking

	clocking cb3 @(posedge clk);
		input #200ns cnt;
		output #100 cnt_en;
	endclocking

endinterface

module counter(input logic clk,
						   input logic rstb,
						   input logic cnt_en,
               output logic [3:0] cnt);
always @(posedge clk or negedge rstb) begin
    if (~rstb) begin
        cnt <= 4'b0000;
    end else if (cnt_en) begin
      cnt <= cnt + 1;
      $display ("pulse cnt = 0x%0h", cnt);
    end
	end

endmodule
