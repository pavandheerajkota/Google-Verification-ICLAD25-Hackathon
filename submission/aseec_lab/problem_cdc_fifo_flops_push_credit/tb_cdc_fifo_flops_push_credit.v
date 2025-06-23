module tb_cdc_fifo();

reg [4:0] credit_initial_push;
reg [4:0] credit_withhold_push;
reg [4:0] credit_count_push;
reg [4:0] credit_available_push;

reg [7:0] push_data;
reg [4:0] push_credit;
reg push_credit_stall;
reg push_full;
reg push_receiver_in_reset;
reg push_rst;
reg push_sender_in_reset;
reg push_valid;
reg [4:0] push_slots;

reg [4:0] pop_items;
reg pop_empty;
reg pop_ready;
reg pop_rst;
reg pop_valid;
reg [7:0] pop_data;
reg pop_clk;
wire pop_clk;

cdc_fifo_flops_push_credit #(.push_clk(push_clk),
              .pop_clk(pop_clk),
              .push_rst(push_rst),
              .pop_rst(pop_rst),
              .push_sender_in_reset(push_sender_in_reset),
              .push_receiver_in_reset(push_receiver_in_reset),
              .push_credit_stall(push_credit_stall),
              .credit_initial_push(credit_initial_push),
              .credit_withhold_push(credit_withhold_push),
              .credit_count_push(credit_count_push),
              .credit_available_push(credit_available_push))
              u0 (.push_clk(push_clk),
                  .pop_clk(pop_clk),
                  .push_rst(push_rst),
                  .pop_rst(pop_rst),
                  .push_sender_in_reset(push_sender_in_reset),
                  .push_receiver_in_reset(push_receiver_in_reset),
                  .push_credit_stall(push_credit_stall),
                  .credit_initial_push(credit_initial_push),
                  .credit_withhold_push(credit_withhold_push),
                  .credit_count_push(credit_count_push),
                  .credit_available_push(credit_available_push));

initial
begin
  credit_initial_push = 16;
  credit_withhold_push = 4;
  credit_count_push = credit_initial_push - credit_withhold_push;
  pop_items = 0;
  pop_empty = 1;
  push_rst = 0;
  push_sender_in_reset = 0;
  push_receiver_in_reset = 0;
  pop_clk = 0;

  // Initialize the FIFO with some items
  for(int i = 0; i < 10; i++)
  begin
    push_valid = 1;
    for(int j = 0; j < 8; j++)
      push_data[j] = i + j;
    #1 push_valid = 0;
    #1 pop_valid = 1;
  end

  // Test the FIFO
  #5 $monitor ($time, "Credit Available: %0b", credit_available_push);
  #5 $monitor ($time, "Push Full: %0b", push_full);
  #5 $monitor ($time, "Push Slots: %0b", push_slots);
  #5 $monitor ($time, "Pop Empty: %0b", pop_empty);
  #5 $monitor ($time, "Pop Items: %0b", pop_items);

  // Test the credit handling
  #10 push_credit = 1;
  #1 credit_available_push = credit_available_push - 1;
  #20 credit_available_push = credit_available_push + 1;

  // Test the reset handling
  #10 push_rst = 1;
  #1 push_receiver_in_reset = 1;
  #10 push_receiver_in_reset = 0;

  // Test the read interface
  #10 pop_clk = 1;
  #1 pop_valid = 1;
  #10 pop_valid = 0;
end
endmodule

