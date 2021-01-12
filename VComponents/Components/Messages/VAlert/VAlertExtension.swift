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
        description: String
    ) -> some View {
        VAlertPresenter.present(
            VAlert(
                model: model,
                isPresented: isPresented,
                dialog: dialogType,
                title: title,
                description: description
            ),
            model: model,
            if: isPresented
        )
        
        return self
    }
}
