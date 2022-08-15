//
//  DemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/24/21.
//

import SwiftUI
import VComponents

// MARK: - Demo View Type
enum DemoViewType<ComponentContent, SettingsContent>
    where
        ComponentContent: View,
        SettingsContent: View
{
    case component(
        type: DemoViewComponentContentType,
        content: () -> ComponentContent
    )
    
    case componentAndSettings(
        type: DemoViewComponentContentType,
        component: () -> ComponentContent,
        settings: () -> SettingsContent
    )
}

// MARK: - Demo View Component Content Type
enum DemoViewComponentContentType {
    case fixed
    case flexible
}

// MARK: - Demo View
struct DemoView<ComponentContent, SettingsContent>: View
    where
        ComponentContent: View,
        SettingsContent: View
{
    // MARK: Properties
    private let demoViewType: DemoViewType<ComponentContent, SettingsContent>
    private let hasLayer: Bool
    private let paddedEdges: Edge.Set
    
    @State private var isPresented: Bool = false

    // MARK: Initializers
    init(
        type: DemoViewComponentContentType = .fixed,
        hasLayer: Bool = true,
        paddedEdges: Edge.Set = .all,
        component: @escaping () -> ComponentContent
    )
        where SettingsContent == Never
    {
        self.demoViewType = .component(
            type: type,
            content: component
        )
        self.hasLayer = hasLayer
        self.paddedEdges = paddedEdges
    }
    
    init(
        type: DemoViewComponentContentType = .fixed,
        hasLayer: Bool = true,
        paddedEdges: Edge.Set = .all,
        component componentContent: @escaping () -> ComponentContent,
        @DemoViewSettingsSectionBuilder settingsSections settingsContent: @escaping () -> SettingsContent
    ) {
        self.demoViewType = .componentAndSettings(
            type: type,
            component: componentContent,
            settings: settingsContent
        )
        self.hasLayer = hasLayer
        self.paddedEdges = paddedEdges
    }
    
    init<SingleSectionSettingsContent>(
        type: DemoViewComponentContentType = .fixed,
        hasLayer: Bool = true,
        paddedEdges: Edge.Set = .all,
        component componentContent: @escaping () -> ComponentContent,
        @ViewBuilder settings settingsContent: @escaping () -> SingleSectionSettingsContent
    )
        where SettingsContent == DemoViewSettingsSection<SingleSectionSettingsContent>
    {
        self.demoViewType = .componentAndSettings(
            type: type,
            component: componentContent,
            settings: { DemoViewSettingsSection(content: settingsContent) }
        )
        self.hasLayer = hasLayer
        self.paddedEdges = paddedEdges
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            ColorBook.canvas.ignoresSafeArea()
            
            if hasLayer { VSheet() }

            switch demoViewType {
            case .component(let type, let component):
                componentView(type: type, component: component)
            
            case .componentAndSettings(let type, let component, let settings):
                componentView(type: type, component: component)
                    .toolbar(content: {
                        ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                            settingsView(settings: settings)
                        })
                    })
            }
        })
    }
    
    private func componentView(
        type: DemoViewComponentContentType,
        @ViewBuilder component: @escaping () -> some View
    ) -> some View {
        // Component view is embedded in VStack, as some demo's contain swift case in Groups.
        // Since Group is a pseudo-view, it may cause `VBottomSheets` flicker.
        VStack(content: {
            Group(content: {
                switch type {
                case .fixed:
                    component()
                        .frame(maxWidth: .infinity)
                    
                case .flexible:
                    ScrollView(content: {
                        component()
                            .frame(maxWidth: .infinity)
                    })
                    
                }
            })
                .padding(paddedEdges, 20)
        })
    }
    
    private func settingsView(
        @ViewBuilder settings: @escaping () -> some View
    )  -> some View {
        VPlainButton(
            action: { isPresented = true },
            icon: .init(systemName: "gearshape")
        )
            .vBottomSheet(
                id: "demo_settings",
                uiModel: {
                    var uiModel: VBottomSheetUIModel = .init()
                    uiModel.layout.contentMargins = .zero
                    uiModel.misc.dismissType.insert(.backTap)
                    return uiModel
                }(),
                isPresented: $isPresented,
                headerTitle: "Parameters",
                content: {
                    ScrollView(content: {
                        settings()
                            .padding(.horizontal, VSheetUIModel.Layout().contentMargin)
                    })
                        .safeAreaMarginInsets(edges: .bottom)
                        .padding(.vertical, VSheetUIModel.Layout().contentMargin)
                }
            )
    }
}

// MARK: - Preview
struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonDemoView_Previews.previews
    }
}
