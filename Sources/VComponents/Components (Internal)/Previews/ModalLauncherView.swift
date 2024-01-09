//
//  ModalLauncherView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 09.08.23.
//

import SwiftUI

// MARK: - Modal Launcher View
@available(tvOS, unavailable)
struct ModalLauncherView: View {
    // MARK: Properties
    @Binding private var isPresented: Bool

    // MARK: Initializers
    init(
        isPresented: Binding<Bool>
    ) {
        self._isPresented = isPresented
    }

    // MARK: Body
    var body: some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
    }
}