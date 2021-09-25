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
    static let navBarTitle: String = "Toast"
    
    @State private var isPresented: Bool = false
    
    @State private var presentationEdge: VToastModel.Layout.PresentationEdge = .default
    @State private var toastType: VToastTypeHelper = .oneLine
    @State private var title: String = "Lorem ipsum"
    
    private var model: VToastModel {
        var model: VToastModel = .init()
        model.layout.presentationEdge = presentationEdge
        return model
    }
}

// MARK: - Body
extension VToastDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settingsSections: settings)
        })
    }
    
    private func component() -> some View {
        VSecondaryButton(action: { isPresented = true }, title: "Present")
            .vToast(isPresented: $isPresented, toast: {
                VToast(
                    model: model,
                    type: toastType.toastType,
                    title: title
                )
            })
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
extension VToastModel.Layout.PresentationEdge: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .top: return "Top"
        case .bottom: return "Bottom"
        @unknown default: fatalError()
        }
    }
}

private enum VToastTypeHelper: Int, VPickableTitledItem {
    case oneLine
    case multiLine
    
    var pickerTitle: String {
        switch self {
        case .oneLine: return "One Line"
        case .multiLine: return "Multi Line"
        }
    }
    
    var toastType: VToastType {
        switch self {
        case .oneLine: return .oneLine
        case .multiLine: return .multiLine(limit: 5, alignment: .leading)
        }
    }
}

extension VToastType {
    fileprivate var helperType: VToastTypeHelper {
        switch self {
        case .oneLine: return .oneLine
        case .multiLine: return .multiLine
        @unknown default: fatalError()
        }
    }
}

// MARK: - Preview
struct VToastDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VToastDemoView()
    }
}
