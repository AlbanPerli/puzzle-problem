//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           26/03/2016
//

///
/// An evaluated frontier is a `FifoFrontier` that pushes elements into
/// the correct order based on the evaluation function result when applied
/// to a given state
///
struct EvaluatedFrontier: Frontier {
    var collection: [Node] = []
    
    ///
    /// The evaluation function applied to node's states when pushing to evaluate
    /// that node's estimated path cost to the goal state
    ///
    private let evaluationFunction: EvaluationFunction
    
    ///
    /// Initalises a `HeuristicFrontier` with the specified `HeuristicFunction`
    /// - Parameter evaluationFunction: The evaluation function used to apply to the nodes in
    ///                                 this frontier to determine their estimated path cost
    ///
    init(evaluationFunction: EvaluationFunction) {
        self.evaluationFunction = evaluationFunction
    }
    
    ///
    /// Tries to get the distance to goal from the current node using the node's
    /// `distanceToGoal` property if it has been calculated; otherwise it calculates
    /// the `distanceToGoal` property using the `evaluationFunction` instead
    /// - Paramater node: The node to calculate for
    /// - Returns: The estimated path cost 
    ///
    func distanceToGoal(node: Node) -> Float {
        return node.distanceToGoal ?? self.evaluationFunction.evaluate(node)
    }
    
    mutating func pop() -> Node? {
        // Dequeue element at start of array
        return self.isEmpty ? nil : self.collection.removeFirst()
    }
    
    mutating func push(node: Node) {
        // Evaluate the distance of the state
        let distanceToGoal = self.distanceToGoal(node)
        // Find the index to insert at by finding that whose distance to goal result
        // is equal to or larger than the distanceToGoal calculated for this
        // particular state. If not found, then it's added to the end.
        // E.g.:
        //
        //   Insert 7 where f(n) for all nodes in collection are [ 3, 5, 8 ]
        //
        // In this example, indexToInsert will return:
        //
        //   3 >= 7 -> no
        //   5 >= 7 -> no
        //   8 >= 7 -> yes therefore index 2
        //
        // So insert at index 2, which will result in [ 3, 5, 7, 8 ]
        let indexToInsert = (self.collection.indexOf { node -> Bool in
            self.distanceToGoal(node) >= distanceToGoal
        } ?? self.collection.count) 
        self.collection.insert(node, atIndex: indexToInsert)
    }
}
