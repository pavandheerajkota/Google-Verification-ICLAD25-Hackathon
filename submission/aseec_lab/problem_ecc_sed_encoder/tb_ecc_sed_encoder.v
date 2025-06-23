module tb_ecc_sed_encoder();

reg clk;
reg rst;
reg data_valid;
reg enc_valid;
reg data;
reg enc_codeword;
reg parity;

ecc_sed_encoder #(.rst(rst),
                 .data_valid(data_valid),
                 .enc_valid(enc_valid),
                 .enc_codeword(enc_codeword))
                 u0 (.clk(clk),
                     .rst(rst),
                     .data_valid(data_valid),
                     .enc_valid(enc_valid),
                     .enc_codeword(enc_codeword));

initial
begin
  data_valid = 0;
  enc_valid = 0;
  enc_codeword = 0;
  data = 0;

  // Test the module with valid data
  #10 data = 12'd123456789abcdef;
  #1 data_valid = 1;
  #10 data_valid = 0;

  // Test the module with invalid data (no data)
  #10 data = 0;
  #1 data_valid = 1;
  #10 data_valid = 0;

  // Test the module with a data stream
  for(int i = 0; i < 10; i++)
  begin
    #10 data = 12'd123456789abcdef;
    #1 data_valid = 1;
    #10 data_valid = 0;
  end

  // Test the module with all zeros
  #10 data = 0;
  #1 data_valid = 1;
  #10 data_valid = 0;

  // Test the module with all ones
  #10 data = 12'dffffffffffff;
  #1 data_valid = 1;
  #10 data_valid = 0;
end
endmodule

