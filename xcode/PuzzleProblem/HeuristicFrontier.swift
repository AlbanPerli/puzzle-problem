//
//  HeuristicFrontier.swift
//  PuzzleProblem
//
//  Created by Alex on 26/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// A heuristic frontier is a `FifoFrontier` that pushes elements into
/// the correct order based on the state's evaluation function result
/// when applied with a given `HeuristicFunction`
///
struct HeuristicFrontier: Frontier {
    var collection: [Node] = []
    
    ///
    /// The heuristic applied to node's states when pushing to evaluate
    /// that node's evaluation function result
    ///
    private let heuristicFunction: HeuristicFunction
    
    ///
    /// A cache of heuristic functions
    ///
    private var heuristicFunctionCache: Dictionary<Int, Int> = [:]
    
    ///
    /// Initalises a `HeuristicFrontier` with the specified `HeuristicFunction`
    /// - Parameter heuristicFunction: The heuristic to initialise the frontier with
    ///
    init(heuristicFunction: HeuristicFunction) {
        self.heuristicFunction = heuristicFunction
    }
    
    ///
    /// Returns the evaluation function value for the provided state
    /// - Remarks: Looks up the evaluation function from the cache, and
    ///            calculates and then caches's the result of the evaluation
    ///            function instead if it cannot be found in cache
    /// - Paramater state: The state to calculate for
    /// - Returns: The distance for the state to its goal
    ///
    private mutating func evaluationFunction(state: State) -> Int {
        let hash = state.hashValue
        if let result = heuristicFunctionCache[hash] {
            return result
        } else {
            let distanceToGoal = state.performHeuristic(self.heuristicFunction)
            heuristicFunctionCache[hash] = distanceToGoal
            return distanceToGoal
        }
    }
    
    mutating func pop() -> Node? {
        // Dequeue element at start of array
        return self.isEmpty ? nil : self.collection.removeFirst()
    }
    
    mutating func push(node: Node) {
        guard let state = node.state else {
            fatalError("Cannot push node without state")
        }
        // Evaluate the distance of the state
        let distanceToGoal = evaluationFunction(state)
        // Find the index to insert at by finding that whose evaluation function result
        // is equal to or larger than the distanceToGoal. Then subtract one to insert
        // at this index. E.g.:
        //
        //   Insert 7 where f(n) for all nodes in collection are [ 3, 5, 8 ]
        //
        // In this example, indexToInsert will return:
        //
        //   3 >= 7 -> no
        //   5 >= 7 -> no
        //   8 >= 7 -> yes therefore index 2 - 1 = 1
        //
        // So insert at index 1
        let indexToInsert = (self.collection.indexOf { node -> Bool in
            self.evaluationFunction(node.state!) >= distanceToGoal
        } ?? self.collection.count) 
        self.collection.insert(node, atIndex: indexToInsert)
    }
    
    mutating func push<C : CollectionType where C.Generator.Element == Node>(nodes: C) {
        for node in nodes {
            self.push(node)
        }
    }
}
