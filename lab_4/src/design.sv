// 
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
		rand_value_with_distribution dist { [45:54] := 10, [1:44] :/ 45, [55:100] :/ 45};  // ????
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
	// $display("Pause is started");
    repeat(100) begin
	    @(posedge ptr_dm.hist_if.clk);
    end
	// $display("Pause is finished");
	repeat (100) begin
		@(posedge ptr_dm.hist_if.clk);
		ptr_dm.hist_if.generated_value = key_idx;
		ptr_dm.hist_if.generated_cnt = stats_rand[key_idx];
		key_idx = key_idx + 1;
	end
endtask

// Task visualize_hist(int unsigned stats_rand[int])
// Функціональність:
// 1. Робить початкову затримку у 100 клок тактів
// 2. Для кожного значення від 1 до 100 на кожному posedge тактового сигналу
// 	передавати статистичні дані (ключ асоціативного масиву ->
// 	histogram_if.generated_value, значення асоціативного масиву ->
// 	histogram_if.generated_cnt);

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
