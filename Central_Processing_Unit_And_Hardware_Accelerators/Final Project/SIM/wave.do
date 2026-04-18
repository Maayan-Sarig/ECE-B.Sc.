onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/rst_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/clk_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/clk_fir_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/switch_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/KEY1_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/KEY2_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/KEY3_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/LED_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/HEX0_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/HEX1_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/HEX2_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/HEX3_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/HEX4_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/HEX5_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/PWM_out_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/rst_i
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/clk_i
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/switch_i
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/KEY1_i
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/KEY2_i
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/KEY3_i
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/LED_o
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/HEX0_o
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/HEX1_o
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/HEX2_o
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/HEX3_o
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/HEX4_o
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/HEX5_o
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/PWM_out_o
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/MCLK_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/CLKCNT_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/INSTCNT_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/IFpc_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/IDpc_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/EXpc_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/MEMpc_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/WBpc_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/IFinstruction_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/IDinstruction_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/EXinstruction_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/MEMinstruction_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/WBinstruction_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/FHCNT_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/STCNT_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/STRIGGER_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/BPADDR_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/DataBus_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/ControlBus_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/PORT_LED_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/PORT_SW_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/PORT_HEX0_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/PORT_HEX1_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/PORT_HEX2_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/PORT_HEX3_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/PORT_HEX4_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/PORT_HEX5_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/AddressBus_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/BTCTL_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/BTCNT_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/BTCCR0_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/BTCCR1_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/BTIFG_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/IntrSrc_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/INTA_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/MemRead_ctrl_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/MemWrite_ctrl_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/CLR_IRQ_r_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/GIE_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/INTR_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/IRQ_OUT_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/INTR_Active_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/IRQ_FLAGS_OUT_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/FIRIN_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/FIRCTL_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/FIROUT_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/COEF3_0_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/COEF7_4_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/FIRIFG_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/FIFOFULL_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/FIFOEMPTY_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/FIROUT_read_DataBus_ctrl
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/fir_clk
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/modulo_fir_clk_w
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/MCLK_FIR
add wave -noupdate -group MCU -radix hexadecimal /mcu_tb/CORE/modulo_FIRCLK_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/rst_i
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/clk_i
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/BPADDR_i
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/INTR_i
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/DataBus_io
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/CLKCNT_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/INSTCNT_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/IFpc_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/IFinstruction_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/IDpc_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/IDinstruction_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EXpc_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EXinstruction_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEMpc_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEMinstruction_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/WBpc_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/WBinstruction_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/STRIGGER_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/FHCNT_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/STCNT_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ControlBus_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MemRead_ctrl_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MemWrite_ctrl_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/AddressBus_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/GIE_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/INTA_o
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/pc_plus4_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/read_data1_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/read_data2_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/sign_extend_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/alu_result_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/dtcm_data_rd_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/alu_src_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/beq_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/bne_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/j_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/jal_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/reg_dst_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/reg_write_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/zero_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/mem_write_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MemtoReg_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/mem_read_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/alu_op_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/instruction_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MCLK_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/mclk_cnt_q
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/inst_cnt_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/flush_cnt_q
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/stall_cnt_q
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ena
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/PC_IF_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EX_reg_dst_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/Mux_data_write_ID_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_flag_j_branch_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/write_data_EX_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/jump_addr_res_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/branch_addr_res_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/BPADDR_flag_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/IF_instruction_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/IF_PC_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/IF_PC_plus4_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_instruction_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_imm_extended_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_Rs_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_Rt_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_Rd_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_read_data1_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_read_data2_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_PC_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ID_flag_j_branch_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EX_alu_res_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EX_des_reg_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EX_PC_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EX_instruction_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EX_read_data2_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EXtoEX_ctrl_ALUop_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EXtoEX_ctrl_ALUsrc_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EXtoMEM_ctrl_MemRead_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EXtoMEM_ctrl_MemWrite_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EXtoWB_ctrl_RegWrite_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EXtoWB_ctrl_MemtoReg_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EXtoWB_ctrl_RegDst_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEM_DTCM_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEM_alu_res_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEM_des_reg_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEM_PC_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEM_instruction_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEMtoMEM_ctrl_MemRead_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEMtoMEM_ctrl_MemWrite_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEMtoWB_ctrl_RegWrite_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEMtoWB_ctrl_MemtoReg_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/MEMtoWB_ctrl_RegDst_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/WBtoWB_ctrl_RegWrite_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/WBtoWB_ctrl_MemtoReg_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/WBtoWB_ctrl_RegDst_IR
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/Stall_IF_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/Stall_ID_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ctrl_mux_flush_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ForwardA_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ForwardB_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ForwardA_Branch_ID_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ForwardB_Branch_ID_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/data_from_DataBus_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/Mem_addr_wr_mux_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/INTA_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EPC_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/EPC_jump_detect_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/ISR_Addr_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/Read_ISR_ctrl_PC_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/HOLD_PC_ctrl_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/INTR_FLUSH_w
add wave -noupdate -group MIPS -radix hexadecimal /mcu_tb/CORE/CPU/delay_DataBus_w
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/clk_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/rst_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/Bne_ctrl_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/Beq_ctrl_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/jal_ctrl_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/j_ctrl_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/Stall_IF_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/ALUOp_ctrl_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/ID_flag_j_branch_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/jump_addr_res_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/branch_addr_res_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/BPADDR_flag_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/Read_ISR_ctrl_PC_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/ISR_Addr_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/HOLD_PC_ctrl_i
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/pc_o
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/pc_plus4_o
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/instruction_o
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_cnt_o
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/pc_q
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/pc_plus4_r
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/itcm_addr_w
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/next_pc_w
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/rst_flag_q
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_cnt_q
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/pc_prev_q
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/instruction_sig
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/falling_edge_clk_sig
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/wren_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/wren_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/rden_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/rden_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/data_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/data_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/address_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/address_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/clock0
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/clock1
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/clocken0
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/clocken1
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/clocken2
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/clocken3
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/aclr0
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/aclr1
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/addressstall_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/addressstall_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/byteena_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/byteena_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/q_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/q_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/eccstatus
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_data_reg_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_data_reg_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_reg_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_tmp_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_tmp2_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_tmp_wren_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_tmp2_wren_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_tmp_wren_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_reg_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_tmp_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_tmp2_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_output_latch
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_ecc_reg_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_q_ecc_tmp_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_current_written_data_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_original_data_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_original_data_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_mask_reg_a_x
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_mask_reg_b_x
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_mask_reg_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_mask_reg_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_mask_reg_a_out
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_mask_reg_b_out
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_mask_reg_a_out_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_mask_reg_b_out_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_address_reg_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_address_reg_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_wren_reg_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_wren_reg_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_rden_reg_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_rden_reg_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_read_flag_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_read_flag_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_reread_flag_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_reread_flag_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_reread_flag2_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_reread_flag2_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_write_flag_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_write_flag_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_nmram_write_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_nmram_write_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_indata_aclr_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_address_aclr_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_wrcontrol_aclr_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_indata_aclr_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_address_aclr_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_wrcontrol_aclr_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_outdata_aclr_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_outdata_aclr_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_rdcontrol_aclr_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_aclr_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_byteena_aclr_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/good_to_go_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/good_to_go_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_core_clocken_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_core_clocken_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_core_clocken_b0
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_core_clocken_b1
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_inclocken0
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_input_clocken_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_outdata_clken_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_outdata_clken_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_outlatch_clken_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_outlatch_clken_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_core_clocken_a_reg
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_core_clocken_b_reg
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/default_val
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_data_zero_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_data_zero_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_data_ones_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_data_ones_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/same_clock_pulse0
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/same_clock_pulse1
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_force_reread_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_force_reread_a1
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_force_reread_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_force_reread_b1
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_force_reread_signal_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_force_reread_signal_b
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_good_to_write_a
add wave -noupdate -group Ifetch -radix hexadecimal /mcu_tb/CORE/CPU/IFE/inst_memory/i_good_to_write_b
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/clk_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/rst_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/instruction_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/dtcm_data_rd_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/alu_result_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/RegWrite_ctrl_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/MemtoReg_ctrl_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/RegDst_ctrl_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/pc_plus4_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/Jal_ctrl_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/j_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/beq_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/bne_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/MEM_des_reg_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/Stall_ID_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/ForwardA_Branch_ID_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/ForwardB_Branch_ID_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/EX_alu_res_IR_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/Read_ISR_ctrl_PC_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/INTR_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/EPC_i
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/read_data1_o
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/read_data2_o
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/sign_extend_o
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/jump_addr_res_o
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/branch_addr_res_o
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/Mux_data_write_ID_o
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/ID_flag_j_branch_o
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/GIE_o
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/RF_q
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/write_reg_addr_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/write_reg_data_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/rs_register_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/rt_register_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/imm_value_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/sign_extend_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/read_data1_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/read_data2_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/branch_addr_r
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/forward_mux_data1_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/forward_mux_data2_w
add wave -noupdate -group Idecode -radix hexadecimal /mcu_tb/CORE/CPU/ID/ID_flag_j_branch_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/opcode_i
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/func_i
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/INTR_i
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/Read_ISR_ctrl_PC_i
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/HOLD_PC_ctrl_i
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/RegDst_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/ALUSrc_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/MemtoReg_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/RegWrite_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/MemRead_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/MemWrite_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/Beq_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/Bne_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/j_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/Jal_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/ALUOp_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/INTR_FLUSH_o
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/rtype_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/lw_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/sw_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/beq_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/itype_imm_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/bne_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/slti_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/lui_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/jal_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/j_w
add wave -noupdate -group Control -radix hexadecimal /mcu_tb/CORE/CPU/CTL/shift_w
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/read_data1_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/read_data2_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/sign_extend_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/funct_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/OPC
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/ALUOp_ctrl_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/ALUSrc_ctrl_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/Rs_EX_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/Rt_EX_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/Rd_EX_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/EX_alu_res_IR_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/Mux_data_write_ID_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/ForwardA_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/ForwardB_i
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/alu_res_o
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/reg_des_o
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/write_data_EX_o
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/a_input_w
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/b_input_w
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/alu_out_mux_w
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/alu_ctl_w
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/mux_in_alu_A
add wave -noupdate -group Execute -radix hexadecimal /mcu_tb/CORE/CPU/EXE/mux_in_alu_B
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/clk_i
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/rst_i
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/dtcm_addr_i
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/dtcm_data_wr_i
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/MemRead_ctrl_i
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/MemWrite_ctrl_i
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/dtcm_data_rd_o
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/wrclk_w
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/write_ena_sig
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/wren_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/wren_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/rden_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/rden_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/data_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/data_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/address_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/address_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/clock0
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/clock1
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/clocken0
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/clocken1
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/clocken2
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/clocken3
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/aclr0
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/aclr1
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/addressstall_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/addressstall_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/byteena_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/byteena_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/q_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/q_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/eccstatus
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_data_reg_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_data_reg_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_reg_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_tmp_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_tmp2_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_tmp_wren_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_tmp2_wren_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_tmp_wren_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_reg_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_tmp_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_tmp2_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_output_latch
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_ecc_reg_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_q_ecc_tmp_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_current_written_data_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_original_data_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_original_data_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_mask_reg_a_x
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_mask_reg_b_x
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_mask_reg_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_mask_reg_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_mask_reg_a_out
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_mask_reg_b_out
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_mask_reg_a_out_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_mask_reg_b_out_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_address_reg_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_address_reg_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_wren_reg_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_wren_reg_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_rden_reg_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_rden_reg_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_read_flag_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_read_flag_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_reread_flag_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_reread_flag_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_reread_flag2_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_reread_flag2_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_write_flag_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_write_flag_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_nmram_write_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_nmram_write_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_indata_aclr_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_address_aclr_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_wrcontrol_aclr_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_indata_aclr_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_address_aclr_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_wrcontrol_aclr_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_outdata_aclr_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_outdata_aclr_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_rdcontrol_aclr_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_aclr_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_byteena_aclr_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/good_to_go_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/good_to_go_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_core_clocken_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_core_clocken_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_core_clocken_b0
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_core_clocken_b1
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_inclocken0
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_input_clocken_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_outdata_clken_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_outdata_clken_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_outlatch_clken_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_outlatch_clken_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_core_clocken_a_reg
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_core_clocken_b_reg
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/default_val
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_data_zero_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_data_zero_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_data_ones_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_data_ones_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/same_clock_pulse0
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/same_clock_pulse1
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_force_reread_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_force_reread_a1
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_force_reread_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_force_reread_b1
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_force_reread_signal_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_force_reread_signal_b
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_good_to_write_a
add wave -noupdate -group {Data Memory} -radix hexadecimal /mcu_tb/CORE/CPU/G1/MEM1/data_memory/i_good_to_write_b
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/EXtoWB_ctrl_MemtoReg_IR_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/MEMtoWB_ctrl_MemtoReg_IR_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/MEM_des_reg_IR_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/IF_Rs_IR_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/IF_Rt_IR_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/ID_Rt_IR_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/EXtoWB_ctrl_RegWrite_IR_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/Bne_ctrl_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/Beq_ctrl_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/EX_reg_dst_i
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/Stall_IF_o
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/Stall_ID_o
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/ctrl_mux_flush_o
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/stall_lw_w
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/stall_branch_w
add wave -noupdate -group {Hazarad Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Hazard_D/stall_mux_res_w
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/ID_Rs_IR_i
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/ID_Rt_IR_i
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/IF_Rs_IR_i
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/IF_Rt_IR_i
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/EX_des_reg_IR_i
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/MEM_des_reg_IR_i
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/MEMtoWB_ctrl_RegWrite_IR_i
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/WBtoWB_ctrl_RegWrite_IR_i
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/ForwardA_o
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/ForwardB_o
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/ForwardA_Branch_ID_o
add wave -noupdate -group {Forwarding Unit} -radix hexadecimal /mcu_tb/CORE/CPU/Forwarding/ForwardB_Branch_ID_o
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/rst_i
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/AddressBus_i
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/PORT_LED_o
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/PORT_SW_o
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/PORT_HEX0_o
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/PORT_HEX1_o
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/PORT_HEX2_o
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/PORT_HEX3_o
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/PORT_HEX4_o
add wave -noupdate -group {Address Decoder} -radix hexadecimal /mcu_tb/CORE/AD/PORT_HEX5_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/MEMRead_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/MEMWrite_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/DataBus_io
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/switch_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/PORT_LED_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/PORT_SW_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/PORT_HEX0_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/PORT_HEX1_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/PORT_HEX2_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/PORT_HEX3_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/PORT_HEX4_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/PORT_HEX5_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX0_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX1_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX2_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX3_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX4_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX5_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/LED_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX_Output_w
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/LED_connect/MemRead_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/LED_connect/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/LED_connect/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/LED_connect/MemWrite_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/LED_connect/Port_HEX_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/LED_connect/DataBus_to_Device_io
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/LED_connect/HEX_Output_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/LED_connect/D_Latch_w
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX0_7SEG/MemRead_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX0_7SEG/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX0_7SEG/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX0_7SEG/MemWrite_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX0_7SEG/Port_HEX_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX0_7SEG/DataBus_to_Device_io
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX0_7SEG/HEX_Output_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX0_7SEG/D_Latch_w
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX1_7SEG/MemRead_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX1_7SEG/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX1_7SEG/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX1_7SEG/MemWrite_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX1_7SEG/Port_HEX_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX1_7SEG/DataBus_to_Device_io
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX1_7SEG/HEX_Output_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX1_7SEG/D_Latch_w
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX2_7SEG/MemRead_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX2_7SEG/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX2_7SEG/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX2_7SEG/MemWrite_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX2_7SEG/Port_HEX_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX2_7SEG/DataBus_to_Device_io
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX2_7SEG/HEX_Output_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX2_7SEG/D_Latch_w
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX3_7SEG/MemRead_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX3_7SEG/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX3_7SEG/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX3_7SEG/MemWrite_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX3_7SEG/Port_HEX_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX3_7SEG/DataBus_to_Device_io
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX3_7SEG/HEX_Output_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX3_7SEG/D_Latch_w
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX4_7SEG/MemRead_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX4_7SEG/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX4_7SEG/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX4_7SEG/MemWrite_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX4_7SEG/Port_HEX_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX4_7SEG/DataBus_to_Device_io
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX4_7SEG/HEX_Output_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX4_7SEG/D_Latch_w
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX5_7SEG/MemRead_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX5_7SEG/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX5_7SEG/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX5_7SEG/MemWrite_ctrl_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX5_7SEG/Port_HEX_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX5_7SEG/DataBus_to_Device_io
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX5_7SEG/HEX_Output_o
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/HEX5_7SEG/D_Latch_w
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/switch_connect/MemRead_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/switch_connect/Port_HEX_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/switch_connect/switch_i
add wave -noupdate -group GPIO -radix hexadecimal /mcu_tb/CORE/IO_interface/switch_connect/Device_to_DataBus_o
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTCCR0_i
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTCCR1_i
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTHOLD_i
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTCLR_i
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/MCLK_i
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTSSELX_i
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTIPx_i
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTOUTMD_i
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTOUTEN_i
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTCNT_io
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTIFG_o
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/PWM_out_o
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTCL0
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/BTCL1
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/MCLK_2
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/MCLK_4
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/MCLK_8
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/HEU0
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/clk
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/pwm_sig
add wave -noupdate -group {Basic Timer} -radix hexadecimal /mcu_tb/CORE/Timer_connect/modulo_MCLK_w
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/rst_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/clk_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/MemRead_ctrl_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/MemWrite_ctrl_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/AddressBus_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/DataBus_io
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/IntrSrc_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/INTA_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/GIE_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/INTR_o
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/IRQ_OUT_o
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/INTR_Active_o
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/IRQ_CLEARED_OUT_o
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/CLR_IRQ_r_o
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/IRQ_w
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/CLR_IRQ_w
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/IntrEn_w
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/IFG_w
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/TypeReg_w
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/INTA_Delayed_w
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/IntrSrc_6_7_or_w
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /mcu_tb/CORE/Intr_Controller/CLR_IRQ_r
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIRIN_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFORST_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFOCLK_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFOWEN_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIRCLK_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIRRST_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIRENA_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/COEF0_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/COEF1_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/COEF2_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/COEF3_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/COEF4_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/COEF5_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/COEF6_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/COEF7_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIROUT_read_DataBus_ctrl_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/GIE_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/CLR_IRQ_r_i
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIRIFG_o
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFOFULL_o
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFOEMPTY_o
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIROUT_o
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFOREN_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/Din_Pulse_Sync_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/Ds_Pulse_Sync_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/Dout_Pulse_Sync_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/D_zubi_sync_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/read_data_FIFO_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/x_n_0_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/x_n_1_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/x_n_2_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/x_n_3_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/x_n_4_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/x_n_5_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/x_n_6_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/x_n_7_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIR_x_n_sum_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIR_y_n_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIRIFG_sig
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIRENA_sig
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/hold_fifo_read_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/fifo_output_flag_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/data_FIR_out_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/fifo_empty_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/ready_to_read_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/new_read_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/fir_y_n_delay_w
add wave -noupdate -group FIR -radix hexadecimal /mcu_tb/CORE/FIR_connect/freeze_fifo_w
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/i_rst_sync
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/i_clk
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/i_wr_en
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/i_wr_data
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/o_full
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/i_rd_en
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/o_rd_data
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/o_empty
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/r_FIFO_DATA
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/r_WR_INDEX
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/r_RD_INDEX
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/r_FIFO_COUNT
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/w_FULL
add wave -noupdate -group FIFO -radix hexadecimal /mcu_tb/CORE/FIR_connect/FIFO_connect/w_EMPTY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {69 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 324
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {859 ps}
