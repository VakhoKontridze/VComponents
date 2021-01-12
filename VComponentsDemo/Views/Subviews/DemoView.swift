//
//  DemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VComponents

// MARK:- Demo View Type
enum DemoViewType {
    case rowed
    case section
    case freeFormFlexible
    case freeFormFixed
}

// MARK:- Demo Rowed View
struct DemoView<Content, ControllerContent>: View
    where
        Content: View,
        ControllerContent: View
{
    // MARK: Properties
    private let viewType: DemoViewType
    
    private let controllerContent: ControllerContent?
    private let content: () -> Content
    
    private let sheetModel: VSheetModel = {
        var model: VSheetModel = .init()
        model.layout.contentMargin = 16
        return model
    }()
    
    // MARK: Initializers
    init(
        type viewType: DemoViewType,
        controller controllerContent: ControllerContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewType = viewType
        self.controllerContent = controllerContent
        self.content = content
    }

    init(
        type viewType: DemoViewType,
        @ViewBuilder content: @escaping () -> Content
    )
        where ControllerContent == Never
    {
        self.viewType = viewType
        self.controllerContent = nil
        self.content = content
    }
}

// MARK:- Body
extension DemoView {
    var body: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20, content: {
                switch controllerContent {
                case nil:
                    EmptyView()
                
                case let controllerContent?:
                    controllerContent
                        .padding(.trailing, 16)
                }
                
                switch viewType {
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
                        .padding(.trailing, 16)
                        .frame(maxHeight: .infinity, alignment: .top)
                    
                case .freeFormFlexible:
                    ScrollView(content: {
                        content()
                            .padding(.trailing, 16)
                    })
                    
                case .freeFormFixed:
                    content()
                        .padding(.trailing, 16)
                }
            })
                .padding([.leading, .top, .bottom], 16)
        })
    }
}

// MARK:- Preview
struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView(type: .rowed, content: {
            VPrimaryButtonDemoView()
        })
    }
}
