//
//  VSheetDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK: - V Sheet Demo View
struct VSheetDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Sheet" }
    
    @State private var roundedCorners: VSheetRoundedCornersHelper = VSheetModel.Layout.RoundedCorners.default.helperType

    private var model: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.roundedCorners = roundedCorners.roundedCorner
        
        return model
    }

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(hasLayer: false, component: component, settings: settings)
        })
    }
    
    private func component() -> some View {
        VSheet(model: model, content: {
            VText(
                type: .multiLine(alignment: .center, limit: nil),
                color: ColorBook.primary,
                font: .body,
                title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci."
            )
        })
    }
    
    @ViewBuilder private func settings() -> some View {
        VWheelPicker(selection: $roundedCorners, headerTitle: "Rounded Corners")
    }
}

// MARK: - Helpers
private enum VSheetRoundedCornersHelper: Int, VPickableTitledItem {
    case all
    case top
    case bottom
    case custom
    case none
    
    var pickerTitle: String {
        switch self {
        case .all: return "All"
        case .top: return "Top"
        case .bottom: return "Bottom"
        case .custom: return "Custom"
        case .none: return "None"
        }
    }
    
    var roundedCorner: VSheetModel.Layout.RoundedCorners {
        switch self {
        case .all: return .all
        case .top: return .top
        case .bottom: return .bottom
        case .custom: return .custom([.topLeft, .bottomRight])
        case .none: return .none
        }
    }
}

extension VSheetModel.Layout.RoundedCorners {
    fileprivate var helperType: VSheetRoundedCornersHelper {
        switch self {
        case .all: return .all
        case .top: return .top
        case .bottom: return .bottom
        case .custom: return .custom
        case .none: return .none
        @unknown default: fatalError()
        }
    }
}

// MARK: - Preview
struct VSheetDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSheetDemoView()
    }
}
