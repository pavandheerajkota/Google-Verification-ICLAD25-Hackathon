                                                                                                                                                                                                         // Testbench file
module tb_counter;

  reg clk;               // Declare an internal TB variable called clk to drive clock to the design
  reg rst;               // Declare an internal TB variable called rst to drive active-high reset to design
  reg reinit;            // Declare an internal TB variable called reinit to drive active-high reset to design
  reg incr_valid;        // Declare an internal TB variable called incr_valid to drive increment valid to design
  reg decr_valid;        // Declare an internal TB variable called decr_valid to drive decrement valid to design
  reg [3:0] initial_value; // Declare a wire to connect to design initial value input
  reg [1:0] incr;        // Declare a wire to connect to design increment input
  reg [1:0] decr;        // Declare a wire to connect to design decrement input

  wire [3:0] value;       // Declare a wire to connect to design output
  wire [3:0] value_next;  // Declare a wire to connect to design value_next output

  // Instantiate DuT hardware
  counter c0 (
    .clk(clk),
    .rst(rst),
    .reinit(reinit),
    .initial_value(initial_value),
    .incr_valid(incr_valid),
    .decr_valid(decr_valid),
    .incr(incr),
    .decr(decr),
    .value(value),
    .value_next(value_next)
  );

  // Generate a clock that should be driven to design
  // This clock will flip its value every 5ns -> time period = 10ns -> freq = 100 MHz
  always #5 clk = ~clk;

  // This initial block forms the stimulus of the testbench
  initial begin
    // 1. Initialize testbench variables to 0 at start of simulation
    clk <= 0;
    rst <= 0;
    reinit <= 0;
    initial_value <= 4; // Set initial value to 4
    incr_valid <= 0;
    decr_valid <= 0;
    incr <= 2; // Set increment to 2
    decr <= 0; // Set decrement to 0

    // 2. Drive rest of the stimulus, reset is asserted in between
    #20 rst <= 1;
    #80 rst <= 0;
    #50 rst <= 1;

    // 3. Finish the stimulus after 200ns
    #20 $finish;
  end

  // Generate some stimulus
  initial begin
    // 1. Drive incr_valid and decr_valid to 1
    #50 incr_valid <= 1;
    #50 decr_valid <= 1;

    // 2. Drive incr and decr to 3
    #50 incr <= 3;
    #50 decr <= 3;

    // 3. Drive incr and decr to 0
    #50 incr <= 0;
    #50 decr <= 0;
  end

endmodule
