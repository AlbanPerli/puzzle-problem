//
//  RandomStateSearchTests.swift
//  PuzzleProblem
//
//  Created by Alex on 14/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//


import XCTest

class RandomStateSearchTests: XCTestCase {
    private static var states: (start: State, goal: State) = {
        let random = (
            width:  Int(cs_arc4random_uniform(5)),
            height: Int(cs_arc4random_uniform(5))
        )
        let startState = randomState(random.width, cols: random.height)
        let goalState =  randomState(random.width, cols: random.height)
        print("Start state: ")
        print(startState.matrix.debugDescription)
        print("Goal state: ")
        print(goalState.matrix.debugDescription)
        return (start: startState, goal: goalState)
    }()

    private let startState = RandomStateSearchTests.states.start
    private let goalState  = RandomStateSearchTests.states.goal

    private func randomSearch(method: SearchMethod) {
        let solver = Solver(rootState: startState, method: method)
        testSearchPerformance(solver)
    }

    // MARK: Dynamic random state search

    func testBFS_Random() {
        let method = BreadthFirstSearch(goalState: goalState)
        randomSearch(method)
    }
    func testDFS_Random() {
        let method = DepthFirstSearch(goalState: goalState)
        randomSearch(method)
    }
    func testGBFS_Random_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: goalState)
        let method = GreedyBestFirstSearch(goalState: goalState,
                                           heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testGBFS_Random_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: goalState)
        let method = GreedyBestFirstSearch(goalState: goalState,
                                           heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testAS_Random_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: goalState)
        let method = AStarSearch(goalState: goalState,
                                 heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testAS_Random_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: goalState)
        let method = AStarSearch(goalState: goalState,
                                 heuristicFunction: heuristic)
        randomSearch(method)
    }
    func testBOGO_Random() {
        let method = BogosortSearch(goalState: goalState)
        randomSearch(method)
    }
    func testDLS_Random() {
        let method = DepthLimitedSearch(goalState: goalState, threshold: 40)
        randomSearch(method)
    }
    func testIDAS_Random_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: goalState)
        let method = IterativeDeepeningAStarSearch(goalState: goalState,
                                                   heuristicFunction: heuristic,
                                                   threshold: 40)
        randomSearch(method)
    }
    func testIDAS_Random_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: goalState)
        let method = IterativeDeepeningAStarSearch(goalState: goalState,
                                                   heuristicFunction: heuristic,
                                                   threshold: 40)
        randomSearch(method)
    }
}