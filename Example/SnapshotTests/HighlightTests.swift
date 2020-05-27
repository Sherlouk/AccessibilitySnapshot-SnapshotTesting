//
//  Copyright 2019 Square Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import AccessibilitySnapshotPointfree
import SnapshotTesting
import Paralayout
import UIKit

final class HighlightTests: SnapshotTestCase {

    func testColors() {
        let view = AccessibleContainerView(count: 8, innerMargin: 10)
        view.sizeToFit()

        assertSnapshot(matching: view, as: .accessibilityImage)
    }

    func testOverlap() {
        let view = AccessibleContainerView(count: 8, innerMargin: -5)
        view.sizeToFit()

        assertSnapshot(matching: view, as: .accessibilityImage)
    }

    func testColorInSnapshot() {
        let view = UILabel()
        view.text = "Hello World"
        view.textColor = .red
        view.sizeToFit()

        assertSnapshot(matching: view, as: .accessibilityImage(useMonochromeSnapshot: false))
    }

}

// MARK: -

private final class AccessibleContainerView: UIView {

    // MARK: - Life Cycle

    init(count: Int, innerMargin: CGFloat) {
        self.innerMargin = innerMargin

        super.init(frame: .zero)

        for _ in 0..<count {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: subviewSize, height: subviewSize))
            view.isAccessibilityElement = true
            view.accessibilityLabel = "Hello World"
            addSubview(view)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private let subviewSize: CGFloat = 20

    private let outerMargin: CGFloat = 10

    private let innerMargin: CGFloat

    // MARK: - UIView

    override func layoutSubviews() {
        var distribution: [ViewDistributionItem] = [ outerMargin.fixed ]
        for subview in subviews {
            distribution.append(contentsOf: [
                subview.distributionItem,
                1.flexible
            ])
        }
        distribution.removeLast()
        distribution.append(outerMargin.fixed)

        applySubviewDistribution(distribution, axis: .horizontal)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(
            width: CGFloat(subviews.count) * subviewSize + CGFloat(subviews.count - 1) * innerMargin + 2 * outerMargin,
            height: subviewSize + 2 * outerMargin
        )
    }

}
