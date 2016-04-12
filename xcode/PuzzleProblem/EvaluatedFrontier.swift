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
    /// A cache of evaluation function results so as to not recalculate them for the
    /// same state
    ///
    private var evaluationFunctionCache: Dictionary<Int, Int> = [:]
    
    ///
    /// Initalises a `HeuristicFrontier` with the specified `HeuristicFunction`
    /// - Parameter evaluationFunction: The evaluation function used to apply to the nodes in
    ///                                 this frontier to determine their estimated path cost
    ///
    init(evaluationFunction: EvaluationFunction) {
        self.evaluationFunction = evaluationFunction
    }
    
    ///
    /// Returns the result when apply the evaluation function for the provided node's state
    /// - Remarks: Looks up the evaluation function from a stored cache, and
    ///            calculates and then caches's the result of the evaluation
    ///            function instead if it cannot be found in cache
    /// - Paramater node: The node to calculate for
    /// - Returns: The estimated path cost 
    ///
    func distanceToGoal(node: Node) -> Int {
        return self.evaluationFunction.calculateDistanceToGoal(node)
//        let hash = node.hashValue
//        if let result = evaluationFunctionCache[hash] {
//            return result
//        } else {
//            let distanceToGoal =
//            evaluationFunctionCache[hash] = distanceToGoal
//            return distanceToGoal
//        }
    }
    
    mutating func pop() -> Node? {
        // Dequeue element at start of array
        return self.isEmpty ? nil : self.collection.removeFirst()
    }
    
    mutating func push(node: Node) {
        // Evaluate the distance of the state
        let distanceToGoal = self.distanceToGoal(node)
        // Find the index to insert at by finding that whose distance to goal result
        // is equal to or larger than the distanceToGoal calculated for this particular
        // state. If not found, then it's added to the end.
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
    
    mutating func push<C : CollectionType where C.Generator.Element == Node>(nodes: C) {
        for node in nodes {
            self.push(node)
        }
    }
}
