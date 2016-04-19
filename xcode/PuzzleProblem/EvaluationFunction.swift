//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           29/03/2016
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
    /// - Parameter node: The node's state to calculate distance
    ///
    func evaluate(node: Node) -> Int
}
