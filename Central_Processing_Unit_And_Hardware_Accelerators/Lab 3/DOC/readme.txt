SIMPLE RISC MULTI-CYCLE CPU DESIGN WITH VHDL - LAB 3

This lab focuses on designing a multi-cycle CPU based on a simple RISC architecture using VHDL. The system is designed to execute a given program stored in instruction memory and interact with data memory, while following a finite state machine for control.

Inputs:
    - clk: Clock signal.
    - rst: Global system reset.
    - Instruction File: External file containing program instructions.
    - Data File: External file for data memory initialization.

Outputs:
    - Data Memory Result: File showing the content of data memory after program execution.

Modules Overview:
    Top Module (top.vhd): The highest-level entity that integrates the control unit and the datapath.

    1. Register File (RegFile.vhd)
        Inputs: clk, rst, write enable, read addresses, write address
        Outputs: Data read from two registers
        Description: Contains 16 general-purpose registers. Handles read and write operations during instruction execution.

    2. ALU (ALU.vhd)
        Inputs: Two operands, operation code
        Outputs: Result, Flags (Zero, Negative, Carry, Overflow)
        Description: Performs arithmetic and logical operations.

    3. Flag Register (FlagRegister.vhd)
        Inputs: ALU flags
        Outputs: Stored status flags
        Description: Latches the ALU status flags for use in control decisions.

    4. Tristate Buffer (Tristate.vhd)
        Inputs: Data, control enable
        Outputs: Data to shared bus
        Description: Allows safe shared access to the main bus.

    5. Adder (Adder.vhd)
        Inputs: Two binary inputs
        Outputs: Sum
        Description: Simple adder used in address calculations and PC increment.

    6. Datapath (DataPath.vhd)
        Inputs: Control signals, data signals
        Outputs: Intermediate and final results to bus
        Description: Connects all execution units and determines routing of operands and results.

    7. Control FSM (ControlFSM.vhd)
        Inputs: Clock, Reset, Opcode, Flags
        Outputs: Control signals for datapath
        Description: Finite State Machine that sequences control signals based on instruction type.

    8. Control Unit (Control.vhd)
        Inputs: Instruction bits, flags
        Outputs: Signals to control FSM and datapath
        Description: Decodes instructions and manages execution phases.

    9. Program Counter (PC.vhd)
        Inputs: PC load enable, increment, jump address
        Outputs: Current PC value
        Description: Points to the address of the next instruction in memory.

    10. Instruction Memory (InstructionMemory.vhd)
        Inputs: Address from PC
        Outputs: Current instruction
        Description: Stores program instructions; read-only during execution.

    11. Instruction Register (IR.vhd)
        Inputs: Instruction input, enable
        Outputs: Parsed instruction fields
        Description: Temporarily stores fetched instruction for decoding.

    12. Data Memory (DataMemory.vhd)
        Inputs: Address, data input, write enable
        Outputs: Data read
        Description: Read/write memory for program data.

    13. Auxiliary Package (aux_package.vhd)
        Description: Contains constants and type declarations shared across modules.

