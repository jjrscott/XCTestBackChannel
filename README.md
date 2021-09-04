This project demonstrates how to use `NSDistributedNotificationCenter` to provide simple bidirectional messaging between your iOS app and UI tests that are controlling it.

You should **NOT** attempt to put this in the AppStore. Expect Apple to reject your app for the use of a private API if you do.

## Usage

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

