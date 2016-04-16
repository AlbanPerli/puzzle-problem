//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           18/03/2016
//

///
/// Launcher for the solver
///
struct Launcher {
    // MARK: Singleton
    static let sharedLauncher = Launcher()
    
    // MARK: Launch Errors
    
    ///
    /// Errors that can be caused on launch
    ///
    enum LaunchError: ErrorType {
        case NotEnoughArgumentsProvided
        case InvalidMethodProvided
        case InvalidHeuristicSpecified
        case ProvidedHeuristicToUninformed
        case InvalidThresholdSpecified
        case FileUnreadable
        case NoSizeLine
        case InvalidDataLInes
        case UnexpectedCharacterInDataLine
        case DataLineSizeMismatch
        case ThresholdNotAllowed
        case ThresholdRequired
        
        ///
        /// Textual description of each error
        ///
        var message: String {
            switch self {
            case .NotEnoughArgumentsProvided:
                return "Invalid arguments. Use `help` for more info."
            case .InvalidMethodProvided:
                return "Invalid search method provided. Use `help` for more info."
            case .FileUnreadable:
                return "File provided was unreadable"
            case .InvalidDataLInes:
                return "Not enough data lines in file. Expects two sequence lines"
            case .NoSizeLine:
                return "Size line was missing or invalid. Expects first line to be in format NxM"
            case .UnexpectedCharacterInDataLine:
                return "Unexpected character in data line. Expects data line to be in format n n n n..."
            case .DataLineSizeMismatch:
                return "Expects data line size to match size of N*M"
            case .InvalidThresholdSpecified:
                return "Threshold value specified should be a numerical value greater than 2"
            case .ThresholdNotAllowed:
                return "You can only specify a threshold using a DLS or IDAS method"
            case .InvalidHeuristicSpecified:
                return "Heuristic should be one of `misplaced` or `distance`"
            case .ProvidedHeuristicToUninformed:
                return "You can only provide a heuristic to an informed search"
            case .ThresholdRequired:
                return  "You must provide a threshold for this search. " +
                        "If DLS, the threshold is the maximum allowed depth before backtracking. " +
                        "If IDAS, the threshold is the maximum allowed distance to goal before backtracking."
            }
        }
    }
    
    // MARK: GUI Type
    
    ///
    /// Acceptable arguments for GUI switch
    ///
    enum GUIType: String {
        case Solution
        case Solving
    }
    
    // MARK: Heuristics
    enum HeuristicType: String {
        case Euclidean
        case ManhattanDistance
    }
    
    // MARK: Help descriptions

    ///
    /// The help text
    ///
    var helpText: String {
        let str = [
            "Usage:",
            "  search file method [ OPTIONS ]",
            "  search --help",
            "",
            "Puzzle problem search solver",
            "",
            "File:",
            "  Expects a file whose first line describes the size of the root state(s)",
            "  the second line that displays the start configuration and third line",
            "  that displays the end configuration. Example:",
            "",
            "    3x4",
            "    0 1 2 3 4 5 6 7 8 9 10 11 12",
            "    12 11 10 9 8 7 6 5 4 3 2 1 0",
            "",
            "Method:",
            self.searchMethodDescriptions,
            "",
            "Options:",
            " --gui[=solution|solving]           Invoke the puzzle showing a GUI. Defaults to `solution`",
            "                                    `solution` shows a solution and uses the F and",
            "                                               B keys to traverse through a solution",
            "                                    `solving`  shows the search solving the puzzle (slow)",
            "                                               and then show the output solution",
            " --heuristic=[misplaced|distance]   Invoke the puzzle using a specific heuristic. Defaults to",
            "                                    `distance` when a unformed search method is used. Ignores",
            "                                    whatever value is specified when an uniformed search is used",
            "                                    `distance` uses the Distance To Goal heuristic",
            "                                    `misplaced` uses the Misplaced Tile heuristic",
            " --threshold=[n]                    Valid to DLS and IDAS searches for threshold."
        ]
        return str.joinWithSeparator("\n")
    }
    
