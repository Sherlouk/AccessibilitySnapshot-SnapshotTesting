import SnapshotTesting
import AccessibilitySnapshot

extension Snapshotting where Value == UIView, Format == UIImage {

    public static var accessibilityImage: Snapshotting {
        return .accessibilityImage()
    }
    
    // SnapshotVerifyAccessibility
    public static func accessibilityImage(
        showActivationPoints activationPointDisplayMode: ActivationPointDisplayMode = .whenOverridden,
        useMonochromeSnapshot: Bool = true,
        markerColors: [UIColor] = []
    ) -> Snapshotting {
        
        guard isRunningInHostApplication else {
            fatalError("Accessibility snapshot tests cannot be run in a test target without a host application")
        }
        
        return Snapshotting<UIView, UIImage>.image.pullback { view in
            let containerView = AccessibilitySnapshotView(
                containedView: view,
                viewRenderingMode: .renderLayerInContext,
                markerColors: markerColors,
                activationPointDisplayMode: activationPointDisplayMode
            )
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            containerView.center = window.center
            window.addSubview(containerView)
            
            containerView.parseAccessibility(useMonochromeSnapshot: useMonochromeSnapshot)
            containerView.sizeToFit()
            
            return containerView
        }
        
    }
    
    // SnapshotVerify
    public static func image(
        at contentSizeCategory: UIContentSizeCategory
    ) -> Snapshotting {
        
        Snapshotting<UIView, UIImage>.image(
            traits: .init(preferredContentSizeCategory: contentSizeCategory)
        )
        
    }
    
    // SnapshotVerifyWithInvertedColors
    /// Snapshots the `view` simulating the way it will appear with Smart Invert Colors enabled.
    @available(iOS 11, *)
    public static var imageWithSmartInvert: Snapshotting {
        
       func postNotification() {
            NotificationCenter.default.post(
                name: UIAccessibility.invertColorsStatusDidChangeNotification,
                object: nil,
                userInfo: nil
            )
        }

        return Snapshotting<UIImage, UIImage>.image.pullback { view in
            
            let requiresWindow = (view.window == nil && !(view is UIWindow))
            
            if requiresWindow {
                let window = UIApplication.shared.keyWindow ?? UIWindow(frame: UIScreen.main.bounds)
                window.addSubview(view)
            }
            
            view.layoutIfNeeded()
            
            let statusUtility = UIAccessibilityStatusUtility()
            statusUtility.mockInvertColorsStatus()
            postNotification()
    
            let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
            let image = renderer.image { context in
                view.drawHierarchyWithInvertedColors(in: view.bounds, using: context)
            }
            
            statusUtility.unmockStatuses()
            postNotification()
            
            if requiresWindow {
                view.removeFromSuperview()
            }
            
            return image
            
        }
    }
    
    // MARK: - Internal Properties

    internal static var isRunningInHostApplication: Bool {
        // The tests must be run in a host application in order for the accessibility properties to be populated
        // correctly. The `UIApplication.shared` singleton is non-optional, but will be uninitialized when the tests are
        // running outside of a host application, so we can use this check to determine whether we have a test host.
        let hostApplication: UIApplication? = UIApplication.shared
        return (hostApplication != nil)
    }
    
}

extension Snapshotting where Value == UIViewController, Format == UIImage {
    
    // SnapshotVerifyAccessibility
    public static var accessibilityImage: Snapshotting {
        return .accessibilityImage()
    }
    
    // SnapshotVerifyAccessibility
    public static func accessibilityImage(
        showActivationPoints activationPointDisplayMode: ActivationPointDisplayMode = .whenOverridden,
        useMonochromeSnapshot: Bool = true,
        markerColors: [UIColor] = []
    ) -> Snapshotting {
        
        Snapshotting<UIView, UIImage>.accessibilityImage(
            showActivationPoints: activationPointDisplayMode,
            useMonochromeSnapshot: useMonochromeSnapshot,
            markerColors: markerColors
        ).pullback { viewController in
            viewController.view
        }
        
    }
    
    // SnapshotVerify
    public static func image(
        at contentSizeCategory: UIContentSizeCategory
    ) -> Snapshotting {
        
        Snapshotting<UIView, UIImage>.image(
            traits: .init(preferredContentSizeCategory: contentSizeCategory)
        ).pullback { viewController in
            viewController.view
        }
        
    }
    
    // SnapshotVerifyWithInvertedColors
    /// Snapshots the `view` simulating the way it will appear with Smart Invert Colors enabled.
    @available(iOS 11, *)
    public static var imageWithSmartInvert: Snapshotting {
        Snapshotting<UIView, UIImage>.imageWithSmartInvert.pullback { viewController in
            viewController.view
        }
    }
    
}
