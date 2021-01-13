//
//  VModalDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/30/20.
//

import SwiftUI
import VComponents

// MARK:- V Modal Demo View
struct VModalDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Modal"
    
    @State private var titlePosition: VModalModel.Layout.VModalTitlePosition
    @State private var closeButtonPosition: VModalModel.Layout.VModalCloseButtonPosition
    
    @State private var isPresented: Bool = false
    
    private var modalModel: VModalModel {
        var model: VModalModel = .init()
        
        model.layout.titlePosition = titlePosition
        model.layout.closeButtonPosition = closeButtonPosition
        
        return model
    }
    
    // MARK: Initializers
    init() {
        let modalLayout: VModalModel.Layout = .init()
        
        self._titlePosition = State(initialValue: modalLayout.titlePosition)
        self._closeButtonPosition = State(initialValue: modalLayout.closeButtonPosition)
    }
}

// MARK:- Body
extension VModalDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .section, content: {
                VStack(spacing: 20, content: {
                    VSegmentedPicker(selection: $titlePosition, title: "Title Position")
                    VSegmentedPicker(selection: $closeButtonPosition, title: "Close Button Position")
                    
                    VSecondaryButton(action: { isPresented = true }, title: "Demo Modal")
                })
            })
        })
            .vModal(isPresented: $isPresented, modal: {
                VModal(model: modalModel, title: { VModalDefaultTitle(title: "Lorem ipsum dolor sit amet") }, content: {
                    ZStack(content: {
                        Color.red.opacity(0.5)
                        
                        if closeButtonPosition == .none {
                            VStack(content: {
                                VBaseTitle(
                                    title: "When close button is \"none\", Modal can only be dismissed programatically",
                                    color: ColorBook.primary,
                                    font: .system(size: 14, weight: .semibold, design: .default),
                                    type: .multiLine(limit: nil, alignment: .center)
                                )
                                
                                VSecondaryButton(action: { isPresented = false }, title: "Dismiss")
                            })
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding(16)
                        }
                    })
                })
            })
    }
}

// MARK:- Helpers
extension VModalModel.Layout.VModalTitlePosition: VPickerTitledEnumerableOption {
    public var pickerTitle: String {
        switch self {
        case .leading: return "Leading"
        case .center: return "Center"
        }
    }
}

extension VModalModel.Layout.VModalCloseButtonPosition: VPickerTitledEnumerableOption {
    public var pickerTitle: String {
        switch self {
        case .none: return "None"
        case .leading: return "Leading"
        case .trailing: return "Trailing"
        case .backTap: return "Back Tap"
        }
    }
}

// MARK:- Preview
struct VModalDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VModalDemoView()
    }
}
