//
//  VBottomSheetDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK: - V Bottom Sheet Demo View
struct VBottomSheetDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Bottom Sheet" }
    
    @State private var isPresented: Bool = false
    @State private var heightType: VModalHeightType = VBottomSheetModel.Layout.Height.default.helperType
    @State private var dismissType: VBottomSheetModel.Misc.DismissType = .default
    @State private var hasGrabber: Bool = VBottomSheetModel.Layout().grabberSize.height > 0
    @State private var hasTitle: Bool = true
    @State private var hasDivider: Bool = VBottomSheetModel.Layout().headerDividerHeight > 0
    @State private var isContentDraggable: Bool = VBottomSheetModel.Misc().isContentDraggable
    @State private var autoresizesContent: Bool = VBottomSheetModel.Layout().autoresizesContent
    
    private var model: VBottomSheetModel {
        var model: VBottomSheetModel = .init()
        
        if !hasDivider && (hasGrabber || hasTitle || dismissType.hasButton) {
            model.layout.headerMargins.bottom /= 2
            model.layout.contentMargins.top /= 2
        }
        
        model.layout.grabberSize.height = hasGrabber ? (model.layout.grabberSize.height == 0 ? 4 : model.layout.grabberSize.height) : 0
        model.layout.height = heightType.height
        model.layout.headerDividerHeight = hasDivider ? (model.layout.headerDividerHeight == 0 ? 1 : model.layout.headerDividerHeight) : 0
        model.layout.autoresizesContent = autoresizesContent
        
        model.colors.headerDivider = hasDivider ? (model.colors.headerDivider == .clear ? .gray : model.colors.headerDivider) : .clear

        model.misc.dismissType = dismissType
        model.misc.isContentDraggable = isContentDraggable
        
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settingsSections)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(action: { isPresented = true }, title: "Present")
            .if(hasTitle,
                ifTransform: {
                    $0
                        .vBottomSheet(isPresented: $isPresented, bottomSheet: {
                            VBottomSheet(
                                model: model,
                                headerTitle: "Lorem ipsum dolor sit amet",
                                content: { bottomSheetContent }
                            )
                        })
                }, elseTransform: {
                    $0
                        .vBottomSheet(isPresented: $isPresented, bottomSheet: {
                            VBottomSheet(
                                model: model,
                                content: { bottomSheetContent }
                            )
                        })
                }
            )
    }
    
    @DemoViewSettingsSectionBuilder private func settingsSections() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $heightType, headerTitle: "Height")
        })
        
        DemoViewSettingsSection(content: {
            VStack(spacing: 3, content: {
                VText(color: ColorBook.primary, font: .callout, title: "Dismiss Method:")
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(content: {
                    ForEach(VBottomSheetModel.Misc.DismissType.all.elements, id: \.rawValue, content: { position in
                        dismissTypeView(position)
                    })
                })
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $hasGrabber, title: "Grabber")
            
            ToggleSettingView(isOn: $hasTitle, title: "Title")

            ToggleSettingView(isOn: $hasDivider, title: "Divider")
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(
                isOn: $isContentDraggable,
                title: "Draggable Content",
                description: "Content dragging is disabled if autoresizing is enabled"
            )
                .disabled(autoresizesContent)
            
            ToggleSettingView(
                isOn: .init(
                    get: { autoresizesContent },
                    set: { newValue in
                        self.autoresizesContent = newValue
                        if newValue { isContentDraggable = false }
                    }
                ),
                title: "Autoresizes Content"
            )
        })
    }
    
    private func dismissTypeView(_ position: VBottomSheetModel.Misc.DismissType) -> some View {
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

    private var bottomSheetContent: some View {
        ZStack(content: {
            switch autoresizesContent {
            case false:
                ColorBook.accent
                    .padding(.bottom, 10)
                
            case true:
                ScrollView(content: {
                    VStack(content: {
                        ForEach(0..<20, content: { num in
                            Text(String(num))
                                .padding(.vertical, 7)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        })
                        
                        Spacer().frame(height: 10)
                    })
                })
            }

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
                    .padding(15)
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(10)
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

    var height: VBottomSheetModel.Layout.Height {
        switch self {
        case .fixed: return .fixed(VBottomSheetModel.Layout.Height.default.ideal)
        case .dynamic: return .default
        }
    }
}

extension VBottomSheetModel.Layout.Height {
    fileprivate var helperType: VModalHeightType {
        if isResizable {
            return .dynamic
        } else {
            return .fixed
        }
    }
}

extension VBottomSheetModel.Misc.DismissType {
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
struct VBottomSheetDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBottomSheetDemoView()
    }
}
