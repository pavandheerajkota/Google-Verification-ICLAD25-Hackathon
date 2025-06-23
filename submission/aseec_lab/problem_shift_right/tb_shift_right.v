module tb_shift_right();
reg out_valid, clk;
wire clk;
reg [2:0] shift;
wire [2:0] shift;
reg [4:0] fill;
wire [4:0] fill;
reg [49:0] in;
wire [49:0] in;
wire [49:0] out;
reg [49:0] out;

shift_right #(.shift(2),
        .fill(fill),
        .in(in),
        .out(out),
        .out_valid(out_valid)
       )u0 (.clk(clk),
             .shift(shift),
             .fill(fill),
             .in(in),
             .out(out),
             .out_valid(out_valid)
             );

initial
begin
  clk = 0;
  #10;

  // Test the shift_right module with valid shift amount
  #100;
  shift = 2;
  #100;

  // Test the shift_right module with invalid shift amount
  #100;
  shift = 6;
  #100;

  // Test the shift_right module with multiple shifts
  for(int i = 0; i < 16; i++)
  begin
    #100;
    shift = i;
    #100;
  end

  // Test the shift_right module with fill input
  for(int i = 0; i < 16; i++)
  begin
    #100;
    fill = i;
    #100;
  end

  // Test the shift_right module with multiple fills
  for(int i = 0; i < 16; i++)
  begin
    #100;
    fill = i;
    for(int j = 0; j < 16; j++)
    begin
      #100;
      shift = j;
      #100;
    end
  end

  // Test the shift_right module with edge cases
  for(int i = 5; i < 16; i++)
  begin
    #100;
    shift = i;
    #100;
  end

endmodule

