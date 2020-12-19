//
//  VPrimaryButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Primary Button Demo View
struct VPrimaryButtonDemoView: View {
    // MARK: Properties
    static let sceneTitle: String = "Primary Button"
    
    private let buttonTitle: String = "Press"
    
    @State private var compactButtonState: VPrimaryButtonState = .enabled
    @State private var fixedButtonState: VPrimaryButtonState = .enabled
    @State private var flexibleButtonState: VPrimaryButtonState = .enabled
}

// MARK:- Body
extension VPrimaryButtonDemoView {
    var body: some View {
        VStack(content: {
            controller
            
            VLazyListView(viewModel: .init(), content: {
                vPrimaryButtons
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

    private var vPrimaryButtons: some View {
        VStack(content: {
            RowView(
                title: "Compact",
                content: {
                    VPrimaryButton(state: compactButtonState, type: .compact, viewModel: .init(), action: { print("Pressed") }, title: buttonTitle)
                }
            )
            
            RowView(
                title: "Fixed",
                content: { VPrimaryButton(state: fixedButtonState, type: .fixed, viewModel: .init(), action: { print("Pressed") }, title: buttonTitle) }
            )
            
            RowView(
                title: "Flexible",
                content: { VPrimaryButton(state: flexibleButtonState, type: .flexible, viewModel: .init(), action: { print("Pressed") }, title: buttonTitle) }
            )
        })
    }
}

// MARK: Preview
struct VPrimaryButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonDemoView()
    }
}
