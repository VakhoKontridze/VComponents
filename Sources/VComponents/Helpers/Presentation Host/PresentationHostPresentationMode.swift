//
//  PresentationHostPresentationMode.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/14/22.
//

import SwiftUI

// MARK: - Extension
extension View {
    func presentationHostPresentationMode(
        _ presentationHostExternalDismiss: PresentationHostPresentationMode
    ) -> some View {
        self
            .environment(\.presentationHostPresentationMode, presentationHostExternalDismiss)
    }
}

// MARK: - Presentation Host Presentation Mode
/// Object embeded in environemnt of modals presented via `PresentationHost`.
///
/// Contains `dismiss` handler that can be called after frame-based dismissal to remove content from view hierarchy.
///
/// Also contains `isExternallyDismissed` that indicates if dismiss has been triggered via code,
/// i.e., setting `isPresented` to `false`. When this change is triggered, frame-based dismiss animation can occur.
/// After which `externalDismissCompletion` handler must be called to remove content from view hierarchy.
public struct PresentationHostPresentationMode {
    // MARK: Properties
    let instanceID: Int?
    
    /// Dismisses modal.
    public let dismiss: () -> Void
    
    /// Indicates if external dismiss has been triggered via code.
    public let isExternallyDismissed: Bool
    
    /// Completion handler that removes content from view hierarchy.
    ///
    /// Must be called after modal has been animated out.
    public let externalDismissCompletion: () -> Void
    
    // MARK: Initializers
    init(
        instanceID: Int,
        dismiss: @escaping () -> Void,
        isExternallyDismissed: Bool,
        externalDismissCompletion: @escaping () -> Void
    ) {
        self.instanceID = instanceID
        self.dismiss = dismiss
        self.isExternallyDismissed = isExternallyDismissed
        self.externalDismissCompletion = externalDismissCompletion
    }
    
    init() {
        self.instanceID = nil
        self.dismiss = {}
        self.isExternallyDismissed = false
        self.externalDismissCompletion = {}
    }
}

// MARK: - Presentation Host Presentation Mode Environment Value
extension EnvironmentValues {
    /// `PresentationHost` presentation mode of the view associated with the environment.
    public var presentationHostPresentationMode: PresentationHostPresentationMode {
        get { self[PresentationHostPresenationModeKey.self] }
        set { self[PresentationHostPresenationModeKey.self] = newValue }
    }
}

struct PresentationHostPresenationModeKey: EnvironmentKey {
    static let defaultValue: PresentationHostPresentationMode = .init()
}
