module dual_issue_exec_unit (
    input logic clk,
    input logic rst_n
);

    logic stall;
    logic [1:0] state;

    alu_controller ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .hazard(stall),
        .stall(stall),
        .state(state)
    );

endmodule
