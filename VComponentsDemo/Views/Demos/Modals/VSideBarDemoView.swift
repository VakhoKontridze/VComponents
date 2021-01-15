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
    // MARK: Properties
    static let navigationBarTitle: String = "Side Bar"
}

// MARK:- Body
extension VSideBarDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(type: .section, content: {
                VStack(spacing: 20, content: {
                    VBaseTitle(
                        title: "Side Bar should only ever be used on a root view. Continue?",
                        color: ColorBook.primary,
                        font: .body,
                        type: .multiLine(limit: nil, alignment: .center)
                    )
                        .padding(20)
                    
                    VSecondaryButton(
                        action: { SceneDelegate.setRootView(to: VSideBarWalkthroughView()) },
                        title: "Start Demo"
                    )
                })
            })
        })
    }
}

// MARK:- V Side Bar Walkthrough View
private struct VSideBarWalkthroughView: View {
    static let navigationBarTitle: String = ""
    @State private var isPresented: Bool = false
}

private extension VSideBarWalkthroughView {
    var body: some View {
        VNavigationView(content: {
            VBaseView(title: Self.navigationBarTitle, leadingItem: sidBarIcon, content: {
                ZStack(content: {
                    Color.pink
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)

                    VBaseTitle(
                        title: "You can open Side Bar by tapping on a button in the navigation bar",
                        color: ColorBook.primary,
                        font: .body,
                        type: .multiLine(limit: nil, alignment: .center)
                    )
                        .padding(20)

                    VSecondaryButton(
                        action: { SceneDelegate.setRootView(to: HomeView()) },
                        title: "Go Back"
                    )
                        .frame(maxHeight: .infinity, alignment: .bottom)
                })
                    .background(ColorBook.canvas.edgesIgnoringSafeArea(.bottom))
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
