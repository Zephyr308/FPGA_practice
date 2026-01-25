module alu_controller (
    input  logic clk,
    input  logic rst_n,
    input  logic hazard,

    output logic stall,
    output logic [1:0] state
);

    typedef enum logic [1:0] {
        FETCH  = 2'b00,
        ACC    = 2'b01,
        EXEC   = 2'b10,
        WB     = 2'b11
    } state_t;

    state_t curr, next;

    assign state = curr;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            curr <= FETCH;
        else if (!stall)
            curr <= next;
    end

    always_comb begin
        stall = hazard;
        next  = curr;

        case (curr)
            FETCH: next = ACC;
            ACC:   next = EXEC;
            EXEC:  next = WB;
            WB:    next = FETCH;
        endcase

        if (hazard)
            next = curr;
    end

endmodule
