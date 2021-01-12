//
//  VAlertModifier.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- Extension
public extension View {
    func vAlert(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String?,
        onDisappear disappearAciton: (() -> Void)? = nil
    ) -> some View {
        VAlertPresenter.present(
            VAlert<Never>(
                model: model,
                isPresented: isPresented,
                dialog: dialogType,
                title: title,
                description: description,
                content: nil,
                onDisappear: disappearAciton
            ),
            model: model,
            if: isPresented
        )
        
        return self
    }
    
    func vAlert<Content>(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String?,
        @ViewBuilder content: @escaping () -> Content,
        onDisappear disappearAciton: (() -> Void)? = nil
    ) -> some View
        where
            Content: View
    {
        VAlertPresenter.present(
            VAlert(
                model: model,
                isPresented: isPresented,
                dialog: dialogType,
                title: title,
                description: description,
                content: content,
                onDisappear: disappearAciton
            ),
            model: model,
            if: isPresented
        )
        
        return self
    }
}
