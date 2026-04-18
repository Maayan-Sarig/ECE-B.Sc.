LAB 4
FPGA DIGITAL SYSTEM WITH ALU + PWM
By Ido Mayerowicz & Maayan Sarig


This lab implements a synchronous digital system composed of an ALU, a PWM generator, and a display interface using VHDL. The system is designed for Cyclone II/DE10-Standard boards and uses ModelSim and Quartus for verification.

Inputs:
    - clk: Clock input to PLL (from DE10 board)
    - SW[9:0]: Switch input for data, control selection, and mode
    - KEY[3:0]: Debounced pushbuttons for loading data and reset

Outputs:
    - HEX[5:0]: Seven-segment display output for X, Y, and ALU result
    - LED[9:0]: ALUFN display and flags
    - pwm_out: PWM signal output

Top-Level Entity:
    - top_IO.vhd
      Integrates user I/O (SW, KEY), PLL, digital system, and 7-segment formatter.

Modules:

1. top_digital_system.vhd
    Inputs: X_i, Y_i, ALUFN_i, clk, ena, rst
    Outputs: ALU result, flags, pwm_out
    Description: Wraps `top_alu` and `pwm_unit` and routes ALUFN to each unit based on mode.

2. top_alu.vhd
    Inputs: X, Y, ALUFN
    Outputs: 8-bit result, Flags: C, Z, N, V
    Description: Switches between AdderSub, Logic, and Shifter using ALUFN(4:3).

3. AdderSub.vhd
    Inputs: x, y, ALUFN(2:0)
    Outputs: s, carry
    Description: Implements ADD, SUB, NEG, CMP, SWAP using full adder chain.

4. Logic.vhd
    Inputs: x, y, ALUFN(2:0)
    Outputs: res
    Description: Bitwise logic: AND, OR, XOR, NAND, NOR, NOT, XNOR.

5. Shifter.vhd
    Inputs: x (shift amount), y (value), ALUFN(2:0)
    Outputs: res, cout
    Description: Implements logical shift left/right.

6. pwm_unit.vhd
    Inputs: X, Y, ALUFN(4:0), clk, rst, ena
    Output: pwm_out
    Description: Supports 3 PWM modes: normal, inverted, and toggle.

7. SevenSeg_format.vhd
    Input: 4-bit value
    Output: 7-bit segment pattern
    Description: Converts binary values to 7-segment display format.

8. PLL.vhd
    Inputs: inclk0, areset
    Outputs: c0 (pll_clk), locked
    Description: Quartus-generated PLL module for timing constraints.

9. FA.vhd
    Inputs: a, b, cin
    Outputs: s, cout
    Description: Basic full-adder used by AdderSub.

10. aux_package.vhd
    Description: Declares all project components and shared types.

Use:
    1. Compile in ModelSim (simulate top_IO_tb.vhd)
    2. Compile in Quartus, verify fmax and resource usage
    3. Load .sof onto DE10 board
    4. Use switches and keys to simulate/test

