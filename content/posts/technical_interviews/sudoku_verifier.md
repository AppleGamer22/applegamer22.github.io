---
title: Sudoku Verifier
date: 2022-10-28
description: My attempt at writing a verification function for a sudoku matrix
tags: [Sudoku, Go]
---
# Prompt
Determine if a $9 \times 9$ Sudoku board is valid. All of the cells need to be validated **according to the following rules**:

1. Each row must contain each of the digits 1 to 9 exactly once.
1. Each column must contain each of the digits 1 to 9 exactly once.
1. Each of the **nine** $3 \times 3$ sub-boxes of the grid must contain each of the digits 1 to 9 exactly once.

# Example Input
For example, the following matrix[^1] $M$ is a valid Sudoku solution:

$$
M = \left[\begin{array}{ccc|ccc|ccc}
	5 & 3 & 4 & 6 & 7 & 8 & 9 & 1 & 2 \\
	6 & 7 & 2 & 1 & 9 & 5 & 3 & 4 & 8 \\
	1 & 9 & 8 & 3 & 4 & 2 & 5 & 6 & 7 \\
	\hline
	8 & 5 & 9 & 7 & 6 & 1 & 4 & 2 & 3 \\
	4 & 2 & 6 & 8 & 5 & 3 & 7 & 9 & 1 \\
	7 & 1 & 3 & 9 & 2 & 4 & 8 & 5 & 6 \\
	\hline
	9 & 6 & 1 & 5 & 3 & 7 & 2 & 8 & 4 \\
	2 & 8 & 7 & 4 & 1 & 9 & 6 & 3 & 5 \\
	3 & 4 & 5 & 2 & 8 & 6 & 1 & 7 & 9
\end{array}\right]
$$

# Solution
During the interview, I thought I understood the rules of Sudoku, but in actuality I didn't understand the fact that there are only **9** sub-boxes defined in Sudoku, so I implemented the check for ~~every possible~~ $3 \times 3$ sub-matrix. The following implementation is an improvement since it actually takes into account the rules of the game.

## Rows & Columns
For every $0 \leq i < 9$, a row and column count arrays are maintained, such that the row array counts the number of times each digit appears in $(i, j)$, and the column array counts the number of times each digit appears in $(j, i)$, where $0 \leq j < 9$. After each time the count arrays was updated for $j = 8$, they are iterated through to check for any counts that are not strictly 1.

## Sub-boxes
For every $0 \leq i < 9$ (such that $i \equiv 1\ (\bmod\ 3)$), and every $0 \leq j < 9$ (such that $j \equiv 1\ (\bmod\ 3)$), the matrix coordinate $(i, j)$ is the upper-left corner of a given $3 \times 3$ Sudoku sub-box. A count array is maintained for every sub-box $(i, j)$ with coordinate $(y, x)$, such that $j \leq y < j + 3$, and such that $i \leq x < i + 3$. After all values of the coordinates in the $3 \times 3$ sub-box with upper-left corner $(i, j)$ have been recorded in the count array, it's iterated through to check for any counts that are not strictly 1.

## Go Implementation
```go
func CheckSudoku(matrix [9][9]int) bool {
	// check row and column conditions
	for i := 0; i < 9; i++ {
		var row_count, column_count [9]int
		for j := 0; j < 9; j++ {
			// row-wise/column-wise matrix coordinates (i, j) and (j, i)
			row_count[matrix[i][j]-1]++
			column_count[matrix[j][i]-1]++
		}

		for digit := 0; digit < 9; digit++ {
			row_condition := row_count[digit] == 0 || row_count[digit] > 1
			column_condition := column_count[digit] == 0 || column_count[digit] > 1
			if row_condition || column_condition {
				return false
			}
		}
	}

	// check sub-box conditions
	for i := 0; i < 9; i += 3 {
		for j := 0; j < 9; j += 3 {
			// (i, j) represents the upper-left corner of each Sudoku sub-box
			var box_count [9]int
			for y := j; y < j+3; y++ {
				for x := i; x < i+3; x++ {
					// 3x3 Sudoku sub-matrix-wise coordinates (y, x)
					box_count[matrix[y][x]-1]++
				}
			}

			for _, count := range box_count {
				if count == 0 || count > 1 {
					return false
				}
			}
		}
	}

	return true
}
```

You can run the above-mentioned code from your browser with the following [Go Playground](https://go.dev/play/p/hrJrmfPApxY).

[^1]: `Cburnett`. (2017, April 8). Sudoku Puzzle by L2G-20050714 solution standardized layout. Wikimedia. <https://commons.wikimedia.org/wiki/File:Sudoku_Puzzle_by_L2G-20050714_solution_standardized_layout.svg>
