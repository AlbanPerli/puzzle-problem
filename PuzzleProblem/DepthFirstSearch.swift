//
//  SearchVisitor.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

/*
struct DepthFirstSearch: SearchMethod, Traversable {
    ///
    /// The cutoff to stop the breadth first search. By default this is `100`
    ///
    var cutoff: Int = 100

    // MARK: Implement SearchMethod
    var name: String = "Depth First Search"
    var code: String = "DFS"

    // MARK: Impelement Traversable
    var goalState: State
    init(goalState: State) {
        self.goalState = goalState
    }

    func traverse(node: Node) -> [Action]? {
        let node = node
        // No actions needed!
        if self.isGoalState(node) {
            return []
        }
        // Cannot traverse through the empty tree
        if node.isEmpty {
            return nil
        }
        // Traverse through each child
        for childNode: Node in node.children {
            //childNode.traverse(self)
        }
    }
}
*/