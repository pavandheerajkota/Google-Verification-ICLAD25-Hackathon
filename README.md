# GenAI for Design Verification (Google)

## Goal

In this design verification challenge your goal is to build an agent that writes correct simulation testbenches based on the natural language specification.

The information available to the agent:
- Natural language specification of a Verilog module
- 31 implementations of the module where only one is correct

## Instructions

You need to implement `solution.py` script in `test_harness` folder and supply it with instructions on how to run it. It should accept a single flag `--problems_folder` and run for all modules inside this folder. See an example in `test_harness/dummy_solution.py`.

The generated testbenches need to be contained within a single `tb.v` file and reside in the same folder as the module mutants. Testbench's module name is assumed to be `tb`. You are allowed to supply include directories that are required to run the testbench.

Minimum testbench requirements:
- Output `$display("TESTS PASSED")` if the mutant passes the testbench
- Call `$finish` in the end

All testbenches will be simulated using `iverilog` so the subset of the language they use need to be supported by it. You can see all details in `test_harness/run_evaluation.py` script.

## Evaluation criteria

We use precision to evaluate agent's performance per module: it is 0 if the original module did not pass the generated test and it is 1/(Number of passing modules) otherwise.