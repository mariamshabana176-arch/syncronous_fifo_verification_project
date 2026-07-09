package pkg_coverage;
import pkg_transaction::*;
class FIFO_coverage;
FIFO_transaction F_cvg_txn;

covergroup cross_rd_wr;
read: coverpoint F_cvg_txn.rd_en {option.weight = 0;}
write: coverpoint F_cvg_txn.wr_en {option.weight = 0;}
wrack: coverpoint F_cvg_txn.wr_ack {option.weight = 0;}
over_flow: coverpoint F_cvg_txn.overflow {option.weight = 0;}
FULL: coverpoint F_cvg_txn.full {option.weight = 0;}
EMPTY: coverpoint F_cvg_txn.empty {option.weight = 0;}
almost_full: coverpoint F_cvg_txn.almostfull {option.weight = 0;}
almost_empty: coverpoint F_cvg_txn.almostempty {option.weight = 0;}
under_flow : coverpoint F_cvg_txn.underflow {option.weight = 0;}

cross_read_write_wrack: cross  read, write , wrack;
cross_read_write_over_flow: cross  read, write , over_flow;
cross_read_write_FULL: cross  read, write , FULL;
cross_read_write_EMPTY: cross  read, write , EMPTY;
cross_read_write_almost_full: cross  read, write , almost_full;
cross_read_write_almost_empty: cross  read, write , almost_empty;
cross_read_write_under_flow: cross  read, write , under_flow;
endgroup

function new();
cross_rd_wr = new();
endfunction

function void sample_data( input FIFO_transaction F_txn);
F_cvg_txn = F_txn;
cross_rd_wr.sample();
endfunction

endclass
endpackage
