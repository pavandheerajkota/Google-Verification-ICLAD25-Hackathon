r"""Script creates dummy testbenches for each problem in the specified folder.

Run for visible problems:
python test_harness/dummy_solution.py \
  --problems_folder="${PWD}/visible_problems"

Run for hidden problems:
python test_harness/dummy_solution.py \
  --problems_folder="${PWD}/hidden_problems"
"""

from collections.abc import Sequence
import pathlib

from absl import app
from absl import flags

import constants


_PROBLEMS_FOLDER = flags.DEFINE_string(
  'problems_folder',
  None,
  'The path to the problems folder.',
  required=True,
)


_DUMMY_TESTBENCH = """\
module tb;

    initial begin
        $display("TESTS PASSED");
        $finish;
    end

endmodule
"""


def main(argv: Sequence[str]) -> None:
    if len(argv) > 1:
        raise app.UsageError('Too many command-line arguments.')
    problems_folder = pathlib.Path(_PROBLEMS_FOLDER.value)
    if not problems_folder.is_dir():
        raise ValueError(f'Problems folder {problems_folder} does not exist or is not a directory.')

    module_names = [f.name for f in problems_folder.iterdir() if f.is_dir()]
    for module in module_names:
        problem_dir = problems_folder / module
        testbench_file = problem_dir / constants.TESTBENCH_FILE_NAME
        testbench_file.write_text(_DUMMY_TESTBENCH)

if __name__ == '__main__':
    app.run(main)