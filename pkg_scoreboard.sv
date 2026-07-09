package pkg_scoreboard;
import pkg_transaction::*;
class FIFO_scoreboard;
logic [FIFO_transaction::FIFO_WIDTH-1:0] data_out_ref;
logic wr_ack_ref, overflow_ref;
logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
bit [15:0] fifo[$];
int error_count , correct_count;
bit [7:0] count;



task Reference_model(input FIFO_transaction FIFO_ref);
// count
   if (!FIFO_ref.rst_n) begin
    count <= 0;
  end
  else begin
    if  ( ({FIFO_ref.wr_en, FIFO_ref.rd_en} == 2'b10) && !full_ref) 
      count = count + 1;
    else if ( ({FIFO_ref.wr_en, FIFO_ref.rd_en} == 2'b01) && !empty_ref)
      count = count - 1;
    else if (({FIFO_ref.wr_en, FIFO_ref.rd_en} == 2'b11 )&& full_ref) 
        count = count-1; 
    else if (({FIFO_ref.wr_en, FIFO_ref.rd_en} == 2'b11 )&& empty_ref)
      count = count + 1; 
  end

  // write
  if (!FIFO_ref.rst_n) begin
      wr_ack_ref = 0;
      overflow_ref = 0;
      fifo.delete();
  end
  else if (FIFO_ref.wr_en && count < FIFO_ref.FIFO_DEPTH) begin
    fifo.push_back(FIFO_ref.data_in);
    wr_ack_ref = 1;
 
  end
  else begin 
    wr_ack_ref = 0; 
    if (full_ref & FIFO_ref.wr_en)
      overflow_ref = 1;
    else
      overflow_ref = 0;
  end

  // read
   if (!FIFO_ref.rst_n) begin
    underflow_ref <= 0;
    fifo.delete();
  end
  else if (FIFO_ref.rd_en && count != 0) begin
    fifo.pop_front();
  end
  else if (FIFO_ref.empty & FIFO_ref.rd_en)  
   underflow_ref = 1;
  else begin
   underflow_ref = 0;
  end

 full_ref = (count == FIFO_ref.FIFO_DEPTH)? 1 : 0;
 empty_ref = (count == 0)? 1 : 0;




endtask

  
   


task check_data( input FIFO_transaction FIFO_check );
Reference_model( FIFO_check);
if(data_out_ref != FIFO_check.data_out) begin
$display("error in output");
$display( " data_in = %d , ref_out = %d , out = %d , wr_en = %b , rd_en = %b"
 , FIFO_check. data_in ,data_out_ref , FIFO_check.data_out , FIFO_check.wr_en , FIFO_check.rd_en );

error_count = error_count + 1;
end
else
correct_count = correct_count + 1;
endtask

endclass
endpackage
