//
//  VButtonDemoView.swift
//  Demo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Button Demo View
struct VButtonDemoView: View {
    // MARK: Properties
    static let sceneTitle: String = "Button"
    
    private let buttonTitle: String = "Press"
    
    @State private var compactButtonState: VButtonState = .enabled
    @State private var fixedButtonState: VButtonState = .enabled
    @State private var flexibleButtonState: VButtonState = .enabled
}

// MARK:- Body
extension VButtonDemoView {
    var body: some View {
        ScrollView(content: {
            LazyVStack(content: {
                controller
                vButtons
            })
        })
            .navigationTitle(Self.sceneTitle)
    }
    
    private var controller: some View {
        RowView(title: nil, content: {
            HStack(content: {
                Spacer()
                
                ToggleSettingView(
                    isOn: .init(
                        get: { ![compactButtonState, fixedButtonState, flexibleButtonState].contains(where: { $0 != .disabled }) },
                        set: {
                            compactButtonState = $0 ? .disabled : .enabled
                            fixedButtonState = $0 ? .disabled : .enabled
                            flexibleButtonState = $0 ? .disabled : .enabled
                        }
                    ),
                    title: "Disabled"
                )
                
                Spacer()
                
                ToggleSettingView(
                    isOn: .init(
                        get: { ![compactButtonState, fixedButtonState, flexibleButtonState].contains(where: { $0 != .loading }) },
                        set: {
                            compactButtonState = $0 ? .loading : .enabled
                            fixedButtonState = $0 ? .loading : .enabled
                            flexibleButtonState = $0 ? .loading : .enabled
                        }
                    ),
                    title: "Loading"
                )

                Spacer()
            })
        })
    }

    private var vButtons: some View {
        VStack(content: {
            RowView(
                title: "Compact",
                content: {
                    VButton(state: compactButtonState, type: .compact, viewModel: .init(), action: { print("Pressed") }, title: buttonTitle)
                }
            )
            
            RowView(
                title: "Fixed",
                content: { VButton(state: fixedButtonState, type: .fixed, viewModel: .init(), action: { print("Pressed") }, title: buttonTitle) }
            )
            
            RowView(
                title: "Flexible",
                content: { VButton(state: flexibleButtonState, type: .flexible, viewModel: .init(), action: { print("Pressed") }, title: buttonTitle) }
            )
        })
    }
}

// MARK: Preview
struct VButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VButtonDemoView()
    }
}
