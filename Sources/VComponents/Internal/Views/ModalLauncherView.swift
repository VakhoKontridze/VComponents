//
//  ModalLauncherView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 09.08.23.
//

import SwiftUI

// MARK: - Modal Launcher View
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
        Color.clear
            .onAppear(perform: { DispatchQueue.main.async(execute: { isPresented = true }) })

            .contentShape(Rectangle())
            .onTapGesture(perform: { isPresented = true })
    }
}
