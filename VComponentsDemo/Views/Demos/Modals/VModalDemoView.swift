//
//  VModalDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK:- V Modal Demo View
struct VModalDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Modal"
    
    @State private var hasTitle: Bool = true
    @State private var closeButton: Set<VModalModel.Layout.VModalCloseButton>
    
    @State private var isPresented: Bool = false
    
    private var modalModel: VModalModel {
        var model: VModalModel = .init()
        
        model.layout.closeButton = closeButton
        
        return model
    }
    
    private var pickerModel: VSegmentedPickerModel {
        var model: VSegmentedPickerModel = .init()
        model.animation = nil
        return model
    }
    
    // MARK: Initializers
    init() {
        self._closeButton = State(initialValue: [.default])
    }
}

// MARK:- Body
extension VModalDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .section, content: {
                VStack(spacing: 20, content: {
                    ToggleSettingView(isOn: $hasTitle, title: "Title")
                    
                    VStack(spacing: 3, content: {
                        VBaseText(title: "Close Button", color: ColorBook.primary, font: .callout, type: .oneLine)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(content: {
                            ForEach(VModalModel.Layout.VModalCloseButton.allCases, id: \.rawValue, content: { position in
                                closeButtonView(position)
                            })
                        })
                    })
                    
                    VSecondaryButton(action: { isPresented = true }, title: "Demo Modal")
                })
            })
        })
            .if(hasTitle,
                ifTransform: {
                    $0
                        .vModal(isPresented: $isPresented, modal: {
                            VModal(
                                model: modalModel,
                                header: { VModalDefaultHeader(title: "Lorem ipsum dolor sit amet") },
                                content: { modalContent }
                            )
                        })
                }, elseTransform: {
                    $0
                        .vModal(isPresented: $isPresented, modal: {
                            VModal(
                                model: modalModel,
                                content: { modalContent }
                            )
                        })
                }
            )
    }
    
    private func closeButtonView(_ position: VModalModel.Layout.VModalCloseButton) -> some View {
        VCheckBox(
            isOn: .init(
                get: { closeButton.contains(position) },
                set: { isOn in
                    switch isOn {
                    case false: closeButton.remove(position)
                    case true: closeButton.insert(position)
                    }
                }
            ),
            title: position.title
        )
    }
    
    private var modalContent: some View {
        ZStack(content: {
            Color.red.opacity(0.5)
            
            if closeButton.isEmpty {
                VStack(content: {
                    VBaseText(
                        title: "When close button is \"none\", Modal can only be dismissed programatically",
                        color: ColorBook.primary,
                        font: .system(size: 14, weight: .semibold, design: .default),
                        type: .multiLine(limit: nil, alignment: .center)
                    )
                    
                    VSecondaryButton(action: { isPresented = false }, title: "Dismiss")
                })
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(16)
            }
        })
    }
}

// MARK:- Helpers
private extension VModalModel.Layout.VModalCloseButton {
    var title: String {
        switch self {
        case .leading: return "Leading"
        case .trailing: return "Trailing"
        case .backTap: return "Back Tap"
        }
    }
}

// MARK:- Preview
struct VModalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VModalDemoView()
    }
}
