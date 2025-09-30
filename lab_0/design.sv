// Code your design here
module element_or(input a, input b, output out);
  assign out = a | b;
endmodule

module element_not(input a, output out);
  // or
  // assign not_out = !a;
  assign out = ~a;
endmodule

module element_and(input a, input b, output out);
  assign out = a & b;
endmodule

module element_d_flip_flop(input data, input clock, output logic out);
  always @(posedge clock)
    begin
      // blocking assignment:
      // d_ff_out = data;
      out <= data;
    end
endmodule
