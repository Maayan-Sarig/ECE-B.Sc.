onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group test_I/O /mips_tb/rst_tb_i
add wave -noupdate -group test_I/O /mips_tb/clk_tb_i
add wave -noupdate -group test_I/O /mips_tb/bpaddr_tb_i
add wave -noupdate -group test_I/O /mips_tb/mclk_cnt_tb_o
add wave -noupdate -group test_I/O /mips_tb/inst_cnt_tb_o
add wave -noupdate -group test_I/O /mips_tb/if_pc_tb_o
add wave -noupdate -group test_I/O /mips_tb/if_inst_tb_o
add wave -noupdate -group test_I/O /mips_tb/id_pc_tb_o
add wave -noupdate -group test_I/O /mips_tb/id_inst_tb_o
add wave -noupdate -group test_I/O /mips_tb/ex_pc_tb_o
add wave -noupdate -group test_I/O /mips_tb/ex_inst_tb_o
add wave -noupdate -group test_I/O /mips_tb/mem_pc_tb_o
add wave -noupdate -group test_I/O /mips_tb/mem_inst_tb_o
add wave -noupdate -group test_I/O /mips_tb/wb_pc_tb_o
add wave -noupdate -group test_I/O /mips_tb/wb_inst_tb_o
add wave -noupdate -group test_I/O /mips_tb/strigger_tb_o
add wave -noupdate -group test_I/O /mips_tb/flush_cnt_tb_o
add wave -noupdate -group test_I/O /mips_tb/stall_cnt_tb_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/rst_i
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/clk_i
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/BPADDR_i
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/CLKCNT_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/INSTCNT_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/IFpc_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/IFinstruction_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/IDpc_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/IDinstruction_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/EXpc_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/EXinstruction_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/MEMpc_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/MEMinstruction_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/WBpc_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/WBinstruction_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/STRIGGER_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/FHCNT_o
add wave -noupdate -group {test_I/O 2} /mips_tb/CORE/STCNT_o
add wave -noupdate -group MIPS_wires /mips_tb/CORE/pc_plus4_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/read_data1_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/read_data2_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/sign_extend_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/alu_result_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/dtcm_data_rd_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/alu_src_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/beq_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/bne_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/j_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/jal_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/reg_dst_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/reg_write_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/zero_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/mem_write_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/MemtoReg_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/mem_read_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/alu_op_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/instruction_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/MCLK_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/mclk_cnt_q
add wave -noupdate -group MIPS_wires /mips_tb/CORE/inst_cnt_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/flush_cnt_q
add wave -noupdate -group MIPS_wires /mips_tb/CORE/stall_cnt_q
add wave -noupdate -group MIPS_wires /mips_tb/CORE/ena
add wave -noupdate -group MIPS_wires /mips_tb/CORE/PC_IF_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/EX_reg_dst_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/Mux_data_write_ID_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/ID_flag_j_branch_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/write_data_EX_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/jump_addr_res_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/branch_addr_res_w
add wave -noupdate -group MIPS_wires /mips_tb/CORE/BPADDR_flag_w
add wave -noupdate -group IF_IR /mips_tb/CORE/IF_instruction_IR
add wave -noupdate -group IF_IR /mips_tb/CORE/IF_PC_IR
add wave -noupdate -group IF_IR /mips_tb/CORE/IF_PC_plus4_IR
add wave -noupdate -group ID_IR /mips_tb/CORE/ID_instruction_IR
add wave -noupdate -group ID_IR /mips_tb/CORE/ID_imm_extended_IR
add wave -noupdate -group ID_IR /mips_tb/CORE/ID_Rs_IR
add wave -noupdate -group ID_IR /mips_tb/CORE/ID_Rt_IR
add wave -noupdate -group ID_IR /mips_tb/CORE/ID_Rd_IR
add wave -noupdate -group ID_IR /mips_tb/CORE/ID_read_data1_IR
add wave -noupdate -group ID_IR /mips_tb/CORE/ID_read_data2_IR
add wave -noupdate -group ID_IR /mips_tb/CORE/ID_PC_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EX_alu_res_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EX_des_reg_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EX_PC_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EX_instruction_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EX_read_data2_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EXtoEX_ctrl_ALUop_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EXtoEX_ctrl_ALUsrc_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EXtoMEM_ctrl_MemRead_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EXtoMEM_ctrl_MemWrite_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EXtoWB_ctrl_RegWrite_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EXtoWB_ctrl_MemtoReg_IR
add wave -noupdate -group EX_IR /mips_tb/CORE/EXtoWB_ctrl_RegDst_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEM_DTCM_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEM_alu_res_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEM_des_reg_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEM_PC_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEM_instruction_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEMtoMEM_ctrl_MemRead_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEMtoMEM_ctrl_MemWrite_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEMtoWB_ctrl_RegWrite_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEMtoWB_ctrl_MemtoReg_IR
add wave -noupdate -group MEM_IR /mips_tb/CORE/MEMtoWB_ctrl_RegDst_IR
add wave -noupdate -group WB_IR /mips_tb/CORE/WBtoWB_ctrl_RegWrite_IR
add wave -noupdate -group WB_IR /mips_tb/CORE/WBtoWB_ctrl_MemtoReg_IR
add wave -noupdate -group WB_IR /mips_tb/CORE/WBtoWB_ctrl_RegDst_IR
add wave -noupdate -group {MIPS wires2} /mips_tb/CORE/Stall_IF_w
add wave -noupdate -group {MIPS wires2} /mips_tb/CORE/Stall_ID_w
add wave -noupdate -group {MIPS wires2} /mips_tb/CORE/ctrl_mux_flush_w
add wave -noupdate -group {MIPS wires2} /mips_tb/CORE/ForwardA_w
add wave -noupdate -group {MIPS wires2} /mips_tb/CORE/ForwardB_w
add wave -noupdate -group {MIPS wires2} /mips_tb/CORE/ForwardA_Branch_ID_w
add wave -noupdate -group {MIPS wires2} /mips_tb/CORE/ForwardB_Branch_ID_w
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/clk_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/rst_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/Bne_ctrl_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/Beq_ctrl_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/jal_ctrl_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/j_ctrl_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/Stall_IF_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/ALUOp_ctrl_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/ID_flag_j_branch_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/jump_addr_res_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/branch_addr_res_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/BPADDR_flag_i
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/pc_o
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/pc_plus4_o
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/instruction_o
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_cnt_o
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/pc_q
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/pc_plus4_r
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/itcm_addr_w
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/next_pc_w
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/rst_flag_q
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_cnt_q
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/pc_prev_q
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/instruction_sig
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/falling_edge_clk_sig
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/wren_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/wren_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/rden_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/rden_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/data_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/data_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/address_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/address_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/clock0
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/clock1
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/clocken0
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/clocken1
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/clocken2
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/clocken3
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/aclr0
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/aclr1
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/addressstall_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/addressstall_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/byteena_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/byteena_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/q_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/q_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/eccstatus
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_data_reg_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_data_reg_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_reg_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_tmp_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_tmp2_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_tmp_wren_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_tmp2_wren_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_tmp_wren_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_reg_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_tmp_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_tmp2_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_output_latch
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_ecc_reg_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_q_ecc_tmp_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_current_written_data_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_original_data_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_original_data_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_mask_reg_a_x
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_mask_reg_b_x
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_mask_reg_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_mask_reg_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_mask_reg_a_out
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_mask_reg_b_out
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_mask_reg_a_out_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_mask_reg_b_out_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_address_reg_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_address_reg_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_wren_reg_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_wren_reg_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_rden_reg_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_rden_reg_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_read_flag_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_read_flag_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_reread_flag_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_reread_flag_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_reread_flag2_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_reread_flag2_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_write_flag_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_write_flag_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_nmram_write_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_nmram_write_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_indata_aclr_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_address_aclr_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_wrcontrol_aclr_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_indata_aclr_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_address_aclr_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_wrcontrol_aclr_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_outdata_aclr_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_outdata_aclr_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_rdcontrol_aclr_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_aclr_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_byteena_aclr_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/good_to_go_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/good_to_go_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_core_clocken_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_core_clocken_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_core_clocken_b0
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_core_clocken_b1
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_inclocken0
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_input_clocken_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_outdata_clken_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_outdata_clken_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_outlatch_clken_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_outlatch_clken_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_core_clocken_a_reg
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_core_clocken_b_reg
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/default_val
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_data_zero_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_data_zero_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_data_ones_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_data_ones_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/same_clock_pulse0
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/same_clock_pulse1
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_force_reread_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_force_reread_a1
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_force_reread_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_force_reread_b1
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_force_reread_signal_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_force_reread_signal_b
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_good_to_write_a
add wave -noupdate -group IFetch /mips_tb/CORE/IFE/inst_memory/i_good_to_write_b
add wave -noupdate -group IDecode /mips_tb/CORE/ID/clk_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/rst_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/instruction_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/dtcm_data_rd_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/alu_result_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/RegWrite_ctrl_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/MemtoReg_ctrl_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/RegDst_ctrl_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/pc_plus4_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/Jal_ctrl_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/j_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/beq_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/bne_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/MEM_des_reg_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/Stall_ID_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/ForwardA_Branch_ID_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/ForwardB_Branch_ID_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/EX_alu_res_IR_i
add wave -noupdate -group IDecode /mips_tb/CORE/ID/read_data1_o
add wave -noupdate -group IDecode /mips_tb/CORE/ID/read_data2_o
add wave -noupdate -group IDecode /mips_tb/CORE/ID/sign_extend_o
add wave -noupdate -group IDecode /mips_tb/CORE/ID/jump_addr_res_o
add wave -noupdate -group IDecode /mips_tb/CORE/ID/branch_addr_res_o
add wave -noupdate -group IDecode /mips_tb/CORE/ID/Mux_data_write_ID_o
add wave -noupdate -group IDecode /mips_tb/CORE/ID/ID_flag_j_branch_o
add wave -noupdate -group IDecode /mips_tb/CORE/ID/RF_q
add wave -noupdate -group IDecode /mips_tb/CORE/ID/write_reg_addr_w
add wave -noupdate -group IDecode /mips_tb/CORE/ID/write_reg_data_w
add wave -noupdate -group IDecode /mips_tb/CORE/ID/rs_register_w
add wave -noupdate -group IDecode /mips_tb/CORE/ID/rt_register_w
add wave -noupdate -group IDecode /mips_tb/CORE/ID/imm_value_w
add wave -noupdate -group IDecode /mips_tb/CORE/ID/sign_extend_w
add wave -noupdate -group IDecode /mips_tb/CORE/ID/read_data1_w
add wave -noupdate -group IDecode /mips_tb/CORE/ID/read_data2_w
add wave -noupdate -group IDecode /mips_tb/CORE/ID/branch_addr_r
add wave -noupdate -group IDecode /mips_tb/CORE/ID/forward_mux_data1_w
add wave -noupdate -group IDecode /mips_tb/CORE/ID/forward_mux_data2_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/opcode_i
add wave -noupdate -group Control /mips_tb/CORE/CTL/func_i
add wave -noupdate -group Control /mips_tb/CORE/CTL/RegDst_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/ALUSrc_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/MemtoReg_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/RegWrite_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/MemRead_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/MemWrite_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/Beq_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/Bne_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/j_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/Jal_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/ALUOp_ctrl_o
add wave -noupdate -group Control /mips_tb/CORE/CTL/rtype_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/lw_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/sw_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/beq_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/itype_imm_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/bne_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/slti_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/lui_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/jal_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/j_w
add wave -noupdate -group Control /mips_tb/CORE/CTL/shift_w
add wave -noupdate -group Execute /mips_tb/CORE/EXE/read_data1_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/read_data2_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/sign_extend_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/funct_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/OPC
add wave -noupdate -group Execute /mips_tb/CORE/EXE/ALUOp_ctrl_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/ALUSrc_ctrl_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/Rs_EX_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/Rt_EX_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/Rd_EX_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/EX_alu_res_IR_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/Mux_data_write_ID_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/ForwardA_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/ForwardB_i
add wave -noupdate -group Execute /mips_tb/CORE/EXE/alu_res_o
add wave -noupdate -group Execute /mips_tb/CORE/EXE/reg_des_o
add wave -noupdate -group Execute /mips_tb/CORE/EXE/write_data_EX_o
add wave -noupdate -group Execute /mips_tb/CORE/EXE/a_input_w
add wave -noupdate -group Execute /mips_tb/CORE/EXE/b_input_w
add wave -noupdate -group Execute /mips_tb/CORE/EXE/alu_out_mux_w
add wave -noupdate -group Execute /mips_tb/CORE/EXE/alu_ctl_w
add wave -noupdate -group Execute /mips_tb/CORE/EXE/mux_in_alu_A
add wave -noupdate -group Execute /mips_tb/CORE/EXE/mux_in_alu_B
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/clk_i
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/rst_i
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/dtcm_addr_i
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/dtcm_data_wr_i
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/MemRead_ctrl_i
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/MemWrite_ctrl_i
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/dtcm_data_rd_o
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/wrclk_w
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/wren_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/wren_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/rden_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/rden_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/data_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/data_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/address_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/address_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/clock0
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/clock1
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/clocken0
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/clocken1
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/clocken2
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/clocken3
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/aclr0
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/aclr1
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/addressstall_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/addressstall_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/byteena_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/byteena_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/q_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/q_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/eccstatus
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_data_reg_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_data_reg_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_reg_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_tmp_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_tmp2_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_tmp_wren_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_tmp2_wren_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_tmp_wren_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_reg_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_tmp_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_tmp2_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_output_latch
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_ecc_reg_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_q_ecc_tmp_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_current_written_data_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_original_data_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_original_data_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_mask_reg_a_x
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_mask_reg_b_x
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_mask_reg_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_mask_reg_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_mask_reg_a_out
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_mask_reg_b_out
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_mask_reg_a_out_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_mask_reg_b_out_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_address_reg_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_address_reg_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_wren_reg_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_wren_reg_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_rden_reg_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_rden_reg_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_read_flag_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_read_flag_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_reread_flag_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_reread_flag_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_reread_flag2_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_reread_flag2_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_write_flag_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_write_flag_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_nmram_write_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_nmram_write_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_indata_aclr_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_address_aclr_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_wrcontrol_aclr_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_indata_aclr_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_address_aclr_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_wrcontrol_aclr_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_outdata_aclr_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_outdata_aclr_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_rdcontrol_aclr_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_aclr_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_byteena_aclr_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/good_to_go_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/good_to_go_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_core_clocken_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_core_clocken_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_core_clocken_b0
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_core_clocken_b1
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_inclocken0
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_input_clocken_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_outdata_clken_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_outdata_clken_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_outlatch_clken_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_outlatch_clken_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_core_clocken_a_reg
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_core_clocken_b_reg
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/default_val
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_data_zero_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_data_zero_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_data_ones_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_data_ones_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/same_clock_pulse0
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/same_clock_pulse1
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_force_reread_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_force_reread_a1
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_force_reread_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_force_reread_b1
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_force_reread_signal_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_force_reread_signal_b
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_good_to_write_a
add wave -noupdate -group Memory /mips_tb/CORE/G1/MEM1/data_memory/i_good_to_write_b
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/EXtoWB_ctrl_MemtoReg_IR_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/MEMtoWB_ctrl_MemtoReg_IR_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/MEM_des_reg_IR_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/IF_Rs_IR_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/IF_Rt_IR_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/ID_Rt_IR_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/EXtoWB_ctrl_RegWrite_IR_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/Bne_ctrl_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/Beq_ctrl_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/EX_reg_dst_i
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/Stall_IF_o
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/Stall_ID_o
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/ctrl_mux_flush_o
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/stall_lw_w
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/stall_branch_w
add wave -noupdate -group {Hazard detection} /mips_tb/CORE/Hazard_D/stall_mux_res_w
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/ID_Rs_IR_i
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/ID_Rt_IR_i
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/IF_Rs_IR_i
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/IF_Rt_IR_i
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/EX_des_reg_IR_i
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/MEM_des_reg_IR_i
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/MEMtoWB_ctrl_RegWrite_IR_i
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/WBtoWB_ctrl_RegWrite_IR_i
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/ForwardA_o
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/ForwardB_o
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/ForwardA_Branch_ID_o
add wave -noupdate -group {Forwarding unit} /mips_tb/CORE/Forwarding/ForwardB_Branch_ID_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999296 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 355
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
WaveRestoreZoom {0 ps} {867043 ps}
