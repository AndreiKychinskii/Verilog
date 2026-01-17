// typedef mailbox #(string) s_mbox;

class task_packet;

	rand int unsigned exec_time_ns;
	rand int unsigned required_resources;
	int unsigned task_id;

  constraint c_exec_time_ns {exec_time_ns inside {[1:10]}; };
  constraint c_required_resources {required_resources inside {[1:2]}; };

	function new(int unsigned init_task_id);
		task_id = init_task_id;
	endfunction

	function void display();
		$display("task: id = %0d, required_resources = %0d, exec_time_ns = %0d", task_id, required_resources, exec_time_ns);
	endfunction

endclass : task_packet

class task_producer;
	mailbox #(task_packet) task_mb;
	int unsigned next_task_id = 0;  // &&&&

	task run (int n_tasks);
		task_packet tst_task_packet;
		for (int i = 0; i < n_tasks; i = i + 1) begin
			tst_task_packet = new(i + 1);
			if (tst_task_packet.randomize()) begin
				// tst_task_packet.task_id = i;
				$display("prod: pack %0d was generated", i + 1);
				task_mb.put(tst_task_packet);
			end
		end
	endtask

endclass : task_producer

class worker;
	int id;
	mailbox #(task_packet) task_mb;
	semaphore available_resources;
	event finished_work_event;

	function new(int workers_id);
		id = workers_id;
	endfunction

	task run_work();
		fork
			forever begin
				// wait task via mailbox task_mb
				task_packet new_packet;  // or here can be with new()
				task_mb.get(new_packet);
				//
				available_resources.get(new_packet.required_resources);
				$display("worker %0d got pack %d to handle", id, new_packet.task_id);
				#(new_packet.exec_time_ns);
				available_resources.put(new_packet.required_resources);
				// finished_work_event;
				->finished_work_event;
			end
		join_none
	endtask

endclass : worker

class worker_monitor;
	event worker_events[int];
	mailbox #(int) statistic_mb;

	function void add_worker_monitoring(worker w);
		// event finished_work_event;
		// отримує handler of event
	endfunction

	task run_monitoring();
		fork
			forever begin
				foreach (worker_events[i]) begin
					// wait for event
					//
					// @(event)
					//
					// time
					//
					// statistic_mb.put(/* workers id must be here*/);
				end
			end
		join_none
	endtask

endclass : worker_monitor

class statistics_collector;

	mailbox #(int) statistic_mb;
	int stats[int];

  	task run_recording();  // problem if func
		forever begin
			int new_mail_workers_id;
			statistic_mb.get(new_mail_workers_id);
			if (stats.exists(new_mail_workers_id)) begin
				stats[new_mail_workers_id] = stats[new_mail_workers_id] + 1;
			end else begin
				stats[new_mail_workers_id] = 1;
			end
		end
		// void function, but:
		// return;
    endtask

endclass : statistics_collector

class testbench;
	// IPC components
	mailbox #(task_packet) task_mb;
	mailbox #(int) statistic_mb;  // from monitor to statistic collector
	semaphore available_resources;

	// modelling components
	task_producer producer;
	worker workers[4];
	worker_monitor w_monitor;
	statistics_collector stats_collector;

	function void build();
		task_mb = new();
		statistic_mb = new();
		available_resources = new(4);  // pay attention on value
		//
		producer = new();
		w_monitor = new();
		stats_collector = new();
		//
		foreach (workers[i]) begin
			workers[i] = new((i + 1) * 10);
		end
		// return
	endfunction

	function void connect();
		// connects task maibox
		producer.task_mb = task_mb;
		foreach (workers[i]) begin
			workers[i].task_mb = task_mb;
		end
		// connects statistic mailbox
		w_monitor.statistic_mb = statistic_mb;
		stats_collector.statistic_mb = statistic_mb;
		// connects events
		foreach (w_monitor.worker_events[i]) begin
			w_monitor.worker_events[i] = workers[i].finished_work_event;
		end
		// connects semaphores
		foreach (workers[i]) begin
			workers[i].available_resources = available_resources;
		end

	endfunction
  
    task run();
	    // test step-by-step
	    // change order
		producer.run(30);
		foreach (workers[i]) begin
			workers[i].run_work();
		end
    endtask

endclass
