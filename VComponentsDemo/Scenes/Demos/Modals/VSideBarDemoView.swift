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
    static var navBarTitle: String { "Side Bar" }
    
    @State private var isPresented: Bool = false

    // MARK: Body
    var body: some View {
        DemoView(component: component)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VStack(spacing: 20, content: {
            VPlainButton(action: { isPresented = true }, title: "Present")
            
            VText(
                type: .multiLine(alignment: .center, limit: nil),
                color: ColorBook.secondary,
                font: .callout,
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
        VList(data: 0..<40, rowContent: { num in
            Text(String(num)) // FIXME: Scrolling is broken
                .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
}

// MARK: - Preview
struct VSideBarDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSideBarDemoView()
    }
}
