module tb_credit_receiver();

reg clk;
reg rst;
reg push_sender_in_reset;
reg push_receiver_in_reset;
reg push_credit_stall;
reg push_credit;
reg push_valid;
reg pop_credit;
reg pop_valid;
reg pop_data;
reg credit_initial;
reg credit_withhold;
reg credit_count;
reg credit_available;
reg push_data;

credit_receiver #(.rst(rst),
                 .push_sender_in_reset(push_sender_in_reset),
                 .push_receiver_in_reset(push_receiver_in_reset),
                 .push_credit_stall(push_credit_stall),
                 .push_credit(push_credit),
                 .push_valid(push_valid),
                 .pop_credit(pop_credit),
                 .pop_valid(pop_valid),
                 .pop_data(pop_data))
                 u0 (.clk(clk),
                     .rst(rst),
                     .push_sender_in_reset(push_sender_in_reset),
                     .push_receiver_in_reset(push_receiver_in_reset),
                     .push_credit_stall(push_credit_stall),
                     .push_credit(push_credit),
                     .push_valid(push_valid),
                     .pop_credit(pop_credit),
                     .pop_valid(pop_valid),
                     .pop_data(pop_data));

initial
begin
  credit_initial = 1;
  credit_withhold = 0;
  credit_count = credit_initial - credit_withhold;
  credit_available = credit_count;
  push_valid = 1;
  pop_valid = 1;
  push_credit = 0;
  pop_credit = 0;
  credit_available = credit_available;
  push_credit_stall = 0;
  push_sender_in_reset = 0;
  push_receiver_in_reset = 0;
  rst = 0;

  // Test the reset behavior
  #10 rst = 1;
  #1 push_receiver_in_reset = 1;
  #10 rst = 0;

  #10 push_sender_in_reset = 1;
  #1 push_receiver_in_reset = 0;
  #10 push_sender_in_reset = 0;

  // Test the credit management
  #10 pop_credit = 1;
  #1 credit_count = credit_count + 1;
  #10 credit_available = credit_available - 1;

  #10 push_credit = 1;
  #1 credit_count = credit_count - 1;
  #10 credit_available = credit_available + 1;

  #10 credit_withhold = 1;
  #1 credit_available = credit_available - 1;

  // Test the data and validity path
  #10 push_valid = 1;
  #1 pop_valid = 1;

  #10 pop_valid = 0;
  #1 push_valid = 0;

  // Test the credit generation
  #10 credit_available = 1;
  #1 push_credit = 1;

  #10 credit_available = 0;
  #1 push_credit = 0;
end
endmodule

