//
//  VNavigationView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Navigation View
/// Navigation component that presents stack of views with a visible path in a navigation hierarchy
///
/// Model can be passed as parameter
///
/// Use this method to set root view on navigation stack. It acts as SwiftUI's version of settings UINavigationController root.
///
/// ```
/// extension SceneDelegate {
///    static func setRootView<Content>(to view: Content) where Content: View {
///        guard
///            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
///            let windowScenedelegate = scene.delegate as? SceneDelegate
///        else {
///            return
///        }
///
///        windowScenedelegate.window?.rootViewController = UIHostingController(rootView: view)
///     }
/// }
/// ```
///
/// # Usage Example #
///
/// ```
/// var body: some View {
///     VNavigationView(content: {
///         VBaseView(title: "Home", content: {
///             ZStack(content: {
///                 ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///                 VSheet()
///
///                 VNavigationLink(
///                     preset: .secondary(),
///                     destination: destination,
///                     title: "Navigate to Details"
///                 )
///             })
///         })
///     })
/// }
///
/// var destination: some View {
///     VBaseView(title: "Details", content: {
///         ZStack(content: {
///             ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///             VSheet()
///         })
///     })
/// }
/// ```
///
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
}

// MARK:- Body
extension VNavigationView {
    public var body: some View {
        NavigationView(content: {
            content()
                .setUpNavigationViewNavigationBar()
        })
            .navigationViewStyle(StackNavigationViewStyle())
            .setUpNavigationBarAppearance(model: model)
    }
}

// MARK:- Preview
struct VNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseView_Previews.previews
    }
}
