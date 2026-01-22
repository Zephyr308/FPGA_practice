# Parameterized ALU Project

This project demonstrates a **fully featured, industry-ready Arithmetic Logic Unit (ALU)** for FPGA practice.

## Features

- Parameterized data width (`WIDTH`, default 32-bit)
- Signed and unsigned arithmetic operations
- Common arithmetic: ADD, SUB
- Logic operations: AND, OR, XOR, NOT
- Shift operations: SHL, SHR
- Rotate operations: ROL, ROR
- Multiply and Divide (can be pipelined for FPGA)
- Configurable flags: Zero, Carry, Overflow, Negative, Parity
- Self-checking testbench
- Fully synthesizable and scalable

## RTL Files

| File        | Description |
|------------ |------------ |
| `alu.vhd`   | Parameterized ALU top module with signed/unsigned, rotate, multiply/divide support |

## Testbench

| File         | Description |
|------------- |------------ |
| `tb_alu.vhd` | Self-checking testbench covering arithmetic, logical, shift, rotate, multiply/divide |

## Usage

1. Include `rtl/alu.vhd` in your FPGA project.
2. Instantiate the ALU in your top-level design:
```vhdl
alu_inst: entity work.alu
    generic map(WIDTH => 32)
    port map(
        A => A_signals,
        B => B_signals,
        OP => opcode_signals,
        SIGNED_OP => signed_flag,
        Y => result_signals,
        Zero => zero_flag,
        Carry => carry_flag,
        Overflow => overflow_flag,
        Negative => negative_flag,
        Parity => parity_flag
    );
