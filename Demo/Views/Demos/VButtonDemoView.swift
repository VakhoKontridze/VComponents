//
//  VButtonDemoView.swift
//  Demo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- VButton Demo View
struct VButtonDemoView: View {
    // MARK: Properties
    static let sceneTitle: String = "Button"
    
    private let buttonTitle: String = "Press"
    
    @State private var vButtonCompactState: VButtonState = .enabled
    @State private var vButtonFixedState: VButtonState = .enabled
    @State private var vButtonFlexibleState: VButtonState = .enabled
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
                
                VStack(content: {
                    Toggle(
                        "",
                        isOn: .init(
                            get: { ![vButtonCompactState, vButtonFixedState, vButtonFlexibleState].contains(where: { $0 != .disabled }) },
                            set: {
                                vButtonCompactState = $0 ? .disabled : .enabled
                                vButtonFixedState = $0 ? .disabled : .enabled
                                vButtonFlexibleState = $0 ? .disabled : .enabled
                            }
                        )
                    )
                    
                    Text("Disabled")
                })
                
                Spacer()
                
                VStack(content: {
                    Toggle(
                        "",
                        isOn: .init(
                            get: { ![vButtonCompactState, vButtonFixedState, vButtonFlexibleState].contains(where: { $0 != .loading }) },
                            set: {
                                vButtonCompactState = $0 ? .loading : .enabled
                                vButtonFixedState = $0 ? .loading : .enabled
                                vButtonFlexibleState = $0 ? .loading : .enabled
                            }
                        )
                    )
                    
                    Text("Loading")
                })
                
                Spacer()
            })
                .labelsHidden()
        })
    }

    private var vButtons: some View {
        VStack(content: {
            RowView(
                title: "Compact",
                content: {
                    VButton(state: vButtonCompactState, type: .compact, viewModel: .init(), action: { print("Pressed") }, title: buttonTitle)
                }
            )
            
            RowView(
                title: "Fixed",
                content: { VButton(state: vButtonFixedState, type: .fixed, viewModel: .init(), action: { print("Pressed") }, title: buttonTitle) }
            )
            
            RowView(
                title: "Flexible",
                content: { VButton(state: vButtonFlexibleState, type: .flexible, viewModel: .init(), action: { print("Pressed") }, title: buttonTitle) }
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
