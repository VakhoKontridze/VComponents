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
    static let navBarTitle: String = "Modal"
    
    @State private var isPresented: Bool = false
    @State private var hasTitle: Bool = true
    @State private var hasDivider: Bool = VModalModel.Layout().headerDividerHeight > 0
    @State private var dismissType: Set<VModalModel.Misc.DismissType> = .default
    
    private var model: VModalModel {
        var model: VModalModel = .init()
        
        model.layout.headerDividerHeight = hasDivider ? (model.layout.headerDividerHeight == 0 ? 1 : model.layout.headerDividerHeight) : 0
        model.colors.headerDivider = hasDivider ? (model.colors.headerDivider == .clear ? .gray : model.colors.headerDivider) : .clear
        
        model.misc.dismissType = dismissType
        
        return model
    }
}

// MARK:- Body
extension VModalDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    private func component() -> some View {
        VSecondaryButton(action: { isPresented = true }, title: "Present")
            .if(hasTitle,
                ifTransform: {
                    $0
                        .vModal(isPresented: $isPresented, modal: {
                            VModal(
                                model: model,
                                headerTitle: "Lorem ipsum dolor sit amet",
                                content: { modalContent }
                            )
                        })
                }, elseTransform: {
                    $0
                        .vModal(isPresented: $isPresented, modal: {
                            VModal(
                                model: model,
                                content: { modalContent }
                            )
                        })
                }
            )
    }
    
    @ViewBuilder private func settings() -> some View {
        ToggleSettingView(isOn: $hasTitle, title: "Title")
        
        VStack(spacing: 3, content: {
            VText(type: .oneLine, font: .callout, color: ColorBook.primary, title: "Dismiss Method:")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                ForEach(VModalModel.Misc.DismissType.allCases, id: \.rawValue, content: { position in
                    dimissTypeView(position)
                })
            })
                .frame(maxWidth: .infinity, alignment: .leading)
        })
        
        ToggleSettingView(isOn: $hasDivider, title: "Divider")
    }
    
    private func dimissTypeView(_ position: VModalModel.Misc.DismissType) -> some View {
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
            ColorBook.accent
            
            if dismissType.isEmpty {
                VStack(content: {
                    VText(
                        type: .multiLine(limit: nil, alignment: .center),
                        font: .system(size: 14, weight: .semibold),
                        color: ColorBook.primary,
                        title: "When close button is \"none\", Modal can only be dismissed programatically"
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
private extension VModalModel.Misc.DismissType {
    var title: String {
        switch self {
        case .leadingButton: return "Leading"
        case .trailingButton: return "Trailing"
        case .backTap: return "Back Tap"
        @unknown default: fatalError()
        }
    }
}

// MARK:- Preview
struct VModalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VModalDemoView()
    }
}
