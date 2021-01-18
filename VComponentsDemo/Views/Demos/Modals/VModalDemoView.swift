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
    @State private var closeButtonPosition: VModalModel.Layout.VModalCloseButtonPosition
    
    @State private var isPresented: Bool = false
    
    private var modalModel: VModalModel {
        var model: VModalModel = .init()
        
        model.layout.closeButtonPosition = closeButtonPosition
        
        return model
    }
    
    private var pickerModel: VSegmentedPickerModel {
        var model: VSegmentedPickerModel = .init()
        model.animation = nil
        return model
    }
    
    // MARK: Initializers
    init() {
        self._closeButtonPosition = State(initialValue: .default)
    }
}

// MARK:- Body
extension VModalDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .section, content: {
                VStack(spacing: 20, content: {
                    ToggleSettingView(isOn: $hasTitle, title: "Modal Has Title")
                    
                    VSegmentedPicker(model: pickerModel, selection: $closeButtonPosition, title: "Close Button Position")
                    
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
    
    private var modalContent: some View {
        ZStack(content: {
            Color.red.opacity(0.5)
            
            if closeButtonPosition == .none {
                VStack(content: {
                    VBaseTitle(
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
extension VModalModel.Layout.VModalCloseButtonPosition: VPickerTitledEnumerableItem {
    public var pickerTitle: String {
        switch self {
        case .none: return "None"
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
