//
//  VHalfModalDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK:- V HalfModal Demo View
struct VHalfModalDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Half Modal"
    
    @State private var isPresented: Bool = false
    @State private var heightType: VModalHeightTypeHelper = VHalfModalModel.Layout.HeightType.default.helperType
    @State private var hasTitle: Bool = true
    @State private var dismissType: Set<VHalfModalDismissTypeHelper> = .init(
        Set<VHalfModalModel.Misc.DismissType>.default
            .filter { $0 != .navigationViewCloseButton }
            .map { $0.helperType }
    )
    @State private var hasDivider: Bool = VHalfModalModel.Layout().dividerHeight > 0
    
    private var model: VHalfModalModel {
        var model: VHalfModalModel = .init()
        
        model.layout.height = heightType.heightType
        model.layout.dividerHeight = hasDivider ? (model.layout.dividerHeight == 0 ? 1 : model.layout.dividerHeight) : 0
        model.colors.divider = hasDivider ? (model.colors.divider == .clear ? .gray : model.colors.divider) : .clear
        
        model.misc.dismissType = .init(dismissType.map { $0.dismissType })
        
        return model
    }
}

// MARK:- Body
extension VHalfModalDemoView {
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
                        .vHalfModal(isPresented: $isPresented, halfModal: {
                            VHalfModal(
                                model: model,
                                headerTitle: "Lorem ipsum dolor sit amet",
                                content: { halfModalContent }
                            )
                        })
                }, elseTransform: {
                    $0
                        .vHalfModal(isPresented: $isPresented, halfModal: {
                            VHalfModal(
                                model: model,
                                content: { halfModalContent }
                            )
                        })
                }
            )
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $heightType, headerTitle: "Height")
        
        ToggleSettingView(isOn: $hasTitle, title: "Title")
        
        VStack(spacing: 3, content: {
            VText(type: .oneLine, font: .callout, color: ColorBook.primary, title: "Dismiss Method:")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                ForEach(VHalfModalDismissTypeHelper.allCases, id: \.rawValue, content: { position in
                    dimissTypeView(position)
                })
            })
                .frame(maxWidth: .infinity, alignment: .leading)
        })
        
        ToggleSettingView(isOn: $hasDivider, title: "Divider")
    }
    
    private func dimissTypeView(_ position: VHalfModalDismissTypeHelper) -> some View {
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
    
    private var halfModalContent: some View {
        ZStack(content: {
            ColorBook.accent
            
            if dismissType.isEmpty {
                VStack(content: {
                    VText(
                        type: .multiLine(limit: nil, alignment: .center),
                        font: .system(size: 14, weight: .semibold),
                        color: ColorBook.primary,
                        title: "When close button is \"none\", Half Modal can only be dismissed programatically"
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
private enum VModalHeightTypeHelper: Int, VPickableTitledItem {
    case fixed
    case dynamic
    
    var pickerTitle: String {
        switch self {
        case .fixed: return "Fixed"
        case .dynamic: return "Dynamic"
        }
    }
    
    var heightType: VHalfModalModel.Layout.HeightType {
        switch self {
        case .fixed: return .fixed(500)
        case .dynamic: return .default
        }
    }
}

private extension VHalfModalModel.Layout.HeightType {
    var helperType: VModalHeightTypeHelper {
        switch self {
        case .fixed: return .fixed
        case .dynamic: return .dynamic
        }
    }
}

private enum VHalfModalDismissTypeHelper: Int, CaseIterable {
    case leading
    case trailing
    case backTap
    case pullDown
    
    var title: String {
        switch self {
        case .leading: return "Leading"
        case .trailing: return "Trailing"
        case .backTap: return "Back Tap"
        case .pullDown: return "Pull Down"
        }
    }
    
    var dismissType: VHalfModalModel.Misc.DismissType {
        switch self {
        case .leading: return .leading
        case .trailing: return .trailing
        case .backTap: return .backTap
        case .pullDown: return .pullDown
        }
    }
}

private extension VHalfModalModel.Misc.DismissType {
    var helperType: VHalfModalDismissTypeHelper {
        switch self {
        case .leading: return .leading
        case .trailing: return .trailing
        case .backTap: return .backTap
        case .pullDown: return .pullDown
        case .navigationViewCloseButton: fatalError()
        }
    }
}

// MARK:- Preview
struct VHalfModalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VHalfModalDemoView()
    }
}
