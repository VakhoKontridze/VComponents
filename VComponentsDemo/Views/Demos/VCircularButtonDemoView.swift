//
//  VCircularButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Circular Button Demo View
struct VCircularButtonDemoView: View {
    // MARK: Properties
    static let sceneTitle: String = "Circular Button"
    
    private func buttonContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(.white)
    }

    @State private var buttonState: VCircularButtonState = .enabled
}

// MARK:- Body
extension VCircularButtonDemoView {
    var body: some View {
        VStack(content: {
            controller
            
            VLazyListView(viewModel: .init(), content: {
                vRoundedButtons
            })
        })
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
    
    private var vRoundedButtons: some View {
        VStack(content: {
            RowView(
                title: nil,
                content: { VCircularButton(state: buttonState, viewModel: .init(), action: { print("Pressed") }, content: buttonContent) }
            )
        })
    }
}

// MARK: Preview
struct VCircularButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VCircularButtonDemoView()
    }
}
