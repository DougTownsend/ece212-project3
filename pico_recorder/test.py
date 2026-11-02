"""Runs every testbench in the test directory and compares the results to the
solution outputs.

Unlike the autograder, which tests adc with the solution's adc_ctrl and adc_dp,
and recorder with the solution's memory, this script uses your modules for
everything. So a bug in one module can make the tests for another module fail.

Run this from the pico_recorder or fpga_recorder directory:
    python3 test.py            (Mac and Linux)
    python test.py             (Windows)

To run only the tests for one module, give its name:
    python3 test.py recorder
"""
import os
import subprocess
import sys

# Test name and points, in the same order as the autograder.
TESTS = [
    ("test_1_0_led_bar", 2), ("test_1_1_led_bar", 2), ("test_1_2_led_bar", 2),
    ("test_2_0_tick", 3), ("test_2_1_tick", 3),
    ("test_3_0_adc_dp", 2), ("test_3_1_adc_dp", 2), ("test_3_2_adc_dp", 2),
    ("test_4_0_adc_ctrl", 3), ("test_4_1_adc_ctrl", 3), ("test_4_2_adc_ctrl", 3),
    ("test_4_3_adc_ctrl", 3),
    ("test_5_0_adc", 3), ("test_5_1_adc", 3),
    ("test_6_0_memory", 2), ("test_6_1_memory", 2), ("test_6_2_memory", 2),
    ("test_7_0_recorder", 3), ("test_7_1_recorder", 3), ("test_7_2_recorder", 2),
    ("test_7_3_recorder", 2), ("test_7_4_recorder", 2),
    ("test_8_0_main", 4), ("test_8_1_main", 4), ("test_8_2_main", 4), ("test_8_3_main", 4),
]

# The modules that must be correct for each module's tests to pass.
DEPENDS = {
    "led_bar": ["led_bar"],
    "tick": ["tick"],
    "adc_dp": ["adc_dp"],
    "adc_ctrl": ["adc_ctrl"],
    "adc": ["adc", "adc_ctrl", "adc_dp"],
    "memory": ["memory"],
    "recorder": ["recorder", "memory"],
    "main": ["main", "led_bar", "tick", "adc", "adc_ctrl", "adc_dp", "recorder", "memory",
             "sevseg_disp"],
}


def module_of(name):
    return name.split("_", 3)[3]


def describe(header, line):
    if line is None:
        return "(no more lines)"
    return ", ".join("{}={}".format(h, v) for h, v in zip(header.split(","), line.split(",")))


def run_test(name):
    """Returns (passed, message)."""
    result_file = os.path.join("test", "results", name + ".txt")
    if os.path.exists(result_file):
        os.remove(result_file)

    try:
        res = subprocess.run(["apio", "sim", "-n", "test/" + name + "_tb.v"],
                             capture_output=True, text=True, timeout=60)
    except subprocess.TimeoutExpired:
        return False, ("The simulation did not finish within 60 seconds. This usually\n"
                       "means your design has a combinational loop.")

    if not os.path.exists(result_file):
        return False, ("The simulation did not run. Check your code for errors.\n"
                       "Apio output:\n" + res.stdout + res.stderr)

    with open(result_file) as f:
        yours = f.read().splitlines()
    with open(os.path.join("test", "results", name + "_soln.txt")) as f:
        correct = f.read().splitlines()

    if yours == correct:
        return True, ""

    header = correct[0]
    for k in range(1, max(len(yours), len(correct))):
        y = yours[k] if k < len(yours) else None
        c = correct[k] if k < len(correct) else None
        if y != c:
            return False, ("First difference is on line {} of {}:\n"
                           "  Expected:    {}\n"
                           "  Your design: {}".format(k + 1, result_file,
                                                      describe(header, c), describe(header, y)))
    return False, "The header line of {} does not match.".format(result_file)


def main():
    if not os.path.isdir("test"):
        print("Run this script from the pico_recorder or fpga_recorder directory.")
        return

    tests = TESTS
    if len(sys.argv) > 1:
        tests = [(n, p) for n, p in TESTS if module_of(n) == sys.argv[1]]
        if not tests:
            print("No tests for a module named '{}'.".format(sys.argv[1]))
            return

    print("Errors in one module can cause failures in the tests for other modules.")
    print("Each test lists the modules that must be correct for it to pass.")
    print()

    # apio skips simulations it thinks are up to date, which would leave
    # no result file to compare. Cleaning first makes every test run.
    subprocess.run(["apio", "clean"], capture_output=True)

    score = 0
    total = 0
    for name, points in tests:
        passed, msg = run_test(name)
        total += points
        needs = "needs: " + ", ".join(DEPENDS[module_of(name)])
        if passed:
            score += points
            print("PASS  {:<24} {}/{}  {}".format(name, points, points, needs))
        else:
            print("FAIL  {:<24} 0/{}  {}".format(name, points, needs))
            print("      " + msg.replace("\n", "\n      "))
    print()
    print("Score: {}/{}".format(score, total))
    print()
    print("If a test fails, make sure every module it needs passes its own tests first.")
    print("A syntax error in any .v file in this directory makes every test fail.")
    print("The autograder tests adc with the solution's adc_ctrl and adc_dp, and recorder")
    print("with the solution's memory, so those tests only depend on adc.v and recorder.v")
    print("there.")


if __name__ == "__main__":
    main()
