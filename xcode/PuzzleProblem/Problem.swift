//
//  Problem.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct Problem {
    var initialState: State {
        return State(matrix: [[]])
    }
    var initialNode: Node {
        let rootNodeState = State(matrix: [
            [1,2,4],
            [3,0,5],
            [6,7,8]
        ])
        return Node(initialState: rootNodeState)
    }
}
