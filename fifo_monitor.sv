import pkg_transaction::*;
import pkg_coverage::*;
import pkg_scoreboard::*;
module fifo_monitor( FIFO_if.monitor F_if);
FIFO_transaction tran_monitor;
FIFO_coverage   cov_monitor;
FIFO_scoreboard score_monitor;
initial begin
    tran_monitor = new;
    cov_monitor = new;
    score_monitor = new;
    forever begin
        @(F_if.etrigger);
        tran_monitor.rst_n        = F_if.rst_n;
        tran_monitor.wr_en        = F_if.wr_en;
        tran_monitor.rd_en        = F_if.rd_en;
        tran_monitor.data_in      = F_if.data_in;
        tran_monitor.data_out     = F_if.data_out;
        tran_monitor.full         = F_if.full;
        tran_monitor.empty        = F_if.empty;
        tran_monitor.almostfull   = F_if.almostfull;
        tran_monitor.almostempty  = F_if.almostempty;
        tran_monitor.wr_ack       = F_if.wr_ack;
        tran_monitor.overflow     = F_if.overflow;
        tran_monitor.underflow    = F_if.underflow;
        fork
            begin
            cov_monitor.sample_data( tran_monitor );
            end

            begin
            //if(tran_monitor.rst_n) begin
            score_monitor.check_data(tran_monitor );
            //end
            end
        join
    if( F_if.test_finished == 1) begin
        $display(" error_count = %d , correct_count = %d" , score_monitor.error_count , score_monitor. correct_count);   
        $stop;
    end
    end
end
endmodule
