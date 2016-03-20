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
    /// Underlying data set is array of nodes
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
    /// Sees which node is next in the frontier but does not mutate the frontier
    /// - Returns: The next element in the frontier or `nil` if empty
    ///
    func peek() -> Node?
}

// MARK: Protocol extension to Frontier

extension Frontier {
    ///
    /// Returns true iff the frontier is empty
    ///
    var isEmpty: Bool {
        return self.peek() == nil
    }
    ///
    /// Pushes multiple nodes at once
    ///
    mutating func push<S : SequenceType where S.Generator.Element == Node>(nodes: S) {
        self.collection.appendContentsOf(nodes)
    }
    ///
    /// Returns true iff the frontier contains the element
    ///
    func contains(node: Node) -> Bool {
        return self.collection.contains(node)
    }
}