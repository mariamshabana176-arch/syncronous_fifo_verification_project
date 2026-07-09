module FIFO( FIFO_if.DUT F_if);

 
localparam max_fifo_addr = $clog2(F_if.FIFO_DEPTH);

reg [F_if.FIFO_WIDTH-1:0] mem [F_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge F_if.clk or negedge F_if.rst_n) begin
  if (!F_if.rst_n) begin
    wr_ptr <= 0;
    //bugs to be fixed --> reset was missing for wr_ack and overflow
      F_if.wr_ack <= 0;
      F_if.overflow <= 0;
  end
  else if (F_if.wr_en && count < F_if.FIFO_DEPTH) begin
    mem[wr_ptr] <= F_if.data_in;
    F_if.wr_ack <= 1;
    wr_ptr <= wr_ptr + 1;
  end
  else begin 
    F_if.wr_ack <= 0; 
    if (F_if.full & F_if.wr_en)
      F_if.overflow <= 1;
    else
      F_if.overflow <= 0;
  end
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
  if (!F_if.rst_n) begin
    rd_ptr <= 0;
    F_if.underflow <= 0; //bug to be fixed --> reset was missing for underflowc
  end
  else if (F_if.rd_en && count != 0) begin
    F_if.data_out <= mem[rd_ptr];
    rd_ptr <= rd_ptr + 1;
  end
  else if (F_if.empty & F_if.rd_en)  //bug to be fixed --> underflow was not set--> should be written in sequential manner
    F_if.underflow <= 1;
  else
    F_if.underflow <= 0;
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
  if (!F_if.rst_n) begin
    count <= 0;
  end
  else begin
    if  ( ({F_if.wr_en, F_if.rd_en} == 2'b10) && !F_if.full) 
      count <= count + 1;
    else if ( ({F_if.wr_en, F_if.rd_en} == 2'b01) && !F_if.empty)
      count <= count - 1;
    else if (({F_if.wr_en, F_if.rd_en} == 2'b11 )&& F_if.full) //bugs needs to be fixed 
        count <= count-1; // no change
    else if (({F_if.wr_en, F_if.rd_en} == 2'b11 )&& F_if.empty)
      count <= count + 1; // no change
  end
end

assign F_if.full = (count == F_if.FIFO_DEPTH)? 1 : 0;
assign F_if.empty = (count == 0)? 1 : 0;
//assign F_if.underflow = (F_if.empty && F_if.rd_en)? 1 : 0; 
assign F_if.almostfull = (count == F_if.FIFO_DEPTH-1)? 1 : 0; 
assign F_if.almostempty = (count == 1)? 1 : 0;


// assertions 
assert property ( @(posedge F_if.clk) disable iff (!F_if.rst_n) count == F_if.FIFO_DEPTH |-> F_if.full );
assert property ( @(posedge F_if.clk) disable iff (!F_if.rst_n) count == 0 |-> F_if.empty );
assert property ( @(posedge F_if.clk) disable iff (!F_if.rst_n) count == F_if.FIFO_DEPTH-1 |-> F_if.almostfull );
assert property ( @(posedge F_if.clk) disable iff (!F_if.rst_n) count == 1 |-> F_if.almostempty );
assert property ( @(posedge F_if.clk) disable iff (!F_if.rst_n) (count == 0 && F_if.rd_en) /*|->*/ |=> F_if.underflow );
assert property ( @(posedge F_if.clk) disable iff (!F_if.rst_n) (count == F_if.FIFO_DEPTH && F_if.wr_en) |=> F_if.overflow );
assert property ( @(posedge F_if.clk)  disable iff (!F_if.rst_n) (F_if.wr_en && count < F_if.FIFO_DEPTH) |=> F_if.wr_ack );

always_comb begin
    if(!F_if.rst_n)
    assert  final  (count == 0 && wr_ptr == 0 && rd_ptr == 0 &&
     F_if.wr_ack == 0 && F_if.overflow == 0);
end



endmodule
