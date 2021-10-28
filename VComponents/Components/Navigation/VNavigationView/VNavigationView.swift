//
//  VNavigationView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - V Navigation View
/// Navigation component that presents stack of views with a visible path in a navigation hierarchy.
///
/// Model can be passed as parameter.
///
/// `VNavigationView` and `VNavigationLink` can cause unintended effect in your navigation hierarchy if used alongside with `SwiftUI`'s native `NavigationView` and `NavigationLink`.
/// To handle back button on detail views automatically, default back buttons are hidden, and custom ones are added as long as navigation happens via `VNavigationLink`.
///
/// Use this method to set root view on navigation stack. It acts as `SwiftUI`'s version of setting `UINavigationController` root:
///
///     extension SceneDelegate {
///         static func setRoot(to viewController: UIViewController) {
///             guard
///                 let windowScene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
///                 let sceneDelegate: SceneDelegate = windowScene.delegate as? SceneDelegate
///             else {
///                 return
///             }
///
///             sceneDelegate.window?.rootViewController = viewController
///         }
///
///         static func setRoot<Content>(to view: Content) where Content: View {
///             setRoot(to: UIHostingController(rootView: view))
///         }
///     }
///
/// Usage example:
///
///     var destination: some View {
///         VBaseView(title: "Details", content: {
///             ZStack(content: {
///                 ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///                 VSheet()
///             })
///         })
///     }
///
///     var body: some View {
///         VNavigationView(content: {
///             VBaseView(title: "Home", content: {
///                 ZStack(content: {
///                     ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///                     VSheet()
///
///                     VNavigationLink(
///                         preset: .secondary(),
///                         destination: destination,
///                         title: "Navigate to Details"
///                     )
///                 })
///             })
///         })
///     }
///
/// If you decide to use `VNavigationView` inside `VHalfModal`, consider checking out static properties—`navBarCloseButtonMarginTop`, `navBarCloseButtonMarginTrailing`, and `navBarTrailingItemMarginTrailing`—in `VHalfModalModel.Layout`.
public struct VNavigationView<Content>: View where Content: View {
    // MARK: Properties
    private let model: VNavigationViewModel
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        model: VNavigationViewModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        NavigationView(content: {
            content()
                .setUpNavigationViewNavigationBar()
        })
            .navigationViewStyle(StackNavigationViewStyle())
            .setUpNavigationBarAppearance(model: model)
    }
}

// MARK: - Preview
struct VNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseView_Previews.previews
    }
}
