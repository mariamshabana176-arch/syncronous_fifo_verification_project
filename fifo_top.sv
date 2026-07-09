module FIFO_TOP();
bit clk = 0;
always #50 clk = ~clk;

FIFO_if F_if(clk);
FIFO DUT(F_if);
fifo_monitor mo(F_if);
FIFO_test test(F_if);
endmodule
