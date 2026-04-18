==========================================
           LAB 1 - VHDL PART 1
          Concurrent Code Design
==========================================

This lab focuses on learning and practice the fundamental parallel hardware concepts using VHDL. 

------------------------------------------
             SYSTEM MODULE
------------------------------------------
Inputs:
  - X  → Input signal
  - Y  → Input signal
  - ALUFN → Control signal  
    	ALUFN[4:3] selects the active module:
      	- 01 → AdderSub
      	- 10 → Shifter
      	- 11 → Logic  
    	ALUFN[2:0] controls each module’s specific function.

Outputs
  - Z (Zero Flag)   → Set if result is zero.
  - C (Carry Flag)  → Set if a carry is generated.
  - N (Negative Flag) → Set if the result is negative.
  - ALUout → The final computed output.

------------------------------------------
             ADDERSUB MODULE
------------------------------------------
This module performs addition or subtraction based on the ALUFN input.

  - Uses a full adder to process two equal-length signals, X and Y.
  - Controlled by `sub_cont`:
      	`sub_cont = 1` → Subtraction
      	`sub_cont = 0` → Addition
  - Also supports a NEG operation computing `X - 0`.

------------------------------------------
             SHIFTER MODULE
------------------------------------------
Implements a barrel shifter controlled by ALUFN.

  - `ALUFN[2:0] = 000` → Shift left
  - `ALUFN[2:0] = 001` → Shift right

The module is built in k layers where: `k = log₂(n)`. 
Each row checks whether a shift should occur based on the corresponding 
bit in X. If the bit is `0`, no shift occurs. Otherwise, the value is shifted.

------------------------------------------
             LOGIC MODULE
------------------------------------------
Executes various logical operations on X and Y based on ALUFN.

  - Logical functions are implemented in VHDL and selected 
    dynamically based on `ALUFN[2:0]`.

------------------------------------------
             TOP MODULE
------------------------------------------
The top-level wrapper for the entire system.  

  - Receives input signals.
  - Routes signals to the correct module.
  - Processes and outputs the final computed result.

------------------------------------------
            FULL ADDER MODULE
------------------------------------------
Implements a Full Adder responsible for bitwise addition with 
carry propagation.

------------------------------------------
              PACKAGE FILE
------------------------------------------
This package contains reusable components required for this lab, 
ensuring modularity and code efficiency.

==========================================
