//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Alert
struct VAlert: View {
    // MARK: Properties
    private let alertType: VAlertType
    
    @Binding private var isPresented: Bool
    
    private let dialogType: VAlertDialogType
    
    private let title: String?
    private let description: String
    
    // MARK: Initializers
    init(
        _ alertType: VAlertType = .default,
        isPresented: Binding<Bool>,
        dialog dialogType: VAlertDialogType,
        title: String?,
        description: String
    ) {
        self.alertType = alertType
        self._isPresented = isPresented
        self.dialogType = dialogType
        self.title = title
        self.description = description
    }
}

// MARK:- Body
extension VAlert {
    var body: some View {
        Color.pink
            .overlay(Button("???", action: { isPresented = false }))
            .frame(size: .init(width: 300, height: 300))
    }
}

// MARK:- Preview
//struct VAlert_Previews: PreviewProvider {
//    static var previews: some View {
//        VAlert()
//    }
//}
