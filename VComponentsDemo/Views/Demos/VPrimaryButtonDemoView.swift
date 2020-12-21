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
    
    private func buttonContent() -> some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(.white)
    }
    
    @State private var buttonState: VPrimaryButtonState = .enabled
}

// MARK:- Body
extension VPrimaryButtonDemoView {
    var body: some View {
        VStack(content: {
            controller
            
            VLazyListView(content: {
                buttonsByType
                imageButtons
                borderedButton
            })
        })
            .navigationTitle(Self.sceneTitle)
    }
    
    private var controller: some View {
        RowView(type: .controller, content: {
            HStack(content: {
                Spacer()
                
                ToggleSettingView(
                    isOn: .init(
                        get: { buttonState == .disabled },
                        set: { buttonState = $0 ? .disabled : .enabled }
                    ),
                    title: "Disabled"
                )
                
                Spacer()
                
                ToggleSettingView(
                    isOn: .init(
                        get: { buttonState == .loading },
                        set: { buttonState = $0 ? .loading : .enabled }
                    ),
                    title: "Loading"
                )

                Spacer()
            })
        })
    }

    private var buttonsByType: some View {
        VStack(content: {
            RowView(type: .titled("Compact Width"), content: {
                VPrimaryButton(.compact(), state: buttonState, action: action, title: buttonTitle)
            })
            
            RowView(type: .titled("Fixed Width"), content: {
                VPrimaryButton(.fixed(), state: buttonState, action: action, title: buttonTitle)
            })
            
            RowView(type: .titled("Flexible Width"), content: {
                VPrimaryButton(.flexible(), state: buttonState, action: action, title: buttonTitle)
            })
        })
    }
    
    private var imageButtons: some View {
        VStack(content: {
            RowView(type: .titled("Image"), content: {
                VPrimaryButton(.fixed(), state: buttonState, action: action, content: buttonContent)
            })

            RowView(type: .titled("Image and Text"), content: {
                VPrimaryButton(.fixed(), state: buttonState, action: action, content: {
                    HStack(spacing: 5, content: {
                        buttonContent()
                        Text(buttonTitle)
                    })
                })
            })
        })
    }
    
    private var borderedButton: some View {
        let viewModel: VPrimaryButtonFixedViewModel = .init(
            layout: .init(
                borderWidth: 5
            ),
            colors: .init(
                border: .init(
                    enabled: Color(red: 49/255, green: 119/255, blue: 223/255, opacity: 1),
                    pressed: Color(red: 19/255, green: 89/255, blue: 123/255, opacity: 1),
                    disabled: Color(red: 49/255, green: 119/255, blue: 223/255, opacity: 0.25),
                    loading: Color(red: 49/255, green: 119/255, blue: 223/255, opacity: 0.25)
                )
            )
        )
        
        return VStack(content: {
            RowView(type: .titled("Bordered"), content: {
                VPrimaryButton(.fixed(viewModel: viewModel), state: buttonState, action: action, content: buttonContent)
            })
        })
    }
}

// MARK:- Action
private extension VPrimaryButtonDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK:- Preview
struct VPrimaryButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonDemoView()
    }
}
