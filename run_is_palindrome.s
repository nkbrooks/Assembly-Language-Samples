#!/bin/tcsh -f


cat is_palindrome_driver.s is_palindrome.s > is_palindrome_prog.s
spim -file is_palindrome_prog.s | tail -n +2
rm -f is_palindrome_prog.s
# "tail -n+2" strips the first line of spim's output, which is irrelevant
