module hazard_unit (
    input logic [4:0] rd0,
    input logic [4:0] rs1_1,
    input logic       regwrite0,
    output logic       hazard
);

    always_comb begin
        hazard = (regwrite0 && (rd0 != 0) && (rd0 == rs1_1));
    end

endmodule
