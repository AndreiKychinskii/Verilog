// ADC Convert Function Part
function logic [7:0] adc_convert(input real voltage, output logic [7:0] result);
    real coefficient = 255.0;
    if ((voltage < 0.0) || (voltage > 1.0)) begin
        result = 8'b0;
    end
    else begin
      $display("voltage * coefficient = %.2f", voltage * coefficient);
      result = $rtoi($ceil(voltage * coefficient));
    end
    return result;
endfunction

// Generate Pulse Task Part
task generate_pulse (input int delay_before_rising_edge,
                   input int pulse_duration,
                   input int repeat_counter,
                   output logic signal);
  int delay_b4_rising_edge;
  int duration;
  int num_of_pulses;

  num_of_pulses = repeat_counter;

  while (num_of_pulses > 0) begin
      delay_b4_rising_edge = delay_before_rising_edge;
    while (delay_b4_rising_edge > 1) begin
          @(posedge home_work_1.clk);
          signal = 1'b0;
          delay_b4_rising_edge = delay_b4_rising_edge - 1;
      end
      duration = pulse_duration;
    while (duration >= 0) begin
          @(posedge home_work_1.clk);
          signal = 1'b1;
          duration = duration - 1;
      end
      signal = 1'b0;
      num_of_pulses = num_of_pulses - 1;
  end
endtask

// Execute Task Part
typedef enum logic[2:0] {ADD, SUBTRACT, XOR, AND} operation_code;

typedef struct {
    logic [2:0] operation_code;
    logic [6:0] val_a;
    logic [6:0] val_b;
} cmd;

task execute_cmd (input cmd command,
                input time delay_before_execute,
                output logic [6:0] result);
  #delay_before_execute;
  unique case (command.operation_code)
      ADD: result = do_add(command.val_a, command.val_b);
      SUBTRACT: result = do_subtract(command.val_a, command.val_b);
      XOR: result = do_xor(command.val_a, command.val_b);
      AND: result = do_and(command.val_a, command.val_b);
  endcase
endtask

function logic [6:0] do_add(input logic [6:0] a, input logic [6:0] b);
    logic [6:0] res;
    $display("hello from do_add(...)");
    res = a + b;
    return res;
endfunction

function logic [6:0] do_subtract(input logic [6:0] a, input logic [6:0] b);
    logic [6:0] res;
    $display("hello from do_subtract(...)");
    res = a - b;
    return res;
endfunction

function logic [6:0] do_xor(input logic [6:0] a, input logic [6:0] b);
    logic [6:0] res;
    $display("hello from do_xor(...)");
    res = a ^ b;
    return res;
endfunction

function logic [6:0] do_and(input logic [6:0] a, input logic [6:0] b);
    logic [6:0] res;
    $display("hello from do_and(...)");
    res = a & b;
    return res;
endfunction
