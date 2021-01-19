//
//  VSideBarDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VComponents

// MARK:- V Side Bar Demo View
struct VSideBarDemoView: View {
    static let navigationBarTitle: String = "Side Bar"
    
    @State private var isPresented: Bool = false
}

// MARK:- Body
extension VSideBarDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, leadingItem: sidBarIcon, content: {
            ZStack(content: {
                ColorBook.canvas.edgesIgnoringSafeArea(.all)
                
                VSheet()
            })
        })
            .vSideBar(isPresented: $isPresented, sideBar: {
                VSideBar(content: { sideBarContent })
            })
    }
    
    private func sidBarIcon() -> some View {
        Button(action: { withAnimation { isPresented = true } }, label: {
            Image(systemName: "sidebar.left")
                .foregroundColor(ColorBook.primary)
        })
    }
    
    private var sideBarContent: some View {
        VLazyList(model: .vertical(), range: 1..<11, content: { num in
            VBaseTitle(
                title: "\(num)",
                color: ColorBook.primaryInverted,
                font: .body,
                type: .oneLine
            )
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(ColorBook.accent.opacity(0.75))
                .cornerRadius(5)
                .padding(.vertical, 3)
        })
    }
}

// MARK:- Preview
struct VSideBarDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSideBarDemoView()
    }
}
