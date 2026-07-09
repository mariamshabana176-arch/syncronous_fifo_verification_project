import pkg_transaction::*;
module FIFO_test( FIFO_if.test F_if);
FIFO_transaction fifo_tb;
initial begin
    fifo_tb = new;
    assert_reset();
    repeat(1000) begin
        assert( fifo_tb.randomize());
        F_if.data_in = fifo_tb.data_in;
        F_if.rst_n = fifo_tb.rst_n;
        F_if.wr_en = fifo_tb.wr_en;
        F_if.rd_en = fifo_tb.rd_en;
        @(negedge F_if.clk);
        -> F_if.etrigger;  
    end

    assert_reset();
    F_if.test_finished = 1;
    -> F_if.etrigger; 
    
end

task assert_reset();
F_if.rst_n = 0;
@(negedge F_if.clk);
F_if.rst_n = 1;
endtask

endmodule
