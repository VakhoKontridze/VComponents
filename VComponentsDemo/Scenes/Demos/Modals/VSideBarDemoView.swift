//
//  VSideBarDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VComponents

// MARK: - V Side Bar Demo View
struct VSideBarDemoView: View {
    static let navBarTitle: String = "Side Bar"
    
    @State private var isPresented: Bool = false
}

// MARK: - Body
extension VSideBarDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, leadingItem: sidBarIcon, content: {
            DemoView(component: component)
        })
    }
    
    private func component() -> some View {
        VStack(spacing: 20, content: {
            VSecondaryButton(action: { isPresented = true }, title: "Present")
            
            VText(
                type: .multiLine(limit: nil, alignment: .center),
                font: .callout,
                color: ColorBook.secondary,
                title: "Alternately, you can open Side Bar by tapping on a button in the navigation bar"
            )
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
        VLazyScrollView(type: .vertical(), range: 1..<11, content: { num in
            VText(
                type: .oneLine,
                font: .body,
                color: ColorBook.primaryInverted,
                title: "\(num)"
            )
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background(ColorBook.accent.opacity(0.75))
                .cornerRadius(5)
                .padding(.vertical, 3)
        })
    }
}

// MARK: - Preview
struct VSideBarDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSideBarDemoView()
    }
}
