//
//  Frontier.swift
//  PuzzleProblem
//
//  Created by Alex on 19/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
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
    ///
    /// Pushes multiple nodes at once
    /// - Parameter nodes: Collection of nodes to add
    ///
    mutating func push<C : CollectionType where C.Generator.Element == Node>(nodes: C) {
        self.collection.appendContentsOf(nodes)
    }

    // Implement default behaviour of push. It should just append to the
    // end of the collection. Popping the element will change how it pops
    // (i.e., queue or stack) or overriding push will change how the element
    // the stack
    mutating func push(node: Node) {
        self.collection.append(node)
    }
}