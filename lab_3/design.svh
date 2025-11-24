class Sensor;
	static int sensor_count = 0;
	string name;
	real value;
	real threshold;
	bit alert;

	extern function new(string init_name = "unknown", real threshold = 0.5);
	extern function void measure(real new_val);
	extern function void display();
	extern function Sensor copy();

	static function void show_count();
		$display("Number of created sensors is %d", Sensor::sensor_count);
	endfunction
endclass : Sensor

function Sensor::new(string init_name = "unknown", real threshold = 0.5);
	this.name = init_name;
	this.value = 0.0;
	this.threshold = threshold;
	this.alert = 1'b0;
	Sensor::sensor_count = Sensor::sensor_count + 1;
endfunction : new

function void Sensor::measure(real new_val);
	this.value = new_val;
	if (this.value > this.threshold) begin
		this.alert = 1'b1;
	end else begin
		this.alert = 1'b0;
	end
endfunction : measure

function void Sensor::display();
	$display("\n");
	$display("=== REPORT: Start ===");
	$display("instance.name is %s", this.name);
	$display("instance.value is %04f", this.value);
	$display("instance.threshold is %04f", this.threshold);
	$display("instance.alert is %d", this.alert);
	$display("=== REPORT: End ===");
endfunction : display

function Sensor Sensor::copy();
	copy = new();
	copy.name = this.name;
	copy.value = this.value;
	copy.threshold = this.threshold;
	copy.alert = this.alert;
endfunction : copy

// this is static task by default
task recreate_object(Sensor s);
	$display("	[Without ref] Before recreate: %s", s.name);
	s = new("Without Ref Sensor", 0.7);
	$display(" [Without ref] After recreate: %s", s.name);
endtask

// this is automatic task
task automatic recreate_object_ref(ref Sensor s);
	$display("	[With ref] Before recreate: %s", s.name);
	s = new("Ref Sensor", 0.9);
 	$display("	[With ref] After recreate: %s", s.name);
endtask
