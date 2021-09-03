//
//  XCTestBackChannelDemoUITests.swift
//  XCTestBackChannelDemoUITests
//
//  Created by John Scott on 9/3/21.
//

import XCTest
import XCTestBackChannel

class XCTestBackChannelDemoUITests: XCTestCase, XCTestBackChannelDelegate {
    
    var expectation : XCTestExpectation?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        expectation = XCTestExpectation(description: "Wait for a message from the app")

        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        XCTestBackChannel.shared.delegate = self
        XCTestBackChannel.shared.register(with: app)
        app.launch()
        
        if let expectation = expectation {
            wait(for: [expectation], timeout: 10)
        }
        
        XCTestBackChannel.shared.sentMessage("DebugColor")
        sleep(5)

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func xcTestBackChannelHandleMessage(_ message: String) {
        print(message)
        expectation?.fulfill()
    }
}
