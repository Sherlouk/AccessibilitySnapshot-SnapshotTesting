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

@testable import AccessibilitySnapshotDemo

final class ModalTests: SnapshotTestCase {

    func testSingleModal() {
        let modalAccessibilityViewController = ModalAccessibilityViewController(topLevelCount: 1, containerCount: 0)
        modalAccessibilityViewController.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: modalAccessibilityViewController, as: .accessibilityImage)
    }

    func testTwoModals() {
        let modalAccessibilityViewController = ModalAccessibilityViewController(topLevelCount: 2, containerCount: 0)
        modalAccessibilityViewController.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: modalAccessibilityViewController, as: .accessibilityImage)
    }

    func testTwoContainers() {
        let modalAccessibilityViewController = ModalAccessibilityViewController(topLevelCount: 0, containerCount: 2)
        modalAccessibilityViewController.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: modalAccessibilityViewController, as: .accessibilityImage)
    }

    func testOneModalOneContainer() {
        let modalAccessibilityViewController = ModalAccessibilityViewController(topLevelCount: 1, containerCount: 1)
        modalAccessibilityViewController.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: modalAccessibilityViewController, as: .accessibilityImage)
    }

}
