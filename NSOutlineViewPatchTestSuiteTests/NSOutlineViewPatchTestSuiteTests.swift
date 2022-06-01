//
//  NSOutlineViewPatchTestSuiteTests.swift
//  NSOutlineViewPatchTestSuiteTests
//
//  Created by Patrick Dinger on 4/4/22.
//

@testable import NSOutlineViewPatchTestSuite
import XCTest

class NSOutlineViewPatchTestSuiteTests: XCTestCase {
    var viewController: ViewController?

    override func setUpWithError() throws {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateInitialController() as? NSWindowController
        windowController?.window?.isReleasedWhenClosed = true
        windowController?.showWindow(self)

        viewController = windowController?.contentViewController as? ViewController

        if let viewController = viewController {
            viewController.tableView.reloadData()

            // This forces a "flush" of the changes
            viewController.tableView.layout()
        }
    }

    override func tearDownWithError() throws {}

    func testRandomScenarios10K() throws {
        if let c = viewController {
            var currentScenario = c.dataFromTableState()

            for i in 0 ... 10000 {
                let newScenario = randomData()
                print("Running Scenario \(i): \(currentScenario) -> \(newScenario)")

                let result = c.runScenarioCustomDifferenceKit(from: currentScenario, to: newScenario)
                if newScenario != result {
                    print("🫡 Scenario FAILED ❌: \(currentScenario) -> \(newScenario) (was: \(result)")
                } else {
                    print("🫡 Scenario OK ✅: \(currentScenario) -> \(newScenario)")
                }

                XCTAssertEqual(result, newScenario)

                // run
                currentScenario = newScenario
            }
        }
    }

    func testRandomScenarios50KLarge() throws {
        if let c = viewController {
            var currentScenario = c.dataFromTableState()

            for i in 0 ... 50000 {
                let newScenario = randomData(maxSize: 100)
                print("Running Scenario \(i): \(currentScenario) -> \(newScenario)")

                let result = c.runScenarioCustomDifferenceKit(from: currentScenario, to: newScenario)
                if newScenario != result {
                    print("🫡 Scenario FAILED ❌: \(currentScenario) -> \(newScenario) (was: \(result)")
                } else {
                    print("🫡 Scenario OK ✅: \(currentScenario) -> \(newScenario)")
                }

                XCTAssertEqual(result, newScenario)

                // run
                currentScenario = newScenario
            }
        }
    }

    func testKnownBrokenScenario() throws {
        if let c = viewController {
            let currentScenario = ["4", "0", "5", "1", "3", "9", "6"]
            c.data = currentScenario
            c.tableView.reloadData()
            c.tableView.layout()

            let newScenario = ["7", "3", "2", "1"]
            print("Running test: \(currentScenario) -> \(newScenario)")

            let result = c.runScenarioCustomDifferenceKit(from: currentScenario, to: newScenario)
            if newScenario != result {
                print("result:", result)
                print("🫡 Scenario FAILED ❌: \(currentScenario) -> \(newScenario)")
            } else {
                print("🫡 Scenario OK ✅: \(currentScenario) -> \(newScenario)")
            }

            XCTAssertEqual(result, newScenario)
        }
    }

    func testKnownWorkingScenario() throws {
        if let c = viewController {
            let currentScenario = ["1", "2", "3"]
            c.data = currentScenario
            c.tableView.reloadData()
            c.tableView.layout()

            let newScenario = ["3", "2", "1"]
            print("Running test: \(currentScenario) -> \(newScenario)")

            let result = c.runScenarioCustomDifferenceKit(from: currentScenario, to: newScenario)
            if newScenario != result {
                print("result:", result)
                print("🫡 Scenario FAILED ❌: \(currentScenario) -> \(newScenario)")
            } else {
                print("🫡 Scenario OK ✅: \(currentScenario) -> \(newScenario)")
            }

            XCTAssertEqual(result, newScenario)
        }
    }

    // if this fails for very large test cases: Make sure the views display size is big enough, otherwise rows might be release
    private func randomData(maxSize: Int = 10) -> [String] {
        var result: [String] = []
        for i in 0 ... maxSize {
            if Int.random(in: 1 ..< 100) > 75 {
                result.append(String(i))
            }
        }
        result.shuffle()
        return result
    }
}
