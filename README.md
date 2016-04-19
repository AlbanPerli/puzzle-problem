# Puzzle Problem

AI to solve a dynamic [15 puzzle](https://en.wikipedia.org/wiki/15_puzzle) using an assortment of AI techniques.

Performed under a course conducted at Swinburne University for [Artificial Intelligence](http://www.swinburne.edu.au/study/courses/units/Introduction-to-Artificial-Intelligence-COS30019/local)

## Getting started

Run using `search.sh`. This will automatically build the solver on your platform.

### Search file

A search file provided must be in the following format:

1. First line contains the height and width
2. Second line contains the desired start state
3. Third line contains the desired end state

Example:

```
3x3
6 7 4 1 5 3 8 0 2
3 4 2 1 8 7 6 0 5
```

### Search algorithms

So far, the following algorithms with their respective codes are implemented:

- Uninformed
  - [Breadth-First Search](https://en.wikipedia.org/wiki/Breadth-first_search), `BFS`
  - [Depth-First Search](https://en.wikipedia.org/wiki/Depth-first_search), `DFS`
  - [Depth-Limited Search](https://en.wikipedia.org/wiki/Iterative_deepening_depth-first_search), `DLS`
  - [Bogosort Search](https://en.wikipedia.org/wiki/Bogosort), `BOGO`
- Informed
  - [Greedy Best-First Search](https://en.wikipedia.org/wiki/Best-first_search), `GBFS`
  - [A* Search](https://en.wikipedia.org/wiki/A%2A_search_algorithm), `AS`
  - [Iterative-Deepening A* Search](https://en.wikipedia.org/wiki/Iterative_deepening_A%2A), `IDAS`

## Screenshot

![In Action](https://raw.githubusercontent.com/alexcu/puzzle-problem/master/doc/images/gui.png)

## Copyright

&copy; Alex Cummaudo 2016
