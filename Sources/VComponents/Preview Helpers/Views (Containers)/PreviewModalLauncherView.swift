//
//  PreviewModalLauncherView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 09.08.23.
//

#if DEBUG

import SwiftUI

// MARK: - Preview Modal Launcher View
struct PreviewModalLauncherView: View {
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
#if !(os(tvOS) || os(visionOS))
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
#else
        Button(
            "Present",
            action: { isPresented = true }
        )
#endif
    }
}

#endif
