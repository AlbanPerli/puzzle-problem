
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

import XCTest
import Foundation

class StaticStateSearchTests: XCTestCase {
    // Goal state for static tests
    private let easyGoalState = State(matrix:[
        [5,6,1],
        [7,0,2],
        [4,3,8]
    ])
    private let hardGoalState = State(matrix:[
        [0,1,2],
        [3,4,5],
        [6,7,8]
    ])

    private func doSearch(solver: Solver) {
        var i = 0
        var now = NSDate()
        var actions: [Action] = []
        measureBlock {
            actions = solver.solve().goalNode!.actionsToThisNode
            self.stopMeasuring()
            
            i += 1
            print("Completed performance test \(solver.searchMethod.dynamicType.code) \(i) in \(-now.timeIntervalSinceNow)s")
            print("\t\(solver.numberOfNodesTraversed) traversed")
            print("\tSolution \(solver.goalNode!.debugDescription) in \(actions.count) moves")
            now = NSDate()
        }
        XCTAssertNotNil(actions)
        XCTAssertNotNil(actions.count > 0)
    }


    private func easySearch(method: SearchMethod) {
        let rootNodeState = State(matrix: [
            [6,3,1],
            [5,0,2],
            [7,4,8]
        ])
        doSearch(Solver(rootState: rootNodeState, method: method))
    }

    private func hardSearch(method: SearchMethod) {
        let rootNodeState = State(matrix: [
            [7,2,4],
            [5,0,6],
            [8,3,1]
        ])
        doSearch(Solver(rootState: rootNodeState, method: method))
    }

    func testBFS_Easy() {
        let method = BreadthFirstSearch(goalState: easyGoalState)
        easySearch(method)
    }
    func testDFS_Easy() {
        let method = DepthFirstSearch(goalState: easyGoalState)
        easySearch(method)
    }
    func testGBFS_Easy_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: easyGoalState)
        let method = GreedyBestFirstSearch(goalState: easyGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testGBFS_Easy_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: easyGoalState)
        let method = GreedyBestFirstSearch(goalState: easyGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testAS_Easy_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: easyGoalState)
        let method = AStarSearch(goalState: easyGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testAS_Easy_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: easyGoalState)
        let method = AStarSearch(goalState: easyGoalState, heuristicFunction: heuristic)
        easySearch(method)
    }
    func testBOGO_Easy() {
        let method = BogosortSearch(goalState: easyGoalState)
        easySearch(method)
    }
    func testBFS_Hard() {
        let method = BreadthFirstSearch(goalState: hardGoalState)
        hardSearch(method)
    }
    func testDFS_Hard() {
        let method = DepthFirstSearch(goalState: hardGoalState)
        hardSearch(method)
    }
    func testGBFS_Hard_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testGBFS_Hard_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: hardGoalState)
        let method = GreedyBestFirstSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testAS_Hard_MisplacedTileHeuristic() {
        let heuristic = MisplacedTileHeuristic(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testAS_Hard_DistanceToGoalHeuristic() {
        let heuristic = DistanceToGoalHeuristic(goalState: hardGoalState)
        let method = AStarSearch(goalState: hardGoalState, heuristicFunction: heuristic)
        hardSearch(method)
    }
    func testBOGO_Hard() {
        let method = BogosortSearch(goalState: hardGoalState)
        hardSearch(method)
    }
}