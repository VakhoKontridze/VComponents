//
//  DemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VComponents

// MARK:- Demo Rowed View
struct DemoView<Content, ControllerContent>: View
    where
        Content: View,
        ControllerContent: View
{
    // MARK: Properties
    private let demoType: DemoType
    enum DemoType {
        case rowed
        case section
        case freeform
    }
    
    private let controllerContent: ControllerContent?
    private let content: () -> Content
    
    private let sheetModel: VSheetModel = {
        var model: VSheetModel = .init()
        model.layout.contentMargin = 10
        return model
    }()
    
    // MARK: Initializers
    init(
        type demoType: DemoType = .rowed,
        controller controllerContent: ControllerContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.demoType = demoType
        self.controllerContent = controllerContent
        self.content = content
    }

    init(
        type demoType: DemoType = .rowed,
        @ViewBuilder content: @escaping () -> Content
    )
        where ControllerContent == Never
    {
        self.demoType = demoType
        self.controllerContent = nil
        self.content = content
    }
}

// MARK:- Body
extension DemoView {
    var body: some View {
        ZStack(content: {
            ColorBook.canvas.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20, content: {
                switch controllerContent {
                case nil: EmptyView()
                case let controllerContent?: controllerContent
                }
                
                switch demoType {
                case .rowed:
                    ScrollView(content: {
                        VSheet(model: sheetModel, content: content)
                            .padding(.trailing, 16)
                    })
                    
                case .section:
                    VSheet(content: {
                        content()
                            .frame(maxWidth: .infinity)
                    })
                        .frame(maxHeight: .infinity, alignment: .top)
                    
                case .freeform:
                    ScrollView(content: {
                        content()
                            .padding(.trailing, 16)
                    })
                }
            })
                .padding([.leading, .top, .bottom], 16)
        })
    }
}

// MARK:- Preview
struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView(content: {
            VPrimaryButtonDemoView()
        })
    }
}
