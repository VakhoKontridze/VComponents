//
//  PresentationHostExternalDismiss.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/14/22.
//

import SwiftUI

// MARK: - Extension
extension View {
    func presentationHostExternalDismiss(
        _ presentationHostExternalDismiss: PresentationHostExternalDismiss
    ) -> some View {
        self
            .environment(\.presentationHostExternalDismiss, presentationHostExternalDismiss)
    }
}

// MARK: - Presentation Host External Dismiss
/// Object embeded in environemnt of modals presented via `PresentationHost`.
///
/// Contains `dismiss` handler that can be called after frame-based dismissal to remove content from view hierarchy.
///
/// Also contains `isExternallyDismissed` that indicates if dismiss has been triggered via code,
/// i.e., setting `isPresented` to `false`. When this change is triggered, frame-based dismiss animation can occur.
/// After which `externalDismissCompletion` handler must be called to remove content from view hierarchy.
public struct PresentationHostExternalDismiss {
    // MARK: Properties
    /// Dismisses modal.
    public let dismiss: () -> Void
    
    /// Indicates if external dismiss has been triggered via code.
    public let isExternallyDismissed: Bool
    
    /// Completion handler that removes content from view hierarchy.
    ///
    /// Must be called after modal has been animated out.
    public let externalDismissCompletion: () -> Void
    
    // MARK: Initializers
    /// Initializes `PresentationHostExternalDismiss` with bool and completion handlers.
    public init(
        dismiss: @escaping () -> Void,
        isExternallyDismissed: Bool,
        externalDismissCompletion: @escaping () -> Void
    ) {
        self.dismiss = dismiss
        self.isExternallyDismissed = isExternallyDismissed
        self.externalDismissCompletion = externalDismissCompletion
    }
    
    init() {
        self.init(
            dismiss: {},
            isExternallyDismissed: false,
            externalDismissCompletion: {}
        )
    }
}

// MARK: - Presentation Host External Dismiss Environment Value
extension EnvironmentValues {
    /// `PresentationHostExternalDismiss` placed in view hierarchy via `PresentationHost`.
    public var presentationHostExternalDismiss: PresentationHostExternalDismiss {
        get { self[PresentationHostExternalDismissKey.self] }
        set { self[PresentationHostExternalDismissKey.self] = newValue }
    }
}

struct PresentationHostExternalDismissKey: EnvironmentKey {
    static let defaultValue: PresentationHostExternalDismiss = .init()
}
