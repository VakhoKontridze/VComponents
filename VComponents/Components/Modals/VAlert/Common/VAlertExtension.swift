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
        _ alertType: VAlertType = .default,
        isPresented: Binding<Bool>,
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String
    ) -> some View {
        VAlertPresenter.present(
            VAlert(
                alertType,
                isPresented: isPresented,
                dialog: dialogType,
                title: title,
                description: description
            ),
            if: isPresented
        )
        
        return self
    }
}
