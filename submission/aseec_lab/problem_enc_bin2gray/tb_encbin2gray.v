module tb_gray_converter();

reg bin;
reg gray;

enc_bin2gray #(.bin(bin),
                 .gray(gray))
                 u0 (.bin(bin),
                     .gray(gray));

initial
begin
  bin = 0;
  gray = 0;

  // Test the module with some random values
  for(int i = 0; i < 10; i++)
  begin
    bin = $random;
    #10;
  end

  // Test the module with all zeros
  #10 bin = 0;
  #10;

  // Test the module with all ones
  #10 bin = 12'dfffffffffff;
  #10;

  // Test the module with a binary stream
  for(int i = 0; i < 10; i++)
  begin
    #10 bin = i;
    #10;
  end
end
endmodule

