r"""Script to evaluate testbenches quality.

Run for visible problems:
python test_harness/run_evaluation.py \
  --problems_folder="${PWD}/visible_problems" \
  --answers_folder="${PWD}/visible_problems_answers"

Run for hidden problems:
python test_harness/run_evaluation.py \
  --problems_folder="${PWD}/hidden_problems" \
  --answers_folder="${PWD}/hidden_problems_answers"
"""

from collections.abc import Sequence
import os
import pathlib
import subprocess
import tempfile
import math

from absl import app
from absl import flags

import constants


_PROBLEMS_FOLDER = flags.DEFINE_string(
  'problems_folder',
  None,
  'The path to the problems folder.',
  required=True,
)
_ANSWERS_FOLDER = flags.DEFINE_string(
    'answers_folder',
    None,
    'The path to the answers folder.',
    required=True,
)
_INCLUDE_PATHS = flags.DEFINE_list(
    'include_paths',
    None,
    'List of include paths to be used when compiling the testbench.',
)

def is_test_passing(
    tb_module_name: str,
    dependency_paths: list[str],
    include_folders: list[str] | None) -> bool:
  """Runs iverilog and returns whether the test passed."""
  with tempfile.TemporaryDirectory() as temp_dir:
    compiled_file = os.path.join(temp_dir, 'out')
    include_args = []
    if include_folders is not None:
        for include_folder in include_folders:
            include_args.append('-I')
            include_args.append(include_folder)
    iverilog_cmd = [
        'iverilog',
        '-g2012',
        '-o',
        compiled_file,
        '-s',
        tb_module_name,
    ] + dependency_paths + include_args
    subprocess.run(iverilog_cmd, check=True)
    vvp_cmd = [
        'vvp',
        compiled_file,
    ]
    vvp_out = subprocess.run(vvp_cmd, check=True, capture_output=True)
    if vvp_out.returncode != 0:
        raise RuntimeError(
            f'VVP failed with return code {vvp_out.returncode}. '
            'Check the output for details.')
    stdout = vvp_out.stdout.decode()
    # Check if the test passed by looking for the pass string in stdout.
    if constants.TEST_PASS_STRING in stdout:
        return True
    return False


def main(argv: Sequence[str]) -> None:
    if len(argv) > 1:
        raise app.UsageError('Too many command-line arguments.')
    problems_folder = pathlib.Path(_PROBLEMS_FOLDER.value)
    answers_folder = pathlib.Path(_ANSWERS_FOLDER.value)
    if not problems_folder.is_dir():
        raise ValueError(f'Problems folder {problems_folder} does not exist or is not a directory.')
    if not answers_folder.is_dir():
        raise ValueError(f'Answers folder {answers_folder} does not exist or is not a directory.')

    # List all module names (subdirectories) in problems_folder
    module_names = [f.name for f in problems_folder.iterdir() if f.is_dir()]
    # Ensure answers_folder contains all the same subdirectories
    answer_subdirs = {f.name for f in answers_folder.iterdir() if f.is_dir()}
    missing = set(module_names) - answer_subdirs
    if missing:
        raise ValueError(f'Answers folder missing subdirectories: {missing}')

    module_to_precision = {}
    for module in module_names:
        print(f'\nEvaluating module: {module}')
        problem_dir = problems_folder / module
        answer_path = answers_folder / module / constants.ANSWER_FILE_NAME
        if not answer_path.exists():
            print(f'No answer file found for module {module}, skipping.')
            continue
        answer_mutant_id = int(answer_path.read_text())
        
        # Find all mutant_i.v files and tb.v in the problem_dir
        mutant_files = sorted(problem_dir.glob('mutant_*.v'))
        tb_file = problem_dir / constants.TESTBENCH_FILE_NAME
        if not tb_file.exists():
            print(f'No tb.v found in {problem_dir}, assigning 0 score.')
            module_to_precision[module] = 0
            continue

        guesses = []
        for i, mutant_file in enumerate(mutant_files):
            dependencies = [str(tb_file), str(mutant_file)]
            passed = is_test_passing(constants.TESTBENCH_MODULE_NAME, dependencies, _INCLUDE_PATHS.value)
            guesses.append(1 if passed else 0)
        
        num_positive_guesses = sum(guesses)
        print(f'Number of positive guesses: {num_positive_guesses}')
        found_correct = guesses[answer_mutant_id] == 1
        if found_correct:
            precision = 1 / num_positive_guesses
        else:
            precision = 0
        module_to_precision[module] = precision
        print(f'Precision for module {module}: {precision:.2f}')
    print('\nFinal precisions:')
    for module, precision in module_to_precision.items():
        print(f'{module}: {precision:.2f}')

if __name__ == '__main__':
    app.run(main)