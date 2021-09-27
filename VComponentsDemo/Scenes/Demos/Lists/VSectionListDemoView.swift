//
//  VSectionListDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI
import VComponents

// MARK: - V Section List Demo View
struct VSectionListDemoView: View {
    // MARK: Properties
    static let navBarTitle: String { "Section List" }
    
    @State private var layoutType: BaseListLayoutTypeHelper = .default
    @State private var hasHeaders: Bool = true
    @State private var hasFooters: Bool = true
    @State private var sectionCount: Int = 2
    @State private var rowCount: Int = 3

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(
                type: layoutType.demoViewComponentContentType,
                hasLayer: false,
                component: component,
                settings: settings
            )
        })
    }
    
    private func component() -> some View {
        Group(content: {
            switch (hasHeaders, hasFooters) {
            case (false, false):
                VSectionList(
                    layout: layoutType.tablelayoutType,
                    sections: VSectionListDataSource.sections(rowCount: rowCount, sectionCount: sectionCount),
                    rowContent: { VSectionListDataSource.rowContent(title: $0.title, color: $0.color) }
                )
                
            case (false, true):
                VSectionList(
                    layout: layoutType.tablelayoutType,
                    sections: VSectionListDataSource.sections(rowCount: rowCount, sectionCount: sectionCount),
                    footerTitle: { "Footer \($0.title)" },
                    rowContent: { VSectionListDataSource.rowContent(title: $0.title, color: $0.color) }
                )
                
            case (true, false):
                VSectionList(
                    layout: layoutType.tablelayoutType,
                    sections: VSectionListDataSource.sections(rowCount: rowCount, sectionCount: sectionCount),
                    headerTitle: { "Header \($0.title)" },
                    rowContent: { VSectionListDataSource.rowContent(title: $0.title, color: $0.color) }
                )
                
            case (true, true):
                VSectionList(
                    layout: layoutType.tablelayoutType,
                    sections: VSectionListDataSource.sections(rowCount: rowCount, sectionCount: sectionCount),
                    headerTitle: { "Header \($0.title)" },
                    footerTitle: { "Footer \($0.title)" },
                    rowContent: { VSectionListDataSource.rowContent(title: $0.title, color: $0.color) }
                )
            }
        })
            .ifLet(layoutType.height, transform: { (view, height) in
                Group(content: {
                    view
                        .frame(height: height)
                })
                    .frame(maxHeight: .infinity, alignment: .top)
            })
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $layoutType, headerTitle: "Frame", footerTitle: layoutType.description)
                .frame(height: 110, alignment: .top)
        })
        
        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $hasHeaders, title: "Headers")
            
            ToggleSettingView(isOn: $hasFooters, title: "Footers")
        })
        
        DemoViewSettingsSection(content: {
            StepperSettingView(range: 0...10, value: $sectionCount, title: "Sections")
            
            StepperSettingView(range: 0...10, value: $rowCount, title: "Rows")
        })
    }
}

// MARK: - Helpers
extension BaseListLayoutTypeHelper {
    fileprivate var tablelayoutType: VSectionListLayoutType {
        switch self {
        case .fixed: return .fixed
        case .flexible: return .flexible
        case .constrained: return .flexible
        }
    }
}

// Copied and modified from VSectionList's preview
private struct VSectionListDataSource {
    private init() {}
    
    struct Section: VSectionListSectionViewModelable {
        let id: Int
        let title: String
        let rows: [Row]
    }

    struct Row: Identifiable {
        let id: Int
        let color: Color
        let title: String
    }

    static func sections(rowCount: Int, sectionCount: Int) -> [Section] {
        (0..<sectionCount).map { i in
            .init(
                id: i,
                
                title: spellOut(i + 1),
                
                rows: (0..<rowCount).map { ii in
                    let num: Int = i * rowCount + ii + 1
                    return .init(
                        id: num,
                        color: [.red, .green, .blue][ii % 3],
                        title: spellOut(num)
                    )
                }
            )
        }
    }
    
    static func rowContent(title: String, color: Color) -> some View {
        HStack(spacing: 10, content: {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(color.opacity(0.8))
                .frame(dimension: 32)

            VText(
                type: .oneLine,
                font: .body,
                color: ColorBook.primary,
                title: title
            )
        })
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private static func spellOut(_ i: Int) -> String {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .spellOut
        return formatter.string(from: .init(value: i))?.capitalized ?? ""
    }
}

// MARK: - Preview
struct VSectionListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSectionListDemoView()
    }
}
