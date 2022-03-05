//
//  VBaseListDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VComponents

// MARK: - V Bas List Demo View
struct VBaseListDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Base List" }
    
    @State private var layoutType: BaseListLayoutTypeHelper = .default
    @State private var rowCount: Int = 5

    // MARK: Body
    var body: some View {
        DemoView(
            type: layoutType.demoViewComponentContentType,
            hasLayer: false,
            component: component,
            settings: settings
        )
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VBaseList(
            layout: layoutType.layoutType,
            data: VBaseListDemoViewDataSource.rows(count: rowCount),
            rowContent: { VBaseListDemoViewDataSource.rowContent(title: $0.title, color: $0.color) }
        )
            .ifLet(layoutType.height, transform: { (view, height) in
                Group(content: {
                    view
                        .frame(height: height)
                })
                    .frame(maxHeight: .infinity, alignment: .top)
            })
    }
    
    private func settings() -> some View {
        VStack(spacing: 20, content: {
            StepperSettingView(range: 0...20, value: $rowCount, title: "Rows")
            
            VSegmentedPicker(
                selection: $layoutType,
                headerTitle: "Layout",
                footerTitle: layoutType.description
            )
                .frame(height: 90, alignment: .top)
        })
    }
}

// MARK: - Helpers
enum BaseListLayoutTypeHelper: Int, PickableTitledEnumeration {
    case fixed
    case flexible
    case constrained
    
    static var `default`: Self { VBaseListLayoutType.default.helperType }
    
    fileprivate var layoutType: VBaseListLayoutType {
        switch self {
        case .fixed: return .fixed
        case .flexible: return .flexible
        case .constrained: return .flexible
        }
    }
    
    var pickerTitle: String {
        switch self {
        case .fixed: return "Fixed"
        case .flexible: return "Flexible"
        case .constrained: return "Constrained"
        }
    }
    
    var description: String {
        switch self {
        case .fixed: return "Component stretches vertically to take required space. Scrolling may be enabled on page."
        case .flexible: return "Component stretches vertically to occupy maximum space, but is constrainted in space given by container. Scrolling may be enabled inside component."
        case .constrained: return "\".frame()\" modifier can be applied to view. Content would be limitd in vertical space. Scrolling may be enabled inside component."
        }
    }
    
    var demoViewComponentContentType: DemoViewComponentContentType {
        switch self {
        case .fixed: return .flexible
        case .flexible: return .fixed
        case .constrained: return .fixed
        }
    }
    
    var height: CGFloat? {
        switch self {
        case .fixed: return nil
        case .flexible: return nil
        case .constrained: return 400
        }
    }
}

extension VBaseListLayoutType {
    fileprivate var helperType: BaseListLayoutTypeHelper {
        switch self {
        case .fixed: return .fixed
        case .flexible: return .flexible
        @unknown default: fatalError()
        }
    }
}

// Copied and modified from VList's preview
struct VBaseListDemoViewDataSource {
    private init() {}
    
    struct Row: Identifiable {
        let id: Int
        let color: Color
        let title: String
    }

    static func rows(count rowCount: Int) -> [Row] {
        (0..<rowCount).map { i in
            .init(
                id: i,
                color: [.red, .green, .blue][i % 3],
                title: spellOut(i + 1)
            )
        }
    }
    
    static func rowContent(title: String, color: Color) -> some View {
        HStack(spacing: 10, content: {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(color.opacity(0.8))
                .frame(dimension: 32)

            VText(
                color: ColorBook.primary,
                font: .body,
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
struct VBaseListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseListDemoView()
    }
}
