//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           19/03/2016
//

///
/// A frontier protocol is a protocol which ensures that elements can be added
/// and removed from the frontier. Some frontiers are implemented in different
/// ways than other frontiers, which is why this is a protocol
///
protocol Frontier {
    ///
    /// Underlying data set is array of nodes.
    /// **The collection considers older elements to be at the start
    /// of the array**
    ///
    var collection: [Node] { get set }
    ///
    /// Push a node to the frontier
    /// - Parameter node: The node to add to the frontier
    ///
    mutating func push(node: Node)
    ///
    /// Pop a node off the frontier
    /// - Returns: The next element in the frontier or `nil` if empty
    ///
    mutating func pop() -> Node?
    ///
    /// Pushes multiple nodes at once
    /// - Parameter nodes: Collection of nodes to add
    ///
    mutating func push<C : CollectionType where C.Generator.Element == Node>(nodes: C)
}

// MARK: Protocol extension to Frontier

extension Frontier {
    ///
    /// Sees which node is next in the frontier but does not mutate the frontier
    /// - Returns: The next element in the frontier or `nil` if empty
    ///
    func peek() -> Node? {
        return self.collection.first
    }
    ///
    /// Returns true iff the frontier is empty
    ///
    var isEmpty: Bool {
        return self.peek() == nil
    }
    ///
    /// Returns true iff the frontier contains the element
    ///
    func contains(node: Node) -> Bool {
        return self.collection.contains(node)
    }
    // Implement default behaviour of push. It should just append to the
    // end of the collection. Popping the element will change how it pops
    // (i.e., queue or stack) or overriding push will change how the element
    // the stack
    mutating func push(node: Node) {
        self.collection.append(node)
    }
    // Default implementation of pushing multiple nodes just does it via a simple
    // for loop, although there are improved ways of doing this when applicable
    // to a simple frontier (i.e., stack and queue based)
    mutating func push<C : CollectionType where C.Generator.Element == Node>(nodes: C) {
        for node in nodes {
            self.push(node)
        }
    }
}