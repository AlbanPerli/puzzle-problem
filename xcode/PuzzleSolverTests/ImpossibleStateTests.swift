//
//  ImpossibleStateTests.swift
//  PuzzleProblem
//
//  Created by Alex on 4/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

import XCTest

class ImpossibleStateTests: XCTestCase {
    // These states are impossible to solve
    func testImpossibleToSolve() {
        XCTAssertFalse(validateSequence([6,7,4,1,5,3,8,0,2], width: 3))
        XCTAssertFalse(validateSequence([3,4,2,1,8,7,6,0,5], width: 3))
    }

    // These states are possible to solve
    func testPossibleToSolve() {
        XCTAssertTrue(validateSequence([6,3,1,5,0,2,7,4,8], width: 3))
        XCTAssertTrue(validateSequence([3,4,1,6,0,2,5,7,8], width: 3))
    }
}