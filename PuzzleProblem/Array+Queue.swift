//
//  Array+Queue.swift
//  PuzzleProblem
//
//  Created by Alex on 18/03/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import Foundation

extension Array {
    mutating func enqueue(newElement: Element) {
        self.append(newElement)
    }
    mutating func dequeue() -> Element? {
        return self.removeFirst()
    }
}