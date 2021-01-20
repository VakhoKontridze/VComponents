//
//  VTextDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI
import VComponents

// MARK:- V Text Demo View
struct VTextDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Base Title"
    
    private let baseTextTitle: String = "Lorem ipsum dolor sit amet"
    private let baseTextText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci."
    
    private let titleColor: Color = ColorBook.primary
    private let titleFont: Font = .system(size: 16, weight: .semibold, design: .default)
    private let textFont: Font = .system(size: 14, weight: .regular, design: .default)
}

// MARK:- Body
extension VTextDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .rowed, content: {
                DemoRowView(type: .titled("Leading"), content: {
                    VText(title: baseTextTitle, color: titleColor, font: titleFont, type: .oneLine)
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                
                DemoRowView(type: .titled("Centered"), content: {
                    VText(title: baseTextTitle, color: titleColor, font: titleFont, type: .oneLine)
                        .frame(maxWidth: .infinity, alignment: .center)
                })
                
                DemoRowView(type: .titled("Trailing"), content: {
                    VText(title: baseTextTitle, color: titleColor, font: titleFont, type: .oneLine)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                })
                
                DemoRowView(type: .titled("Multi-Line"), content: {
                    VText(title: baseTextText, color: titleColor, font: textFont, type: .multiLine(limit: 5, alignment: .leading))
                })
            })
        })
    }
}

// MARK:- Preview
struct VTextDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VTextDemoView()
    }
}
