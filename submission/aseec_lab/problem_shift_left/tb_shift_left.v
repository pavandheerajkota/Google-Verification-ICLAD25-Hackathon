module tb_shift_left();
reg out_valid, clk;
wire clk;
reg [2:0] shift;
wire [2:0] shift;
reg [11:0] fill;
wire [11:0] fill;
reg [95:0] in;
wire [95:0] in;
wire [95:0] out;
reg [95:0] out;

shift_left #(.shift(3),
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

  // Test the shift_left module with valid shift amount
  #100;
  shift = 2;
  #100;

  // Test the shift_left module with invalid shift amount
  #100;
  shift = 6;
  #100;

  // Test the shift_left module with multiple shifts
  for(int i = 0; i < 16; i++)
  begin
    #100;
    shift = i;
    #100;
  end

  // Test the shift_left module with fill input
  for(int i = 0; i < 16; i++)
  begin
    #100;
    fill = i;
    #100;
  end

  // Test the shift_left module with multiple fills
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

endmodule

