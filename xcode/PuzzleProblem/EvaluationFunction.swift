//
//  EvaluationFunction.swift
//  PuzzleProblem
//
//  Created by Alex on 29/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// An evaluation function is a data type that stores the method in which to calculate
/// the distance of a state to its goal state
///
protocol EvaluationFunction {
    ///
    /// The heuristic function used to estimate the cost to get the state to the goal
    ///
    var heuristicFunction: HeuristicFunction { get set }
    
    ///
    /// Initialiser to create an EvaluationFunction
    /// - Paramater heuristicFunction: The heurstic function used to in calculations
    ///
    init(heuristicFunction: HeuristicFunction)
    
    ///
    /// Calculates the distance of a state to its goal state
    /// - Parameter state: The state to calculate distance
    ///
    func calculateDistanceToGoal(state: State) -> Int
}
