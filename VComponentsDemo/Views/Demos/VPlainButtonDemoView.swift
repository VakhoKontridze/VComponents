//
//  VPlainButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Plain Button Demo View
struct VPlainButtonDemoView: View {
    // MARK: Properties
    static let sceneTitle: String = "Plain Button"
    
    private let buttonTitle: String = "Press"
    
    @State private var buttonState: VPlainButtonState = .enabled
}

// MARK:- Body
extension VPlainButtonDemoView {
    var body: some View {
        VLazyListView(viewModel: .init(), content: {
            controller
            vPlainButtons
        })
            .navigationTitle(Self.sceneTitle)
    }
    
    private var controller: some View {
        RowView(title: nil, content: {
            HStack(content: {
                ToggleSettingView(
                    isOn: .init(
                        get: { buttonState == .disabled },
                        set: { buttonState = $0 ? .disabled : .enabled }
                    ),
                    title: "Disabled"
                )
            })
        })
    }
    
    private var vPlainButtons: some View {
        VStack(content: {
            RowView(
                title: nil,
                content: { VPlainButton(state: buttonState, viewModel: .init(), action: {}, title: buttonTitle) }
            )
        })
    }
}

// MARK: Preview
struct VPlainButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButtonDemoView()
    }
}

