module tb_lfsr();
reg clk, rst;
reg advance, reinit;
reg [4:0] initial_state, out_state, taps;
wire advance, reinit;

lfsr #(.clk(clk),
        .rst(rst),
        .reinit(reinit),
        .initial_state(initial_state),
        .taps(taps),
        .out(out),
        .out_state(out_state)
       )u0 (.clk(clk),
             .rst(rst),
             .reinit(reinit),
             .initial_state(initial_state),
             .taps(taps),
             .out(out),
             .out_state(out_state)
             );

initial
begin
  clk = 0;
  rst = 0;
  advance = 0;
  reinit = 0;
  initial_state = 15;
  out = 1;
  taps = 0;
  #10;
  rst = 1;
  #10;
  rst = 0;
  #10;
  initial_state = 15;
  #10;
  reinit = 1;
  #10;
  reinit = 0;
  #10;

  // Test the LFSR with a series of state transitions
  for(int i = 0; i < 16; i++)
  begin
    #10;
    advance = 1;
    #10;
    advance = 0;
    #10;
  end

  // Test the LFSR with a series of reinitializations
  for(int i = 0; i < 16; i++)
  begin
    #10;
    reinit = 1;
    #10;
    reinit = 0;
    #10;
  end

  // Test the LFSR with a mix of state transitions and reinitializations
  for(int i = 0; i < 16; i++)
  begin
    #10;
    reinit = 1;
    advance = 1;
    #10;
    reinit = 0;
    advance = 0;
    #10;
  end

  // Test the LFSR with the taps input
  for(int i = 0; i < 16; i++)
  begin
    #10;
    taps = i;
    #10;
  end

  // Test the LFSR with a long sequence of state transitions
  for(int i = 0; i < 100; i++)
  begin
    #10;
    advance = 1;
    #10;
  end

end
endmodule

