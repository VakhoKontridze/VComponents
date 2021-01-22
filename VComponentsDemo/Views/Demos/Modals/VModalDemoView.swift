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
    @State private var dismissType: Set<VModalModel.DismissType>
    
    @State private var isPresented: Bool = false
    
    private var modalModel: VModalModel {
        var model: VModalModel = .init()
        
        model.dismissType = dismissType
        
        return model
    }
    
    private var pickerModel: VSegmentedPickerModel {
        var model: VSegmentedPickerModel = .init()
        model.animation = nil
        return model
    }
    
    // MARK: Initializers
    init() {
        self._dismissType = State(initialValue: .default)
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
                        VText(title: "Dismiss Type:", color: ColorBook.primary, font: .callout, type: .oneLine)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(content: {
                            ForEach(VModalModel.DismissType.allCases, id: \.rawValue, content: { position in
                                dimissTypeView(position)
                            })
                        })
                            .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func dimissTypeView(_ position: VModalModel.DismissType) -> some View {
        VCheckBox(
            isOn: .init(
                get: { dismissType.contains(position) },
                set: { isOn in
                    switch isOn {
                    case false: dismissType.remove(position)
                    case true: dismissType.insert(position)
                    }
                }
            ),
            title: position.title
        )
    }
    
    private var modalContent: some View {
        ZStack(content: {
            ColorBook.accent.opacity(0.5)
            
            if dismissType.isEmpty {
                VStack(content: {
                    VText(
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
private extension VModalModel.DismissType {
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
