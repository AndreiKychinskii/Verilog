# SystemVerilog Randomization Examples (Homework 4)

This project demonstrates advanced constrained-random verification techniques in SystemVerilog. It consists of three independent but related parts:

1. **Array Randomization** – Randomizing dynamic arrays and queues of class objects with constraints.
2. **ALU Behavioral Model** – A simple randomized command generator for an Arithmetic Logic Unit (ALU) with safe constraints (e.g., no overflow, no invalid division).
3. **Distribution Model** – Demonstration of `rand`, `randc`, and `dist` randomization modes with statistical collection and histogram visualization over an interface.

The code is split into two files:
- `design.sv` – Contains all classes, tasks, and the histogram interface.
- `top.sv` – Top-level module that instantiates objects, drives randomization, and runs simulations.

## Features Demonstrated

### 1. Array Randomization
- `data_packet` class:
  - Random dynamic array `data[]` with size 4–8.
  - Elements strictly increasing and in range [1:10].
  - Array sum constrained to [20:40].
- `data_packet_queue` class:
  - Dynamic array of `data_packet` objects (size 3–6).
  - Pre-allocation of maximum objects in constructor (required for proper randomization).
  - Unique IDs (1–20) across all packets in the queue.
- Inline constraint example in the testbench.

### 2. ALU Model
- `cmd` class generates random ALU operations:
  - Opcodes: ADD, SUB, AND, XOR, MUL, DIV.
  - Constraints prevent invalid/undefined behavior:
    - SUB: `op_a >= op_b`.
    - DIV: Only allows 0/0 when divisor is zero.
    - ADD: Operands limited to avoid overflow.
    - MUL: Operands limited to 8-bit range.
  - Different latency ranges for simple vs. complex operations.
- `execute_randomized_cmd` task:
  - Randomizes command.
  - Delays by randomized latency.
  - Computes and displays result.

### 3. Distribution Model
- `distribution_model` class:
  - `rand_value` – Uniform distribution [1:100].
  - `randc_value` – Cyclic randomization [1:100].
  - `rand_value_with_distribution` – Weighted distribution (higher weight on 45–54).
- Statistical collection into associative arrays.
- Histogram visualization:
  - Sends value/count pairs over a simple interface (`histogram_if`) for potential waveform viewing or external monitoring.

## File Overview

- **design.sv**
  - `data_packet` and `data_packet_queue` classes.
  - `cmd` class and `execute_randomized_cmd` task.
  - `distribution_model` class, interface, and supporting tasks (`collect_stats`, `randomize_rand_values`, `visualize_hist`).

- **top.sv**
  - Top module `home_work_4`.
  - Clock generation.
  - Runs 110,000 randomizations total for distribution stats.
  - Visualizes histograms (three times each).
  - Executes 20 random ALU commands.
  - Demonstrates standalone `data_packet` randomization.
  - Demonstrates `data_packet_queue` randomization (with and without inline constraints).
  - Generates VCD waveform dump (`wave1.vcd`).

## How to Compile and Simulate

Use any SystemVerilog-compliant simulator (VCS, Questa, Incisive, Verilator with extensions, etc.).
