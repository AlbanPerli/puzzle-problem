//
//  NodeSet.swift
//  PuzzleProblem
//
//  Created by Alex on 20/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

// MARK: Extension of all CollectionTypes of Node to implement contains method

extension CollectionType where Self.Generator.Element : Node {
    ///
    /// Check if this collection contains the provided node
    ///
    func contains(nodeToCheck: Node) -> Bool {
        return self.contains { node -> Bool in
            return nodeToCheck == node
        }
    }
}