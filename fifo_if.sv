interface FIFO_if(clk);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic [FIFO_WIDTH-1:0] data_in;
input bit clk;
logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
logic test_finished;

event etrigger;

modport DUT ( input clk , rst_n , wr_en , rd_en , data_in , output data_out , wr_ack , overflow , full , empty , almostempty , almostfull , underflow);

modport test ( output test_finished , etrigger ,rst_n , wr_en , rd_en , data_in , input clk , data_out , wr_ack , overflow , full , empty , almostempty , almostfull , underflow );

modport monitor ( input test_finished , etrigger , clk , rst_n , wr_en , rd_en , data_in ,data_out , wr_ack , overflow , full , empty , almostempty , almostfull , underflow  );

endinterface
