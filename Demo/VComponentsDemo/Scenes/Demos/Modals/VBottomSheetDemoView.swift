//
//  VBottomSheetDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Bottom Sheet Demo View
struct VBottomSheetDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Bottom Sheet" }
    
    @State private var isPresented: Bool = false
    @State private var heightType: VModalHeightType = VBottomSheetModel.Layout().sizes.current!.size.heights.helperType
    @State private var dismissType: VBottomSheetModel.Misc.DismissType = .default
    @State private var hasGrabber: Bool = VBottomSheetModel.Layout().grabberSize.height > 0
    @State private var hasTitle: Bool = true
    @State private var hasDivider: Bool = VBottomSheetModel.Layout().dividerHeight > 0
    @State private var isContentDraggable: Bool = VBottomSheetModel.Misc().isContentDraggable
    @State private var autoresizesContent: Bool = VBottomSheetModel.Layout().autoresizesContent
    
    private var model: VBottomSheetModel {
        var model: VBottomSheetModel = .init()
        
        if heightType == .fixed {
            model.layout.sizes = .init( // Assumes that relative is default
                portrait: .relative(.init(
                    width: model.layout.sizes.portrait.size.width,
                    heights: .fixed(model.layout.sizes.portrait.size.heights.ideal)
                )),
                landscape: .relative(.init(
                    width: model.layout.sizes.landscape.size.width,
                    heights: .fixed(model.layout.sizes.landscape.size.heights.ideal)
                ))
            )
        }
        
        if !hasDivider && (hasGrabber || hasTitle || dismissType.hasButton) {
            model.layout.headerMargins.bottom /= 2
            model.layout.contentMargins.top /= 2
        }
        
        model.layout.grabberSize.height = hasGrabber ? (model.layout.grabberSize.height == 0 ? 4 : model.layout.grabberSize.height) : 0
        
        model.layout.dividerHeight = hasDivider ? (model.layout.dividerHeight == 0 ? 1 : model.layout.dividerHeight) : 0
        model.layout.autoresizesContent = autoresizesContent
        if autoresizesContent { model.layout.contentSafeAreaEdges.insert(.bottom) }
        
        model.colors.divider = hasDivider ? (model.colors.divider == .clear ? .gray : model.colors.divider) : .clear

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
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
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

                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack(content: {
                        ForEach(VBottomSheetModel.Misc.DismissType.all.elements, id: \.rawValue, content: { position in
                            dismissTypeView(position)
                        })
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
            model: {
                var model: VCheckBoxModel = .init()
                model.layout.titleLineLimit = 1
                return model
            }(),
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
                VList(data: 0..<20, content: { num in
                    Text(String(num))
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                    .padding(.bottom, 10)
            }

            if dismissType.isEmpty {
                NoDismissTypeWarningView(onDismiss: { isPresented = false })
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
}

extension VBottomSheetModel.Layout.BottomSheetHeights {
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
