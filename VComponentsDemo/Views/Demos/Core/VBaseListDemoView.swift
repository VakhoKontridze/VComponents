//
//  VBaseListDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VComponents

// MARK:- V Bas List Demo View
struct VBaseListDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Base List"
    
    @State private var rowCount: Int = 5
    
    @State private var form: Form = .fixed
    
    enum Form: Int, VPickerTitledEnumerableOption {
        case fixed
        case flexible
        case constrained
        
        fileprivate var layoutType: VBaseListLayoutType {
            switch self {
            case .fixed: return .fixed
            case .flexible: return .flexible
            case .constrained: return .flexible
            }
        }
        
        var demoViewType: DemoViewType {
            switch self {
            case .fixed: return .freeFormFlexible
            case .flexible: return .freeFormFixed
            case .constrained: return .freeFormFixed
            }
        }
        
        var pickerTitle: String {
            switch self {
            case .fixed: return "Fixed"
            case .flexible: return "Flexible"
            case .constrained: return "Constrained"
            }
        }
        
        var subtitle: String {
            switch self {
            case .fixed: return "Content would stretch to take required vertical space"
            case .flexible: return "Content would stretch vertically to occupy maximum space"
            case .constrained: return "Content would be limited in vertical space by applying frame modifier"
            }
        }
        
        var height: CGFloat? {
            switch self {
            case .fixed: return nil
            case .flexible: return nil
            case .constrained: return 500
            }
        }
    }
    
    // Copied and modifier from VSection's preview
    private struct Row: Identifiable {
        let id: Int
        let color: Color
        let title: String
    }
    
    private var rows: [Row] {
        (0..<rowCount).map { i in
            .init(
                id: i,
                color: [.red, .green, .blue][i % 3],
                title: spellOut(i + 1)
            )
        }
    }
    
    private func spellOut(_ i: Int) -> String {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .spellOut
        return formatter.string(from: .init(value: i))?.capitalized ?? ""
    }
    
    private func rowContent(title: String, color: Color) -> some View {
        HStack(spacing: 10, content: {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(color.opacity(0.8))
                .frame(dimension: 32)

            VBaseTitle(
                title: title,
                color: ColorBook.primary,
                font: .body,
                type: .oneLine
            )
        })
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK:- Body
extension VBaseListDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: form.demoViewType, controller: controller, content: {
                VBaseList(
                    layout: form.layoutType,
                    data: rows,
                    content: { rowContent(title: $0.title, color: $0.color) }
                )
                    .frame(height: form.height)
            })
        })
    }
    
    private var controller: some View {
        VStack(spacing: 20, content: {
            Stepper("Rows", value: $rowCount, in: 0...20)
            
            VSegmentedPicker(
                selection: $form,
                title: "Section Height",
                subtitle: form.subtitle
            )
                .frame(height: 90, alignment: .top)
        })
    }
}

// MARK:- Preview
struct VBaseListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseListDemoView()
    }
}
