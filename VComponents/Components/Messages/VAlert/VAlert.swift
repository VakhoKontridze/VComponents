//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Alert
/// Message component that presents dialog when condition is true
///
/// Model, title, description, onAppear and onDisappear callbacks, and content can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// @State var isPresented: Bool = false
///
/// var body: some View {
///     VSecondaryButton(
///         action: { isPresented = true },
///         title: "Present"
///     )
///     .vAlert(isPresented: $isPresented, alert: {
///         VAlert(
///             dialog: .two(
///                 primary: .init(
///                     model: .primary,
///                     title: "Confirm",
///                     action: { print("Confirmed") }
///                 ),
///                 secondary: .init(
///                     model: .secondary,
///                     title: "Cancel",
///                     action: { print("Cancelled") }
///                 )
///             ),
///             title: "Lorem ipsum dolor sit amet",
///             description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
///         )
///     })
/// }
/// ```
///
public struct VAlert<Content> where Content: View {
    // MARK: Properties
    public var model: VAlertModel = .init()
    public var dialogType: VAlertDialogType
    public var title: String?
    public var description: String?
    public var content: (() -> Content)?
    public var appearAction: (() -> Void)?
    public var disappearAction: (() -> Void)?
    
    // MARK: Initializers
    public init(
        model: VAlertModel = .init(),
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String?,
        @ViewBuilder content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    ) {
        self.model = model
        self.dialogType = dialogType
        self.title = title
        self.description = description
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
    
    public init(
        model: VAlertModel = .init(),
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String?,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    )
        where Content == Never
    {
        self.model = model
        self.dialogType = dialogType
        self.title = title
        self.description = description
        self.content = nil
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Extension
extension View {
    /// Presents alert
    public func vAlert<Content>(
        isPresented: Binding<Bool>,
        alert: @escaping () -> VAlert<Content>
    ) -> some View
        where Content: View
    {
        ZStack(content: {
            self
            
            if isPresented.wrappedValue {
                VModalVCRepresentable(
                    isPresented: isPresented,
                    content: _VAlert(isPresented: isPresented, alert: alert()),
                    blinding: alert().model.colors.blinding.edgesIgnoringSafeArea(.all)
                )
            }
        })
    }
}
