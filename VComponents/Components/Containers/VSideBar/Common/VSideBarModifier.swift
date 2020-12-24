//
//  VSideBarOverlay.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- Extension
public extension View {
    func vSideBar<Content>(
        isPresented: Binding<Bool>,
        onDismiss dismissAction: (() -> Void)? = nil,
        content: Content
    ) -> some View
        where Content: View
    {
        ModifiedContent(content: self, modifier: VSideBarModifier(
            isPresented: isPresented,
            onDismiss: dismissAction,
            content: content
        ))
    }
}

// MARK:- V Side Bar Modifier
private struct VSideBarModifier<SideBarContent>: ViewModifier where SideBarContent: View {
    // MARK: Properties
    @Binding private var isPresented: Bool
    
    private let dismissAction: (() -> Void)?

    private let sideBarContent: SideBarContent
    
    // MARK: Initializers
    init(
        isPresented: Binding<Bool>,
        onDismiss dismissAction: (() -> Void)? = nil,
        content sideBarContent: SideBarContent
    ) {
        self._isPresented = isPresented
        self.dismissAction = dismissAction
        self.sideBarContent = sideBarContent
    }
}

// MARK:- Body
private extension VSideBarModifier {
    func body(content: Content) -> some View {
        content
            .overlay(VSideBar(
                isPresented: $isPresented,
                onDismiss: dismissAction,
                content: sideBarContent
            ))
    }
}
