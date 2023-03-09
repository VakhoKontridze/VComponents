//
//  VModalDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Modal Demo View
struct VModalDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Modal" }
    
    @State private var isPresented: Bool = false
    @State private var dismissType: VModalUIModel.Misc.DismissType = .default
    @State private var hasTitle: Bool = true
    @State private var hasDivider: Bool = VModalUIModel.Layout().dividerHeight > 0
    
    private var uiModel: VModalUIModel {
        var uiModel: VModalUIModel = .init()
        
        uiModel.layout.dividerHeight = hasDivider ? (uiModel.layout.dividerHeight == 0 ? 1 : uiModel.layout.dividerHeight) : 0
        uiModel.colors.divider = hasDivider ? (uiModel.colors.divider == .clear ? .gray : uiModel.colors.divider) : .clear
        
        uiModel.misc.dismissType = dismissType
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settings: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .vModal(
                id: "modal_demo",
                uiModel: uiModel,
                isPresented: $isPresented,
                content: {
                    modalContent
                        .if(hasTitle, transform: { $0.vModalHeaderTitle("Lorem Ipsum Dolor Sit Amet") })
                }
            )
    }
    
    @ViewBuilder private func settings() -> some View {
        ToggleSettingView(isOn: $hasTitle, title: "Title")
        
        VStack(spacing: 3, content: {
            VText(color: ColorBook.primary, font: .callout, text: "Dismiss Method:")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack(content: {
                    ForEach(VModalUIModel.Misc.DismissType.all.elements, id: \.rawValue, content: { position in
                        dismissTypeView(position)
                    })
                })
            })
                .frame(maxWidth: .infinity, alignment: .leading)
        })
        
        ToggleSettingView(isOn: $hasDivider, title: "Divider")
    }
    
    private func dismissTypeView(_ position: VModalUIModel.Misc.DismissType) -> some View {
        VCheckBox(
            uiModel: {
                var uiModel: VCheckBoxUIModel = .init()
                uiModel.layout.titleTextLineType = .singleLine
                return uiModel
            }(),
            isOn: .init(
                get: { dismissType.contains(position) },
                set: { isOn in
                    if isOn {
                        dismissType.insert(position)
                    } else {
                        dismissType.remove(position)
                    }
                }
            ),
            title: position.title
        )
    }
    
    private var modalContent: some View {
        ZStack(content: {
            List(content: {
                ForEach(0..<20, content: { num in
                    VListRow(uiModel: .noFirstAndLastSeparators(isFirst: num == 0), content: {
                        Text(String(num))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                })
            })
                .vListStyle()

            if dismissType.isEmpty {
                NoDismissTypeWarningView(onDismiss: { isPresented = false })
            }
        })
    }
}

// MARK: - Helpers
extension VModalUIModel.Misc.DismissType {
    fileprivate var title: String {
        switch self {
        case .leadingButton: return "Leading"
        case .trailingButton: return "Trailing"
        case .backTap: return "Back Tap"
        default: fatalError()
        }
    }
}

// MARK: - Preview
struct VModalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VModalDemoView()
    }
}
