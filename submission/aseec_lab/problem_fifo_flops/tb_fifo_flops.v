module tb_fifo();

reg clk, rst;
reg push_valid, pop_valid;
reg push_data, pop_data;
wire push_ready, pop_ready;

fifo_flops #(.clk(clk),
          .rst(rst),
          .push_ready(push_ready),
          .push_valid(push_valid),
          .pop_valid(pop_valid),
          .push_data(push_data),
          .pop_data(pop_data),
          .slots(slots),
          .slots_next(slots_next),
          .items(items),
          .items_next(items_next),
          .full(full),
          .full_next(full_next),
          .empty(empty),
          .empty_next(empty_next)
         )u0 (.clk(clk),
             .rst(rst),
             .push_ready(push_ready),
             .push_valid(push_valid),
             .pop_valid(pop_valid),
             .push_data(push_data),
             .pop_data(pop_data),
             .slots(slots),
             .slots_next(slots_next),
             .items(items),
             .items_next(items_next),
             .full(full),
             .full_next(full_next),
             .empty(empty),
             .empty_next(empty_next)
             );

initial
begin
  clk = 0;
  rst = 0;
  push_valid = 0;
  pop_valid = 0;
  push_data = 0;
  pop_data = 0;
  push_ready = 0;
  pop_ready = 0;

  // Test the FIFO with a series of push transactions
  for(int i = 0; i < 16; i++)
  begin
    #10;
    push_valid = 1;
    push_data = i;
    #10;
    push_valid = 0;
    #10;
  end

  // Test the FIFO with a series of pop transactions
  for(int i = 0; i < 16; i++)
  begin
    #10;
    pop_valid = 1;
    pop_data = i;
    #10;
    pop_valid = 0;
    #10;
  end

  // Test the FIFO with a mix of push and pop transactions
  for(int i = 0; i < 16; i++)
  begin
    #10;
    push_valid = 1;
    push_data = i;
    pop_valid = 1;
    pop_data = i;
    #10;
    push_valid = 0;
    pop_valid = 0;
    #10;
  end

  // Test the FIFO with the reset signal
  rst = 1;
  #10;
  rst = 0;
  #10;
end
endmodule

