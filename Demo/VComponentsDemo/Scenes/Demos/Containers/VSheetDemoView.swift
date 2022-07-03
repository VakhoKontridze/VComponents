//
//  VSheetDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Sheet Demo View
struct VSheetDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Sheet" }
    
    @State private var roundedCorners: VSheetRoundedCorners = VSheetUIModel.Layout().roundedCorners.sheetRoundedCorners

    private var uiModel: VSheetUIModel {
        var uiModel: VSheetUIModel = .init()
        
        uiModel.layout.roundedCorners = roundedCorners.roundedCorner
        
        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(hasLayer: false, component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VSheet(uiModel: uiModel, content: {
            VText(
                type: .multiLine(alignment: .center, lineLimit: nil),
                color: ColorBook.primary,
                font: .body,
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci."
            )
        })
    }
    
    @ViewBuilder private func settings() -> some View {
        VWheelPicker(selection: $roundedCorners, headerTitle: "Rounded Corners")
    }
}

// MARK: - Helpers
private enum VSheetRoundedCorners: Int, StringRepresentableHashableEnumeration {
    case all
    case top
    case bottom
    case custom
    case none
    
    var stringRepresentation: String {
        switch self {
        case .all: return "All"
        case .top: return "Top"
        case .bottom: return "Bottom"
        case .custom: return "Custom"
        case .none: return "None"
        }
    }
    
    var roundedCorner: UIRectCorner {
        switch self {
        case .all: return .allCorners
        case .top: return [.topLeft, .topRight]
        case .bottom: return [.bottomLeft, .bottomRight]
        case .custom: return [.topLeft, .bottomRight]
        case .none: return []
        }
    }
}

extension UIRectCorner {
    fileprivate var sheetRoundedCorners: VSheetRoundedCorners {
        switch self {
        case .allCorners: return .all
        case [.topLeft, .topRight]: return .top
        case [.bottomLeft, .bottomRight]: return .bottom
        case [.topLeft, .bottomRight]: return .custom
        case []: return .none
        default: fatalError()
        }
    }
}

// MARK: - Preview
struct VSheetDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSheetDemoView()
    }
}
