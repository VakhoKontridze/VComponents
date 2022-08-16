//
//  VListDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VCore
import VComponents

// MARK: - V List Demo View
struct VListDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "List" }
    
    @State private var rowCount: Int = 5
    @State private var rowSeparatorType: VListRowSeparatorTypeHelper = .rowEnclosingSeparators

    // MARK: Body
    var body: some View {
        DemoView(paddedEdges: .vertical, component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        List(content: {
            ForEach(0..<rowCount, id: \.self, content: { i in
                VListRow(separator: rowSeparatorType.vListRowSeparatorType(isFirst: i == 0), content: {
                    Text(String(i))
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
            })
        })
            .vListStyle()
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            StepperSettingView(range: 0...20, value: $rowCount, title: "Rows")
        })
        
        DemoViewSettingsSection(content: {
            VWheelPicker(selection: $rowSeparatorType, headerTitle: "Separator Type")
        })
    }

    private static func spellOut(_ i: Int) -> String {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .spellOut
        return formatter.string(from: .init(value: i))?.capitalized ?? ""
    }
}

// MARK: - Preview
struct VListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VListDemoView()
    }
}

// MARK: - Helpers
private enum VListRowSeparatorTypeHelper: Int, StringRepresentableHashableEnumeration {
    case none
    //case top
    //case bottom
    case noFirstSeparator
    case noLastSeparator
    case noFirstAndLastSeparators
    case rowEnclosingSeparators
    
    var stringRepresentation: String {
        switch self {
        case .none: return "None"
        case .noFirstSeparator: return "No First Separator"
        case .noLastSeparator: return "No Last Separator"
        case .noFirstAndLastSeparators: return "No First and Last Separators"
        case .rowEnclosingSeparators: return "Row-Enclosing Separators"
        }
    }
    
    func vListRowSeparatorType(isFirst: Bool) -> VListRowSeparatorType {
        switch self {
        case .none: return .none
        case .noFirstSeparator: return .noFirstSeparator()
        case .noLastSeparator: return .noLastSeparator()
        case .noFirstAndLastSeparators: return .noFirstAndLastSeparators(isFirst: isFirst)
        case .rowEnclosingSeparators: return .rowEnclosingSeparators(isFirst: isFirst)
        }
    }
}
