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
    
    private func sheeContent() -> some View {
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci.")
    }
}

// MARK:- Body
extension VSheetDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            VStack(content: {
                Spacer().frame(height: 10)
                
                ScrollView(content: {
                    sheet
                })
            })
                .background(VComponents.ColorBook.canvas)
        })
    }
    
    private var sheet: some View {
        VStack(content: {
            DemoRowView(type: .titled("Round All"), content: {
                VSheet(.roundAll(), content: sheeContent)
            })
            
            DemoRowView(type: .titled("Round Top"), content: {
                VSheet(.roundTop(), content: sheeContent)
            })
            
            DemoRowView(type: .titled("Round Bottom"), content: {
                VSheet(.roundBottom(), content: sheeContent)
            })
            
            DemoRowView(type: .titled("Round Custom"), content: {
                VSheet(.roundCustom(.init(layout: .init(corners: [.topLeft, .bottomRight]))), content: sheeContent)
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
