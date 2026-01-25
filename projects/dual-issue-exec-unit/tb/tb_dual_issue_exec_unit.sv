`timescale 1ns/1ps

module tb_dual_issue_exec_unit;

    // Clock and reset
    logic clk = 0;
    logic rst_n = 0;
    always #5 clk = ~clk; // 100MHz

    // DUT signals
    logic [3:0] opcode0, opcode1;
    logic [31:0] src0a, src0b, src1a, src1b;
    logic [31:0] result0, result1;
    logic valid;
    logic stall;
    logic [1:0] state;

    // Instantiate DUT
    alu_controller ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .hazard(stall),
        .stall(stall),
        .state(state)
    );

    alu_datapath dp (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall),
        .state(state),
        .opcode0(opcode0),
        .opcode1(opcode1),
        .src0a(src0a),
        .src0b(src0b),
        .src1a(src1a),
        .src1b(src1b),
        .result0(result0),
        .result1(result1),
        .valid(valid)
    );

    // Randomization classes
    class instr_slot;
        rand logic [3:0] opcode;
        rand logic [31:0] a, b;

        constraint opcode_range { opcode <= 4'h4; } // only valid ops
    endclass

    // Arrays to track issued instructions for golden model
    instr_slot slot0, slot1;
    instr_slot slot0_next, slot1_next;

    // Golden model
    function automatic logic [31:0] golden_alu(logic [3:0] op, logic [31:0] a, logic [31:0] b);
        case(op)
            4'h0: return a + b;
            4'h1: return a - b;
            4'h2: return a & b;
            4'h3: return a | b;
            4'h4: return a ^ b;
            default: return 32'h0;
        endcase
    endfunction

    // Generate new random instructions each FETCH
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            slot0_next = new();
            slot1_next = new();
        end else if(state == 2'b00) begin // FETCH
            slot0_next = new();
            slot1_next = new();
            assert(slot0_next.randomize());
            assert(slot1_next.randomize());
            opcode0 <= slot0_next.opcode;
            src0a   <= slot0_next.a;
            src0b   <= slot0_next.b;
            opcode1 <= slot1_next.opcode;
            src1a   <= slot1_next.a;
            src1b   <= slot1_next.b;
        end
    end

    // Check results at WRITEBACK
    always_ff @(posedge clk) begin
        if(state == 2'b11 && valid) begin
            logic [31:0] golden0, golden1;
            golden0 = golden_alu(slot0_next.opcode, slot0_next.a, slot0_next.b);
            golden1 = golden_alu(slot1_next.opcode, slot1_next.a, slot1_next.b);

            if(result0 !== golden0) begin
                $display("ERROR: slot0 mismatch! expected=%h got=%h", golden0, result0);
            end
            if(result1 !== golden1) begin
                $display("ERROR: slot1 mismatch! expected=%h got=%h", golden1, result1);
            end
            $display("PASS: slot0=%h slot1=%h", result0, result1);
        end
    end

    // Simulation control
    initial begin
        $display("Randomized dual-issue ALU TB start...");
        #10 rst_n = 1;
        #1000;
        $display("Simulation finished.");
        $finish;
    end

endmodule
