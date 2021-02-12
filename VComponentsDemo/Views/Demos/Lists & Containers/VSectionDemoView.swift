//
//  VSectionDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI
import VComponents

// MARK:- V Section Demo View
struct VSectionDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Section"
    
    @State private var layoutType: BaseListLayoutTypeHelper = .default
    @State private var rowCount: Int = 3
}

// MARK:- Body
extension VSectionDemoView {
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
        VSection(
            layout: layoutType.sectionlayoutType,
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
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $layoutType, headerTitle: "Layout", footerTitle: layoutType.description)
            .frame(height: 110, alignment: .top)
        
        StepperSettingView(range: 0...20, value: $rowCount, title: "Rows")
    }
}

// MARK:- Helpers
private extension BaseListLayoutTypeHelper {
    var sectionlayoutType: VSectionLayoutType {
        switch self {
        case .fixed: return .fixed
        case .flexible: return .flexible
        case .constrained: return .flexible
        }
    }
}

// MARK:- Preview
struct VSectionDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSectionDemoView()
    }
}
