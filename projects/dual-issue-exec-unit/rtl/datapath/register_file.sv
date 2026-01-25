module register_file (
    input  logic clk,
    input  logic we0, we1,
    input  logic [4:0] waddr0, waddr1,
    input  logic [31:0] wdata0, wdata1,
    input  logic [4:0] raddr0a, raddr0b,
    input  logic [4:0] raddr1a, raddr1b,
    output logic [31:0] rdata0a, rdata0b,
    output logic [31:0] rdata1a, rdata1b
);

    logic [31:0] regs[31:0];

    assign rdata0a = regs[raddr0a];
    assign rdata0b = regs[raddr0b];
    assign rdata1a = regs[raddr1a];
    assign rdata1b = regs[raddr1b];

    always_ff @(posedge clk) begin
        if (we0 && waddr0 != 0)
            regs[waddr0] <= wdata0;
        if (we1 && waddr1 != 0)
            regs[waddr1] <= wdata1;
    end

endmodule
