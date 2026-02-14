//==============================================================================
// File Name   : uart_types.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART UVM package containing all UART verification components including
//   transaction, sequences, driver, monitor, agent, environment, and tests.
//
// Notes:
//   - Central package for UART UVM testbench
//   - Imported by tb_top and test files
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_TYPES
`define UART_TYPES

	typedef enum {START, STOP, TX_ON} header_e;
	typedef enum {OK, ERR, TX} state_e;

	typedef virtual uart_if uart_vif;

`endif // UART_TYPES