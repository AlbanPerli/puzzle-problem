//
//  BogosortSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 1/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

struct BogosortSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Bogosort Search"
    static var code: String = "BOGO"
    var goalState: State
    var frontier: Frontier
    
    ///
    /// Initaliser for a Bogosort Search
    /// - Parameter goalState: The search's goal state
    ///
    init(goalState: State) {
        self.goalState = goalState
        // Breadth First Search uses a randomised frontier
        self.frontier = RandomisedFrontier()
    }
}
