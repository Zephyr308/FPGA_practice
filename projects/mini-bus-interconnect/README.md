# Mini Bus Interconnect Project

This project demonstrates a **generic, industry-ready memory-mapped bus interconnect** for FPGA.

## Features

- Parameterized **N-to-1 multiplexer** for read data
- Configurable **number of slaves** and **data width**
- Address decoder with flexible address mapping
- Memory-mapped slave registers
- Write/read gating per slave
- Self-checking testbench with assertions
- Industry-style folder structure

## RTL Modules

| Module                | Description |
|-----------------------|-------------|
| `muxNto1.vhd`         | Generic N-to-1 multiplexer |
| `addr_decoder.vhd`    | Decodes address to select one slave |
| `slave_reg.vhd`       | Parameterized memory-mapped register |
| `bus_interconnect.vhd`| Top-level interconnect, instantiates slaves, decoder, and mux |

## Simulation

Run the included **ModelSim / Vivado simulation scripts** or compile with any VHDL simulator.

### Testbench

- `tb_bus_interconnect.vhd` contains a self-checking testbench
- Demonstrates read/write operations on multiple slaves
- Includes assertions for verification

## How to Use

1. Instantiate `bus_interconnect` in your top-level design
2. Connect master signals (`addr`, `wdata`, `rd_en`, `wr_en`) and clock/reset
3. Use generics `WIDTH`, `N`, and `SELW` to scale slaves and data width
4. Run simulation via `tb/tb_bus_interconnect.vhd` to verify functionality
