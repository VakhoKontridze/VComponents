//
//  VHalfModalDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK: - V HalfModal Demo View
struct VHalfModalDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Half Modal" }
    
    @State private var isPresented: Bool = false
    @State private var heightType: VModalHeightType = VHalfModalModel.Layout.Height.default.helperType
    @State private var dismissType: VHalfModalModel.Misc.DismissType = .default
    @State private var hasGrabber: Bool = VHalfModalModel.Layout().grabberSize.height > 0
    @State private var hasTitle: Bool = true
    @State private var hasDivider: Bool = VHalfModalModel.Layout().headerDividerHeight > 0
    @State private var isContentDraggable: Bool = VHalfModalModel.Misc().isContentDraggable
    
    private var model: VHalfModalModel {
        var model: VHalfModalModel = .init()
        
        if !hasDivider && (hasGrabber || hasTitle || dismissType.hasButton) {
            model.layout.headerMargins.bottom /= 2
            model.layout.contentMargins.top /= 2
        }
        
        model.layout.grabberSize.height = hasGrabber ? (model.layout.grabberSize.height == 0 ? 4 : model.layout.grabberSize.height) : 0
        model.layout.height = heightType.height
        model.layout.headerDividerHeight = hasDivider ? (model.layout.headerDividerHeight == 0 ? 1 : model.layout.headerDividerHeight) : 0
        
        model.colors.headerDivider = hasDivider ? (model.colors.headerDivider == .clear ? .gray : model.colors.headerDivider) : .clear

        model.misc.dismissType = dismissType
        model.misc.isContentDraggable = isContentDraggable
        
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(action: { isPresented = true }, title: "Present")
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

        VStack(spacing: 3, content: {
            VText(color: ColorBook.primary, font: .callout, title: "Dismiss Method:")
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(content: {
                ForEach(VHalfModalModel.Misc.DismissType.all.elements, id: \.rawValue, content: { position in
                    dismissTypeView(position)
                })
            })
                .frame(maxWidth: .infinity, alignment: .leading)
        })
        
        ToggleSettingView(isOn: $hasGrabber, title: "Grabber")
        
        ToggleSettingView(isOn: $hasTitle, title: "Title")

        ToggleSettingView(isOn: $hasDivider, title: "Divider")
        
        ToggleSettingView(isOn: $isContentDraggable, title: "Draggable Content")
    }
    
    private func dismissTypeView(_ position: VHalfModalModel.Misc.DismissType) -> some View {
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
                        type: .multiLine(alignment: .center, limit: nil),
                        color: ColorBook.primaryWhite,
                        font: .system(size: 14, weight: .semibold),
                        title: "When there are no dismiss types, Modal can only be dismissed programatically"
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
private enum VModalHeightType: Int, PickableTitledEnumeration {
    case fixed
    case dynamic

    var pickerTitle: String {
        switch self {
        case .fixed: return "Fixed"
        case .dynamic: return "Dynamic"
        }
    }

    var height: VHalfModalModel.Layout.Height {
        switch self {
        case .fixed: return .fixed(500)
        case .dynamic: return .default
        }
    }
}

extension VHalfModalModel.Layout.Height {
    fileprivate var helperType: VModalHeightType {
        if isResizable {
            return .dynamic
        } else {
            return .fixed
        }
    }
}

extension VHalfModalModel.Misc.DismissType {
    fileprivate var title: String {
        switch self {
        case .leadingButton: return "Leading"
        case .trailingButton: return "Trailing"
        case .backTap: return "Back Tap"
        case .pullDown: return "Pull Down"
        default: fatalError()
        }
    }
}

// MARK: - Preview
struct VHalfModalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VHalfModalDemoView()
    }
}
