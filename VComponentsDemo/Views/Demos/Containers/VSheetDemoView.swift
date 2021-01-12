//
//  VSheetDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI
import VComponents

// MARK:- V Sheet Demo View
struct VSheetDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Sheet"
    
    private func sheetContent() -> some View {
        VBaseTitle(
            title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci.",
            color: ColorBook.primaryInverted,
            font: .body,
            type: .oneLine
        )
    }
    
    private func model(roundedCorners: VSheetModel.Layout.RoundedCorners) -> VSheetModel {
        var model: VSheetModel = .init()
        model.layout.roundedCorners = roundedCorners
        return model
    }
}

// MARK:- Body
extension VSheetDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .freeFormFlexible, content: {
                DemoRowView(type: .titled("Round All"), content: {
                    VSheet(model: model(roundedCorners: .all), content: sheetContent)
                })
                
                DemoRowView(type: .titled("Round Top"), content: {
                    VSheet(model: model(roundedCorners: .top), content: sheetContent)
                })
                
                DemoRowView(type: .titled("Round Bottom"), content: {
                    VSheet(model: model(roundedCorners: .bottom), content: sheetContent)
                })
                
                DemoRowView(type: .titled("Round Custom"), content: {
                    VSheet(model: model(roundedCorners: .custom([.topLeft, .bottomRight])), content: sheetContent)
                })
            })
        })
    }
}

// MARK:- Preview
struct VSheetDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSheetDemoView()
    }
}
