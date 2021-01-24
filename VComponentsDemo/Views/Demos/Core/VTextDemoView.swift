//
//  VTextDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VComponents

// MARK:- V Text Demo View
struct VTextDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Base Title"
    
    @State private var vTextDemoType: VTextDemoType = .center
    
    private let baseTextTitle: String = "Lorem ipsum dolor sit amet"
    private let baseTextText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci."
    
    private let titleColor: Color = ColorBook.primary
    private let titleFont: Font = .system(size: 16, weight: .semibold, design: .default)
    private let textFont: Font = .system(size: 14, weight: .regular, design: .default)
}

// MARK:- Body
extension VTextDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch vTextDemoType {
        case .leading:
            VText(type: .oneLine, font: titleFont, color: titleColor, title: baseTextTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
        
        case .center:
            VText(type: .oneLine, font: titleFont, color: titleColor, title: baseTextTitle)
                .frame(maxWidth: .infinity, alignment: .center)
        
        case .trailing:
            VText(type: .oneLine, font: titleFont, color: titleColor, title: baseTextTitle)
                .frame(maxWidth: .infinity, alignment: .trailing)
        
        case .multiLineLeading:
            VText(type: .multiLine(limit: nil, alignment: .leading), font: titleFont, color: titleColor, title: baseTextText)
            
        case .multiLineCenter:
            VText(type: .multiLine(limit: nil, alignment: .center), font: titleFont, color: titleColor, title: baseTextText)
            
        case .multiLineTrailing:
            VText(type: .multiLine(limit: nil, alignment: .trailing), font: titleFont, color: titleColor, title: baseTextText)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VWheelPicker(
            selection: $vTextDemoType,
            header: "Type",
            footer: "Not an actual type of the component. Just different configurations listed for demo purposes."
        )
    }
}

// MARK:- Helpers
private enum VTextDemoType: Int, VPickableTitledItem {
    case leading
    case center
    case trailing
    case multiLineLeading
    case multiLineCenter
    case multiLineTrailing
    
    var pickerTitle: String {
        switch self {
        case .leading: return "Leading"
        case .center: return "Center"
        case .trailing: return "Trailing"
        case .multiLineLeading: return "Multi-Line Leading"
        case .multiLineCenter: return "Multi-Line Center"
        case .multiLineTrailing: return "Multi-Line Trailing"
        }
    }
}

// MARK:- Preview
struct VTextDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTextDemoView()
    }
}
