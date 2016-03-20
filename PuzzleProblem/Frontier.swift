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
    /// The internal data representation
    ///
    var collection: [Node] { get }
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
    mutating func push(nodes: [Node]) {
        for node in nodes {
            self.push(node)
        }
    }
    ///
    /// Check if this collection contains the provided node
    ///
    func contains(nodeToCheck: Node) -> Bool {
        return self.collection.contains({ node -> Bool in
            return nodeToCheck == node
        })
    }
}

///
/// A last-in-first-out frontier ensures that each node that the most recently
/// added node is removed first
///
struct LifoFrontier: Frontier {
    var collection: [Node] = []
    mutating func push(node: Node) {
        // Push to the top of the stack
        self.collection.append(node)
    }

    mutating func pop() -> Node? {
        // Pop from the end of the stack
        return self.collection.popLast()
    }

    func peek() -> Node? {
        return self.collection.last
    }
}

///
/// A first-in-first-out frontier ensures that each node that the node that has
/// been in the frontier longest is removed first
///
struct FifoFrontier: Frontier {
    var collection: [Node] = []
    mutating func push(node: Node) {
        // Enqueue element at start of array
        self.collection.insert(node, atIndex: 0)
    }

    mutating func pop() -> Node? {
        // Dequeue element at end of array
        return self.collection.popLast()
    }

    func peek() -> Node? {
        return self.collection.last
    }
}