This project demonstrates how to use `NSDistributedNotificationCenter` to provide simple bidirectional messaging between your iOS app and UI tests that are controlling it. This mechanism has been tested in the iOS Simulator and on an iOS device connected to Xcode.

You should **NOT** attempt to put this in the AppStore. Expect Apple to reject your app for the use of a private API if you do.

### Usage

To send a message from your app to your test:

```swift
XCTestBackChannel.shared.sendMessage("Hello")
```

To receive a message from your app:

```swift
func testExample() throws {
    let app = XCUIApplication()
    XCTestBackChannel.shared.delegate = self
    XCTestBackChannel.shared.register(with: app)
    app.launch()
    ...
}

func testBackChannel(handleMessage message: String) {
    print(message)
}
```

### Expectation example

The `XCTestBackChannelDemo` target and tests use this mechanism to fulfill an explectation.

In the app:

```swift
class ViewController: UIViewController {
    @IBAction func tappedButton(_ sender: UIButton) {
        XCTestBackChannel.shared.sendMessage("Hello")
    }
}
```

In the test:

```swift
var expectation : XCTestExpectation?

func testExample() throws {
	expectation = XCTestExpectation(description: "Wait for a message from the app")
    let app = XCUIApplication()
    XCTestBackChannel.shared.delegate = self
    XCTestBackChannel.shared.register(with: app)
    app.launch()
    app.buttons["Button"].tap()
    if let expectation = expectation {
        wait(for: [expectation], timeout: 10)
    }
}

func testBackChannel(handleMessage message: String) {
    print(message)
    expectation?.fulfill()
}
```
