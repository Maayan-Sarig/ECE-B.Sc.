README - Scalar Pipelined MIPS CPU

@Ido Mayerowicz & Maayan Sarig

Overview:

This project implements a scalar pipelined MIPS-compatible CPU on an FPGA (DE10-Standard board).
The design uses a standard 5-stage pipeline with support for basic forwarding, hazard detection,
register file, ALU operations, and memory access through ITCM and DTCM.

Pipeline Stages:

Instruction Fetch (IF):

Fetches instruction from ITCM using the PC.

PC is incremented by 4 every cycle unless there is a branch or stall.

Includes PC mux logic for handling jumps/branches.

Instruction Decode (ID):

Decodes instruction opcode and extracts control signals.

Reads register values from the Register File.

Sign-extends immediate values.

Hazard Detection Unit can assert a stall if a load-use hazard is detected.

Execution (EX):

ALU performs arithmetic/logic operations (ADD, SUB, SLT, AND, OR, XOR, SRL, etc.).

Forwards operand values when RAW hazard detected using Forwarding Unit.

Calculates branch target address when needed.

Memory Access (MEM):

Load/store operations to DTCM.

Only lw/sw instructions access memory; others pass data through.

Address is computed in EX stage and passed here.

Write Back (WB):

Writes results from ALU or memory back to Register File.

Write enable signal ensures correct register is updated only if needed.

Units in the Design:

Register File:

32 registers of 32-bit width.

Two read ports, one write port.

Synchronous write, asynchronous read.

Control Unit:

Generates control signals for RegWrite, MemRead, MemWrite, ALUSrc, Branch, ALUOp.

Based on opcode and funct fields.

ALU:

Performs bitwise and arithmetic operations.

Controlled via 3-bit alu_ctrl signal decoded from ALUOp and funct fields.

ALU Control Unit:

Maps high-level ALUOp signal + funct to actual ALU operation (e.g., XOR, ANDI, SLTI).

Hazard Detection Unit:

Detects load-use hazard (when EX stage instruction is lw and next instruction uses its result).

Stalls pipeline by disabling PC and IF/ID register, and injecting NOP.

Forwarding Unit:

Checks if destination register of instructions in MEM/WB stage matches sources in EX stage.

Forwards data from later pipeline stage if needed.

Pipeline Registers:

IF/ID, ID/EX, EX/MEM, MEM/WB registers hold instruction and data as it flows.

Each register captures outputs of current stage for next.

Stall/Flush Logic:

PCWrite and IF/ID_Write used to freeze IF/ID when needed.

Flush signal clears instructions when misprediction occurs.

MCU (Top-Level Wrapper):

Wraps core, ITCM/DTCM, address decoder, and peripherals.

Routes interrupts between sources and CPU.

Address Decoder:

Decodes AddressBus to ITCM, DTCM, or peripheral space.

Drives MemRead/MemWrite and read-data mux.

Interrupt Input (Bus Writer):

Peripheral status blocks (Timer/GPIO/FIR) that drive DataBus on reads at their mapped addresses.

Provide live/status/IFG values and assert source IRQ lines.

Interrupt Output (Bus Reader):

Control registers that capture CPU writes from DataBus (enable masks, clear flags).

Used to set IntrEn, clear IFG, and configure interrupt behavior.

Interrupt Controller:

Monitors IFG & IntrEn, asserts INTR_o when any enabled source is pending.

On INTA_i, exposes TypeReg (vector/cause) and clears the matching flag per policy.

GPIO:

Memory-mapped inputs (switches/keys) and outputs (LEDs/HEX).

Optional interrupt on edges/events.

Basic Timer:

Prescaled counter with compare/overflow.

Periodic interrupt for tick/timekeeping.

FIR:

8-tap sample processing with FIFO I/O.

Interrupt on output-ready or FIFO condition.

Memory Mapping:

ITCM (Instruction Tightly-Coupled Memory): Stores program instructions, loaded from MARS.

DTCM (Data Tightly-Coupled Memory): Stores data section, also loaded via HEX file.

Instruction Support:

R-type: ADD, SUB, AND, OR, SLT, XOR

I-type: ADDI, SLTI, ANDI, ORI, LW, SW

Branch: BEQ

Move implemented using ADDU

Shift: SRL

Control Signal Summary:

RegDst: selects between rt and rd for destination

MemtoReg: selects data from ALU or memory

RegWrite: enables writing to register file

MemRead/MemWrite: memory access

Branch: BEQ behavior

ALUSrc: selects second ALU operand

ALUOp: passed to ALU control for decoding operation

Usage:

Compile design in Quartus and load to FPGA.

Load ITCM and DTCM via In-System Memory Content Editor.

Monitor registers, PC, and control signals with SignalTap.