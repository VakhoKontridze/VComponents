//
//  VTextDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Text Demo View
struct VTextDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Text" }
    
    @State private var vTextDemoType: VTextDemoType = .center
    
    private let singleLineText: String = "Lorem ipsum dolor sit amet"
    private let multiLineText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci."
    
    private let titleColor: Color = ColorBook.primary
    private let titleFont: Font = .system(size: 16, weight: .semibold)
    private let textFont: Font = .system(size: 14)

    // MARK: Body
    var body: some View {
        DemoView(hasLayer: false, component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VSheet(content: {
            switch vTextDemoType {
            case .center:
                VText(
                    color: titleColor,
                    font: titleFont,
                    text: singleLineText
                )
                    .frame(maxWidth: .infinity, alignment: .center)
            
            case .leading:
                VText(
                    color: titleColor,
                    font: titleFont,
                    text: singleLineText
                )
                    .frame(maxWidth: .infinity, alignment: .leading)
            
            case .trailing:
                VText(
                    color: titleColor,
                    font: titleFont,
                    text: singleLineText
                )
                    .frame(maxWidth: .infinity, alignment: .trailing)
            
            case .multiLineCenter:
                VText(
                    type: .multiLine(alignment: .center, lineLimit: nil),
                    color: titleColor,
                    font: titleFont,
                    text: multiLineText
                )
                
            case .multiLineLeading:
                VText(
                    type: .multiLine(alignment: .leading, lineLimit: nil),
                    color: titleColor,
                    font: titleFont,
                    text: multiLineText
                )
                
            case .multiLineTrailing:
                VText(
                    type: .multiLine(alignment: .trailing, lineLimit: nil),
                    color: titleColor,
                    font: titleFont,
                    text: multiLineText
                )
            
            case .multiLineSpaceReserved:
                VText(
                    type: .multiLine(alignment: .center, lineLimit: 20, reservesSpace: true),
                    color: titleColor,
                    font: titleFont,
                    text: multiLineText
                )
                
            case .multiLinePartialRangeFrom:
                VText(
                    type: .multiLine(alignment: .center, lineLimit: 10...),
                    color: titleColor,
                    font: titleFont,
                    text: multiLineText
                )
                
            case .multiLinePartialRangeThrough:
                VText(
                    type: .multiLine(alignment: .center, lineLimit: ...20),
                    color: titleColor,
                    font: titleFont,
                    text: multiLineText
                )
                
            case .multiLineClosedRange:
                VText(
                    type: .multiLine(alignment: .center, lineLimit: 10...20),
                    color: titleColor,
                    font: titleFont,
                    text: multiLineText
                )
            }
        })
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
private enum VTextDemoType: Int, StringRepresentableHashableEnumeration {
    case center
    case leading
    case trailing
    case multiLineCenter
    case multiLineLeading
    case multiLineTrailing
    case multiLineSpaceReserved
    case multiLinePartialRangeFrom
    case multiLinePartialRangeThrough
    case multiLineClosedRange
    
    var stringRepresentation: String {
        switch self {
        case .center: return "Center"
        case .leading: return "Leading"
        case .trailing: return "Trailing"
        case .multiLineCenter: return "Multi-Line Center"
        case .multiLineLeading: return "Multi-Line Leading"
        case .multiLineTrailing: return "Multi-Line Trailing"
        case .multiLineSpaceReserved: return "Multi-Line Space-Reserved"
        case .multiLinePartialRangeFrom: return "Multi-Line Partial Range (From)"
        case .multiLinePartialRangeThrough: return "Multi-Line Partial Range (Through)"
        case .multiLineClosedRange: return "Multi-Line Closed Range"
        }
    }
}

// MARK: - Preview
struct VTextDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTextDemoView()
    }
}
