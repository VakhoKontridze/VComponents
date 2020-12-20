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
                buttons
            })
        })
    }
    
    private var controller: some View {
        RowView(type: .controller, content: {
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
    
    private var buttons: some View {
        VStack(content: {
            RowView(type: .untitled, content: {
                VCircularButton(state: buttonState, action: action, content: buttonContent)
            })
        })
    }
}

// MARK:- Action
private extension VCircularButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK: Preview
struct VCircularButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VCircularButtonDemoView()
    }
}
