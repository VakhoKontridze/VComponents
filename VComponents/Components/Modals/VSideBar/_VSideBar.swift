//
//  _VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- _ V Side Bar
struct _VSideBar<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSideBarModel
    
    @Binding private var isPresented: Bool
    
    private let content: () -> Content
    
    private let appearAction: (() -> Void)?
    private let disappearAction: (() -> Void)?

    // MARK: Initializers
    init(
        isPresented: Binding<Bool>,
        sideBar: VSideBar<Content>
    ) {
        self.init(
            model: sideBar.model,
            isPresented: isPresented,
            content: sideBar.content,
            onAppear: sideBar.appearAction,
            onDisappear: sideBar.disappearAction
        )
    }
    
    private init(
        model: VSideBarModel,
        isPresented: Binding<Bool>,
        content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)?,
        onDisappear disappearAction: (() -> Void)?
    ) {
        self.model = model
        self._isPresented = isPresented
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Body
extension _VSideBar {
    var body: some View {
        ZStack(content: {
            VSheet(model: model.sheetSubModel)
                .edgesIgnoringSafeArea(.vertical)

            content()
                .padding(.leading, model.layout.contentMargin.leading)
                .padding(.trailing, model.layout.contentMargin.trailing)
                .padding(.top, model.layout.contentMargin.top)
                .padding(.bottom, model.layout.contentMargin.bottom)
        })
            .frame(width: model.layout.width)
            .onAppear(perform: appearAction)
            .onDisappear(perform: disappearAction)
            .addSideBarSwipeGesture(completion: dismiss)
    }
}

// MARK:- Actions
private extension _VSideBar {
    func dismiss() {
        withAnimation { isPresented = false }
    }
}

// MARK:- Preview
struct VSideBar_Previews: PreviewProvider {
    static var previews: some View {
        Color.red.edgesIgnoringSafeArea(.all)
            .vSideBar(isPresented: .constant(true), sideBar: {
                VSideBar(content: {
                    ColorBook.accent
                })
            })
    }
}
