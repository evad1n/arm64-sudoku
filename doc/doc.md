Putting it all together
=======================

In this final step you will put everything together into a usable
Sudoku solver.

Start by copying your solver code over from the previous project.
The only code you will be writing for this step will be in
`start.s`, and it should do the following:

*   Print a prompt asking the user to type in a Sudoku puzzle
*   Read the board from standard in
*   Parse the board (using `read_board`) and verify that it was well
    formed
*   Solve the puzzle (using `solve`) and verify that it succeeded
*   Print the solved puzzle (using `print_board`)

At each step, errors are handled by printing a specific message to
standard out and exiting. Here is an example session:

```
$ ./a.out
Please type in a Sudoku puzzle to solve:
> ..9.5.3.1.2..63......7....4.8.1...5......5.....7.3....7......1.8.........53...29.
+-------+-------+-------+
| 4 7 9 | 2 5 8 | 3 6 1 |
| 1 2 5 | 4 6 3 | 7 8 9 |
| 3 6 8 | 7 1 9 | 5 2 4 |
+-------+-------+-------+
| 2 8 6 | 1 7 4 | 9 5 3 |
| 9 3 4 | 6 8 5 | 1 7 2 |
| 5 1 7 | 9 3 2 | 6 4 8 |
+-------+-------+-------+
| 7 4 2 | 3 9 6 | 8 1 5 |
| 8 9 1 | 5 2 7 | 4 3 6 |
| 6 5 3 | 8 4 1 | 2 9 7 |
+-------+-------+-------+
```

Note that your output must exactly match the example. For error
messages, you can see the expected output by running the tests and
copying the text from the failed test.

All of this can be written directly in `_start`, or you can write
helper functions as needed. All of your code should be in `start.s`.

To read a line of input, you should do the following:

*   Reserve some space in the `.bss` section using a `.space`
    directive. For example:

        input:  .space 128

*   Perform a read system call, reserving one of the bytes so you
    can add a zero at the end of the input string. In this example,
    you would tell read that your buffer is 127 bytes long.

*   After reading the read system call there are 3 cases:

    1.  The system call returns an error. Handle this by exiting
        with a non-zero exit status code.

    2.  The read call was successful, at least one byte was read,
        and the last byte that was read was a newline. In this case,
        overwrite the trailing newline with a zero so the string
        ends without a newline.

    3.  The read call was successful, but zero bytes were read or
        the last byte was a not a newline. Add a zero byte to the
        end of the input in this case.

Recall that your `read_board` function validates the input,
returning different values for a board that is too short, too long,
contains invalid characters, or is correct. Print the appropriate
message for each of the error cases (and exit with status code
zero), and for a valid board proceed to call solve on the result.
