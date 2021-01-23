//
//  VNavigationLinkDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/16/21.
//

import SwiftUI
import VComponents

// MARK:- V Navigation Link Demo View
struct VNavigationLinkDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Navigation Link"
    
    private let buttonTitle: String = "Lorem ipsum"
    
    private func buttonContent() -> some View { DemoIconContentView(dimension: 20, color: ColorBook.accent) }

    @State private var buttonState: VNavigationLinkState = .enabled
}

// MARK:- Body
extension VNavigationLinkDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, controller: controller, content: {
                DemoRowView(type: .titled("Primary"), content: {
                    VNavigationLink(preset: .primary(), state: buttonState, destination: destination, title: buttonTitle)
                })
                
                DemoRowView(type: .titled("Secondary"), content: {
                    VNavigationLink(preset: .secondary(), state: buttonState, destination: destination, title: buttonTitle)
                })
                
                DemoRowView(type: .titled("Square"), content: {
                    VNavigationLink(preset: .square(), state: buttonState, destination: destination, title: buttonTitle)
                })
                
                DemoRowView(type: .titled("Plain"), content: {
                    VNavigationLink(preset: .plain(), state: buttonState, destination: destination, title: buttonTitle)
                })
                
                DemoRowView(type: .titled("Custom"), content: {
                    VNavigationLink(state: buttonState, destination: destination, label: {
                        HStack(spacing: 5, content: {
                            buttonContent()
                            
                            VText(
                                title: buttonTitle,
                                color: ColorBook.accent,
                                font: VSecondaryButtonModel.Fonts().title,
                                type: .oneLine
                            )
                        })
                    })
                })
            })
        })
    }
    
    var destination: some View {
        VBaseView(title: "Destination", content: {
            ZStack(content: {
                ColorBook.canvas.edgesIgnoringSafeArea(.all)

                VSheet()
            })
        })
    }
    
    private var controller: some View {
        DemoRowView(type: .controller, content: {
            ControllerToggleView(
                state: .init(
                    get: { buttonState == .disabled },
                    set: { buttonState = $0 ? .disabled : .enabled }
                ),
                title: "Disabled"
            )
        })
    }
}

// MARK:- Action
private extension VNavigationLinkDemoView {
    func action() {
        print("Pressed")
    }
}

// MARK: Preview
struct VNavigationLinkDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VNavigationLinkDemoView()
    }
}
