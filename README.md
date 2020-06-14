# AccessibilitySnapshotPointfree

Accessibility snapshots makes it simple to add regreession tests for accessibility in UIKit.

## Getting Started

This library is an extension to [AccessibilitySnapshot by CashApp](https://github.com/cashapp/AccessibilitySnapshot) and adds support for [Pointfree's SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing/) library which reports and performs comparisons.

Before setting up accessibility snapshot tests, make sure your project is set up for standard snapshot testing. Accessibility snapshot tests require that the test target has a host application.

### CocoaPods

Install with [CocoaPods](https://cocoapods.org) by adding the following to your `Podfile`:

```ruby
pod 'AccessibilitySnapshotPointfree'
```

## Usage

To run a snapshot test, simply call the `assertSnapshot` method with the `accessibilityImage` type:

```swift
func testAccessibility() {
    let view = MyView()
    // Configure the view...

    assertSnapshot(matching: view, as: .accessibilityImage)
}
```

Since AccessibilitySnapshotPointfree is built on top of Pointfree's SnapshotTesting, it uses the same mechanism to record snapshots (setting the `self.record` property) and supports many of the same features like specifying identifiers for each snapshot:

```swift
func testAccessibility() {
    let view = MyView()
    // Configure the view...

    assertSnapshot(matching: view, as: .accessibilityImage, named: "identifier")
}
```

Snapshots can also optionally include indicators for the accessibility activation point of each element. By default, these indicators are shown when the activation point is different than the default activation point for that view. You can override this behavior for each snapshot:

```swift
func testAccessibility() {
    let view = MyView()
    // Configure the view...

    // Show indicators for every element.
    assertSnapshot(matching: view, as: .accessibilityImage(showActivationPoints: .always))

    // Don't show any indicators.
    assertSnapshot(matching: view, as: .accessibilityImage(showActivationPoints: .never))
}
```

Synced with CashApp's AccessibilitySnapshot version 0.3.1