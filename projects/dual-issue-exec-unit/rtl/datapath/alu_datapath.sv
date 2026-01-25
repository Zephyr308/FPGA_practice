module alu_datapath (
    input logic clk,
    input logic rst_n,
    input logic stall,
    input logic [1:0] state,

    input logic [3:0] opcode0, opcode1,
    input logic [31:0] src0a, src0b,
    input logic [31:0] src1a, src1b,

    output logic [31:0] result0, result1,
    output logic valid
);

    logic [3:0] op0_r, op1_r;
    logic [31:0] a0_r, b0_r, a1_r, b1_r;
    logic [31:0] alu0_y, alu1_y;

    alu_unit alu0 (.opcode(op0_r), .a(a0_r), .b(b0_r), .y(alu0_y));
    alu_unit alu1 (.opcode(op1_r), .a(a1_r), .b(b1_r), .y(alu1_y));

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid <= 1'b0;
        end else if (!stall) begin
            case (state)
                2'b00: begin
                    op0_r <= opcode0;
                    op1_r <= opcode1;
                    a0_r  <= src0a;
                    b0_r  <= src0b;
                    a1_r  <= src1a;
                    b1_r  <= src1b;
                    valid <= 1'b0;
                end
                2'b10: begin
                    result0 <= alu0_y;
                    result1 <= alu1_y;
                end
                2'b11: valid <= 1'b1;
            endcase
        end
    end

endmodule
