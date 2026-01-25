module tb_dual_issue_exec_unit;

    logic clk = 0;
    logic rst_n = 0;

    always #5 clk = ~clk;

    dual_issue_exec_unit dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        $display("Starting simulation...");
        #10 rst_n = 1;
        #200;
        $display("Simulation complete.");
        $finish;
    end

endmodule
