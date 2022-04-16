//
//  VModalDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK: - V Modal Demo View
struct VModalDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Modal" }
    
    @State private var isPresented: Bool = false
    @State private var hasTitle: Bool = true
    @State private var hasDivider: Bool = VModalModel.Layout().headerDividerHeight > 0
    @State private var dismissType: VModalModel.Misc.DismissType = .default
    
    private var model: VModalModel {
        var model: VModalModel = .init()
        
        model.layout.headerDividerHeight = hasDivider ? (model.layout.headerDividerHeight == 0 ? 1/3 : model.layout.headerDividerHeight) : 0
        model.colors.headerDivider = hasDivider ? (model.colors.headerDivider == .clear ? .gray : model.colors.headerDivider) : .clear
        
        model.misc.dismissType = dismissType
        
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
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
            VText(color: ColorBook.primary, font: .callout, title: "Dismiss Method:")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                ForEach(VModalModel.Misc.DismissType.all.elements(), id: \.rawValue, content: { position in
                    dismissTypeView(position)
                })
            })
                .frame(maxWidth: .infinity, alignment: .leading)
        })
        
        ToggleSettingView(isOn: $hasDivider, title: "Divider")
    }
    
    private func dismissTypeView(_ position: VModalModel.Misc.DismissType) -> some View {
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
                        type: .multiLine(alignment: .center, limit: nil),
                        color: ColorBook.primaryWhite,
                        font: .system(size: 14, weight: .semibold),
                        title: "When close button is \"none\", Modal can only be dismissed programatically"
                    )

                    VPlainButton(
                        model: {
                            var model: VPlainButtonModel = .init()
                            model.colors.title = .init(
                                enabled: ColorBook.primaryWhite,
                                pressed: ColorBook.primaryWhite,
                                disabled: ColorBook.primaryWhite
                            )
                            return model
                        }(),
                        action: { isPresented = false },
                        title: "Dismiss"
                    )
                })
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(15)
            }
        })
    }
}

// MARK: - Helpers
extension VModalModel.Misc.DismissType {
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



public extension OptionSet where RawValue: FixedWidthInteger { // ???
    func _elements() -> AnySequence<Self> {
        var remainingBits = rawValue
        var bitMask: RawValue = 1
        return AnySequence {
            return AnyIterator {
                while remainingBits != 0 {
                    defer { bitMask = bitMask &* 2 }
                    if remainingBits & bitMask != 0 {
                        remainingBits = remainingBits & ~bitMask
                        return Self(rawValue: bitMask)
                    }
                }
                return nil
            }
        }
    }
    
    func elements() -> [Self] {
        .init(_elements())
    }
}