    ///
    /// Returns textual description of all search methods available
    ///
    var searchMethodDescriptions: String {
        let str = [
            "  Uninformed:",
            "  [BFS]        run search using Breadth First Search",
            "  [DFS]        run search using Depth First Search",
            "  [DLS|CUS1]   run search using Depth Limited Search. Requires --threshold parameter",
            "  [BOGO|CUS3]  run search using Bogosort Search",
            "",
            "  Informed:",
            "  [GBFS]       run search using Greedy Best First Search",
            "  [AS]         run search using A Star Search",
            "  [IDAS|CUS2]  run search using IDA Star Search. Requires --threshold parameter",
        ]
        return str.joinWithSeparator("\n")
    }
    
    // MARK: Parsers
    
    ///
    /// Parse the provided `method` and return a search method
    /// - Parameter method: A textual representation of a method's code
    /// - Parameter rootState: The root state to initalise the method with
    /// - Parameter goalState: The goal state to initalise the method with
    /// - Parameter heuristicType: The heuristic type to use if parsing an informed search, ignored otherwise
    /// - Parameter threshold: The threshold when parsing a Depth Limited Search, ignored otherwise
    /// - Returns: A new `SearchMethod`, or `nil` if the `method` provided was invalid
    ///
    private func parseMethod(method: String, rootState: State, goalState: State, heuristicType: HeuristicType?, threshold: Int?) throws -> SearchMethod {
        let heuristic: HeuristicFunction = heuristicType == .Euclidean ?
            MisplacedTilesCount(goalState: goalState) :
            ManhattanDistance(goalState: goalState)
        
        let testShouldntHaveHeuristic = {
            if heuristicType != nil {
                throw LaunchError.ProvidedHeuristicToUninformed
            }
        }
        // Match the state against the code provided
        switch method.uppercaseString {
        case DepthFirstSearch.code:
            try testShouldntHaveHeuristic()
            return DepthFirstSearch(goalState: goalState)
        case BreadthFirstSearch.code:
            try testShouldntHaveHeuristic()
            return BreadthFirstSearch(goalState: goalState)
        case GreedyBestFirstSearch.code:
            return GreedyBestFirstSearch(goalState: goalState, heuristicFunction: heuristic)
        case AStarSearch.code:
            return AStarSearch(goalState: goalState, heuristicFunction: heuristic)
        case DepthLimitedSearch.code, "CUS1":
            try testShouldntHaveHeuristic()
            return DepthLimitedSearch(goalState: goalState, threshold: threshold!)
        case BogosortSearch.code, "CUS3":
            try testShouldntHaveHeuristic()
            return BogosortSearch(goalState: goalState)
        case IterativeDeepeningAStarSearch.code, "CUS2":
            return IterativeDeepeningAStarSearch(goalState: goalState, heuristicFunction: heuristic, threshold: threshold!)
        default:
            throw LaunchError.InvalidMethodProvided
        }
    }
    
    ///
    /// Parse the provided file to return `State`s read from the file
    /// - Parameter path: The path of the file to parse
    /// - Returns: A tuple containing the root and goal states
    ///
    private func parseFile(path: String) throws -> (root: State, goal: State) {
        // Read the file
        guard let contents = FileParser.readFile(path) else {
            throw LaunchError.FileUnreadable
        }
        // Support Windows carriage–returns
        let splitBy = Character(contents.characters.contains("\r\n") ? "\r\n" : "\n")
        let lines = contents.characters.split(splitBy)
        let dataLines = lines.suffixFrom(1).map { String($0) }
        // Need at least one data line
        if dataLines.count != 2 {
            throw LaunchError.InvalidDataLInes
        }
        guard
            let size = lines.first?.split("x"),
            let width = Int(String(size[0])),
            let height = Int(String(size[1]))
            else {
                throw LaunchError.NoSizeLine
        }
        let parseStateFromLine = { (line: String) -> State in
            let sequence = line.characters.split(" ").map { Int(String($0)) }
            if sequence.contains({ $0 == nil }) {
                throw LaunchError.UnexpectedCharacterInDataLine
            }
            if sequence.count != height * width {
                throw LaunchError.DataLineSizeMismatch
            }
            return State(sequence: sequence.flatMap { $0 }, height: height, width: width)
        }
        return try (
            root: parseStateFromLine(dataLines[0]),
            goal: parseStateFromLine(dataLines[1])
        )
    }
    
