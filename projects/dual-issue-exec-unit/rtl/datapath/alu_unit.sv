module alu_unit (
    input  logic [3:0] opcode,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] y
);

    always_comb begin
        case (opcode)
            4'h0: y = a + b;
            4'h1: y = a - b;
            4'h2: y = a & b;
            4'h3: y = a | b;
            4'h4: y = a ^ b;
            default: y = 32'h0;
        endcase
    end

endmodule
