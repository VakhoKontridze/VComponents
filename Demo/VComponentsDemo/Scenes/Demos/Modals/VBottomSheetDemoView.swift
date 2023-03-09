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
    @State private var heightType: VBottomSheetSizeHelper = VBottomSheetUIModel.Layout().sizes.current!.size.heights.helperType // Force-unwrap
    @State private var dismissType: VBottomSheetUIModel.Misc.DismissType = .default
    @State private var hasGrabber: Bool = VBottomSheetUIModel.Layout().grabberSize.height > 0
    @State private var hasTitle: Bool = true
    @State private var hasDivider: Bool = VBottomSheetUIModel.Layout().dividerHeight > 0
    @State private var contentIsDraggable: Bool = VBottomSheetUIModel.Misc().contentIsDraggable
    @State private var autoresizesContent: Bool = VBottomSheetUIModel.Layout().autoresizesContent
    
    private var uiModel: VBottomSheetUIModel {
        var uiModel: VBottomSheetUIModel = .init()
        
        if heightType == .fixed {
            uiModel.layout.sizes = .init( // Assumes that relative is default
                portrait: .point(.init(
                    width: uiModel.layout.sizes.portrait.size.width,
                    heights: .fixed(uiModel.layout.sizes.portrait.size.heights.ideal)
                )),
                landscape: .point(.init(
                    width: uiModel.layout.sizes.landscape.size.width,
                    heights: .fixed(uiModel.layout.sizes.landscape.size.heights.ideal)
                ))
            )
        }

        if !hasTitle && !dismissType.hasButton {
            uiModel.layout.grabberMargins = VBottomSheetUIModel.onlyGrabber.layout.grabberMargins
        } else {
            uiModel.layout.contentMargins = VBottomSheetUIModel.insettedContent.layout.contentMargins
        }
        
        uiModel.layout.grabberSize.height = hasGrabber ? (uiModel.layout.grabberSize.height == 0 ? 4 : uiModel.layout.grabberSize.height) : 0
        
        uiModel.layout.dividerHeight = hasDivider ? (uiModel.layout.dividerHeight == 0 ? 1 : uiModel.layout.dividerHeight) : 0
        uiModel.layout.autoresizesContent = autoresizesContent
        if autoresizesContent { uiModel.layout.contentSafeAreaEdges.insert(.bottom) }
        
        uiModel.colors.divider = hasDivider ? (uiModel.colors.divider == .clear ? .gray : uiModel.colors.divider) : .clear

        uiModel.misc.dismissType = dismissType
        uiModel.misc.contentIsDraggable = contentIsDraggable
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settingsSections: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .vBottomSheet(
                id: "bottom_sheet_demo",
                uiModel: uiModel,
                isPresented: $isPresented,
                content: {
                    bottomSheetContent
                        .if(hasTitle, transform: { $0.vBottomSheetHeaderTitle("Lorem Ipsum Dolor Sit Amet") })
                }
            )
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $heightType, headerTitle: "Height")
        })
        
        DemoViewSettingsSection(content: {
            VStack(spacing: 3, content: {
                VText(color: ColorBook.primary, font: .callout, text: "Dismiss Method:")
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack(content: {
                        ForEach(VBottomSheetUIModel.Misc.DismissType.all.elements, id: \.rawValue, content: { position in
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
                isOn: $contentIsDraggable,
                title: "Draggable Content",
                description: "Content dragging is disabled if height is fixed or autoresizing is enabled"
            )
                .disabled(heightType == .fixed || autoresizesContent)
            
            ToggleSettingView(
                isOn: .init(
                    get: { autoresizesContent },
                    set: { newValue in
                        self.autoresizesContent = newValue
                        if newValue { contentIsDraggable = false }
                    }
                ),
                title: "Autoresizes Content"
            )
        })
    }
    
    private func dismissTypeView(_ position: VBottomSheetUIModel.Misc.DismissType) -> some View {
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

    private var bottomSheetContent: some View {
        ZStack(content: {
            switch autoresizesContent {
            case false:
                ColorBook.accentBlue
                
            case true:
                List(content: {
                    ForEach(0..<20, content: { num in
                        VListRow(uiModel: .noFirstAndLastSeparators(isFirst: num == 0), content: {
                            Text(String(num))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        })
                    })
                })
                    .vListStyle()
            }

            if dismissType.isEmpty {
                NoDismissTypeWarningView(onDismiss: { isPresented = false })
            }
        })
    }
}

// MARK: - Helpers
private enum VBottomSheetSizeHelper: Int, StringRepresentableHashableEnumeration {
    case fixed
    case dynamic

    var stringRepresentation: String {
        switch self {
        case .fixed: return "Fixed"
        case .dynamic: return "Dynamic"
        }
    }
}

extension VBottomSheetUIModel.Layout.BottomSheetHeights {
    fileprivate var helperType: VBottomSheetSizeHelper {
        if isResizable {
            return .dynamic
        } else {
            return .fixed
        }
    }
}

extension VBottomSheetUIModel.Misc.DismissType {
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
