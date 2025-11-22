`include "design.svh"

module top;
	// handles creation
	Sensor s1, s2, s3, s4, s5;
	Sensor temp, pressure;

	initial begin
		s1 = new(.init_name("Velocity"), .threshold(500.99));
		s2 = s1;
		s1.name = "Acceleration";
		s1.display();
		s2.display();
		s1 = new(.init_name("Light"), .threshold(101.99));
		s1.display();
		s2.display();
		// s1 = null;
		// s2 = null;
		// # RUNTIME: Fatal Error:
		// RUNTIME_0029 design.sv (30): Null pointer access.
		// s1.display();
		// s2.display();
		// deallocating memory
		s1 = null;
		s2 = null;
	end

	initial begin
		temp = new(.init_name("Temperature"), .threshold(37.0));
		pressure = new(.init_name("Pressure"), .threshold(1.5));
		temp = null;
		pressure = null;
	end

	initial begin
		s3 = new(.init_name("MainSensor"), .threshold(1.0));
		$display("Before call (no ref): %s", s3.name);
		recreate_object(s3);
		$display("After call (no ref): %s", s3.name);
		$display("Before call (ref): %s", s3.name);
		recreate_object_ref(s3);
		$display("After call (ref): %s", s3.name);
		s3 = null;
	end

	initial begin
		s4 = new(.init_name("Voltage"), .threshold(3.3));
		s4.measure(3.0);
		s4.measure(3.2);
		s4.measure(3.4);
		s5 = s4.copy();
		s4.display();
		s5.display();
		s4.name = "High Voltage";
		s4.threshold = 1000.0;
		s4.measure(100.0);
		s4.display();
		s5.display();
		// print static value
		s5.show_count();
		Sensor::show_count();
		s4 = null;
		s5 = null;
	end

endmodule
