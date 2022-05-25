//
//  VToastDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VComponents

// MARK: - V Toast Demo View
struct VToastDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Toast" }
    
    @State private var isPresented: Bool = false
    
    @State private var presentationEdge: VToastModel.Layout.PresentationEdge = .default
    @State private var toastType: VToastTypeHelper = .oneLine
    @State private var title: String = "Lorem ipsum dolor sit ame"
    
    private var model: VToastModel {
        var model: VToastModel = .init()
        model.layout.presentationEdge = presentationEdge
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .vToast(
                model: model,
                type: toastType.toastType,
                isPresented: $isPresented,
                title: title
            )
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: $presentationEdge,
                headerTitle: "Presentation Edge"
            )
        })
        
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: $toastType,
                headerTitle: "Type",
                footerTitle: "In multi-line type, line limit and alignment can be set. For demo purposes, they are set to 5 and leading."
            )
            
            VTextField(text: $title)
        })
    }
}

// MARK: - Helpers
extension VToastModel.Layout.PresentationEdge: PickableTitledEnumeration {
    public var pickerTitle: String {
        switch self {
        case .top: return "Top"
        case .bottom: return "Bottom"
        }
    }
}

private enum VToastTypeHelper: Int, PickableTitledEnumeration {
    case oneLine
    case multiLine
    
    var pickerTitle: String {
        switch self {
        case .oneLine: return "Single-line"
        case .multiLine: return "Multi-line"
        }
    }
    
    var toastType: VToastType {
        switch self {
        case .oneLine: return .singleLine
        case .multiLine: return .multiLine(alignment: .leading, lineLimit: 5)
        }
    }
}

// MARK: - Preview
struct VToastDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VToastDemoView()
    }
}
