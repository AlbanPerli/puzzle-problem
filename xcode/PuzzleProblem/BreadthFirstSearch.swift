//
//  BreathFirstSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Breadth First Search is an *uninformed* search method that traverses nodes in a FIFO
/// fashion, that is, it expands the shallowest unexpanded node and keeps expanding 
/// siblings of that node until the last sibling in the current depth is found
/// - Complexity:
///     - **Time:**  O(b<sup>d</sup>)
///     - **Space:** O(b<sup>d</sup>)
///
struct BreadthFirstSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Breadth First Search"
    static var code: String = "BFS"
    var goalState: State
    var frontier: Frontier

    ///
    /// Initaliser for a Breadth First Search
    /// - Parameter goalState: The search's goal state
    ///
    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a FIFO frontier
        self.frontier = FifoFrontier()
    }
}