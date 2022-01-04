//
//  VTextDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VComponents

// MARK: - V Text Demo View
struct VTextDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Text" }
    
    @State private var vTextDemoType: VTextDemoType = .center
    
    private let baseTextTitle: String = "Lorem ipsum dolor sit amet"
    private let baseTextText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci."
    
    private let titleColor: Color = ColorBook.primary
    private let titleFont: Font = .system(size: 16, weight: .semibold)
    private let textFont: Font = .system(size: 14)

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch vTextDemoType {
        case .center:
            VText(color: titleColor, font: titleFont, title: baseTextTitle)
                .frame(maxWidth: .infinity, alignment: .center)
        
        case .leading:
            VText(color: titleColor, font: titleFont, title: baseTextTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
        
        case .trailing:
            VText(color: titleColor, font: titleFont, title: baseTextTitle)
                .frame(maxWidth: .infinity, alignment: .trailing)
        
        case .multiLineCenter:
            VText(type: .multiLine(alignment: .center, limit: nil), color: titleColor, font: titleFont, title: baseTextText)
            
        case .multiLineLeading:
            VText(type: .multiLine(alignment: .leading, limit: nil), color: titleColor, font: titleFont, title: baseTextText)
            
        case .multiLineTrailing:
            VText(type: .multiLine(alignment: .trailing, limit: nil), color: titleColor, font: titleFont, title: baseTextText)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VWheelPicker(
            selection: $vTextDemoType,
            headerTitle: "Type",
            footerTitle: "Not an actual type of the component. Just different configurations listed for demo purposes."
        )
    }
}

// MARK: - Helpers
private enum VTextDemoType: Int, VPickableTitledItem {
    case center
    case leading
    case trailing
    case multiLineCenter
    case multiLineLeading
    case multiLineTrailing
    
    var pickerTitle: String {
        switch self {
        case .center: return "Center"
        case .leading: return "Leading"
        case .trailing: return "Trailing"
        case .multiLineCenter: return "Multi-Line Center"
        case .multiLineLeading: return "Multi-Line Leading"
        case .multiLineTrailing: return "Multi-Line Trailing"
        }
    }
}

// MARK: - Preview
struct VTextDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTextDemoView()
    }
}
