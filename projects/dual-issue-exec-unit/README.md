# Dual-Issue Pipelined ALU Execution Unit

## Overview
This project implements a dual-issue, FSM-controlled ALU execution unit inspired by CPU microarchitecture. It supports pipelined execution, hazard detection, and clean controller/datapath separation.

## Architecture
Pipeline stages:
FETCH → ACCUMULATE → EXECUTE → WRITEBACK

Two independent issue slots allow parallel ALU execution.

## Hazard Handling
- RAW hazards detected between issue slots
- Stall-based resolution
- No forwarding (by design)

## Verification
- Self-checking SystemVerilog testbench
- Directed tests for pipeline behavior
- Assertions ready for extension

## Limitations & Future Work
- No forwarding paths
- Single-cycle ALU
- No branch or memory ops
