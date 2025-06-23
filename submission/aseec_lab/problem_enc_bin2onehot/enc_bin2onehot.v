// File : tb_top.v
module tb_top();

reg clk;
reg rst;
reg [3:0] in;
reg [14:0] out;
reg in_valid;

enc_bin2onehot inst (
  .clk(clk),
  .rst(rst),
  .in(in),
  .in_valid(in_valid),
  .out(out)
);

initial
begin
  // Initialize the clock and reset
  clk = 0;
  rst = 1;
  #5 rst = 0;
  #100 rst = 1;

  // Drive some random inputs
  forever
  begin
    for(i = 0; i < 16; i++)
      in[i] <= !in[i];
    #10;
  end

  // Check if the output is correct
  initial
  begin
    for(i = 0; i < 16; i++)
    begin
      in = i;
      #1
      in_valid <= 1'b1;
      if($bitstream(out) != $bitstream(in))
        $display("%t FAIL: Output not correct for input value ", in);
      else
        $display("%t PASS: Output correct for input value ", in);
    end
  end

endmodule