    ///
    /// Parses program argumenrts
    /// - Returns: Solver to solve or `nil` if help was requested
    ///
    private func parseArgs() throws -> Solver? {
        // Strip the args
        var args = Process.arguments.enumerate().generate()
        // Data returned
        var usingGuiType: GUIType?
        // Name of file
        var filename: String = ""
        // Use misplaced tile by default, otherwise misplaced if provided
        var usingHeuristic: HeuristicType?
        if args.contains({$0.element == "--heuristic=misplaced"}) {
            usingHeuristic = .Euclidean
        } else if args.contains({$0.element == "--heuristic=distance"}) {
            usingHeuristic = .ManhattanDistance
        } else if args.contains({
            $0.element.characters.split("=").first?.elementsEqual("--heuristic".characters) ?? false
        }) {
            throw LaunchError.InvalidHeuristicSpecified
        }
        var states: (root: State, goal: State)? = nil
        var method: SearchMethod? = nil
        // Default threshold
        var threshold: Int?
        let thresholdRequired = Process.arguments[2] == DepthLimitedSearch.code ||
                                Process.arguments[2] == IterativeDeepeningAStarSearch.code
        // Check for threshold
        for arg in args {
            if arg.element.characters.split("=").first?.elementsEqual("--threshold".characters) ?? false {
                // Only allow cuttoff for DLS or IDAS search
                if thresholdRequired {
                    guard
                        let thresholdProvided = arg.element.characters.split("=").map({ Int(String($0)) }).last
                        where thresholdProvided > 2 else {
                        throw LaunchError.InvalidThresholdSpecified
                    }
                    threshold = thresholdProvided!
                    break
                } else {
                    throw LaunchError.ThresholdNotAllowed
                }
            }
        }
        // Check if threshold required
        if threshold == nil && thresholdRequired {
            throw LaunchError.ThresholdRequired
        }
        // Look for extra arguments
        while let arg = args.next() {
            // Default to index positions
            switch arg.index {
            // Filename
            case 1:
                filename = arg.element
                // Try parse provided file
                states = try parseFile(arg.element)
            // Search method
            case 2:
                method = try parseMethod(arg.element,
                                         rootState: states!.root,
                                         goalState: states!.goal,
                                         heuristicType: usingHeuristic,
                                         threshold: threshold)
            default:
                // Don't handle
                break
            }
            // Look for textual
            switch arg.element {
            case "--help", "-help", "help", "-h":
                return nil
            case "--gui", "--gui=solution":
                usingGuiType = .Solution
            case "--gui=solving":
                usingGuiType = .Solving
            default:
                // Don't handle
                break
            }
        }
        let rootNode = Node(initialState: states!.root)

        return Solver(rootNode: rootNode,
                      method: method!,
                      gui: usingGuiType,
                      filename: filename)
    }
    
    
    // MARK: Entry point
    
    ///
    /// Entry point of the solver
    ///
    func run() throws {
        do {
            // Process args when argc is at least 2 else print help
            if Process.argc > 2 {
                if let solver = try parseArgs() {
                    return solver.solve().displayResults()
                }
            }
            print(self.helpText)
        } catch let error as Launcher.LaunchError {
            throw error
        }
    }
}


do {
    try Launcher.sharedLauncher.run()
} catch let error as Launcher.LaunchError {
    print(error.message)
}
