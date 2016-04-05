//
//  SearchVisitor.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// Depth First Search is an *uninformed* search method that traverses nodes in a LIFO
/// fashion, that is, it expands the deepest unexpanded node and keeps expanding descendents
/// of that node until a leaf node is encountered
/// - Complexity:
///     - **Time:**  O(b<sup>m</sup>)
///     - **Space:** O(bm)
///
struct DepthFirstSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Depth First Search"
    static var code: String = "DFS"
    var goalState: State
    var frontier: Frontier
    
    ///
    /// Initaliser for a Depth First Search
    /// - Parameter goalState: The search's goal state
    ///
    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a LIFO frontier
        self.frontier = LifoFrontier()
    }

}