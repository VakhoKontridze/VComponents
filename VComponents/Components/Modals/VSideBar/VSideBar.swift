//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Side Bar
struct VSideBar<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSideBarModel
    @Binding private var isPresented: Bool
    private let dismissAction: (() -> Void)?
    private let content: () -> Content

    // MARK: Initializers
    init(
        model: VSideBarModel,
        isPresented: Binding<Bool>,
        onDismiss dismissAction: (() -> Void)?,
        content: @escaping () -> Content
    ) {
        self.model = model
        self._isPresented = isPresented
        self.dismissAction = dismissAction
        self.content = content
    }
}

// MARK:- Body
extension VSideBar {
    var body: some View {
        ZStack(alignment: .leading, content: {
            blinding
            sideBarContent
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(isPresented ? 1 : 0)
            .offset(
                x: isPresented ? 0 : -UIScreen.main.bounds.width,
                y: 0
            )
            .addSideBarSwipeGesture(completion: dismiss)
    }

    @ViewBuilder private var blinding: some View {
        if isPresented {
            model.colors.blinding
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: dismiss)
        }
    }

    private var sideBarContent: some View {
        ZStack(content: {
            VSheet(model: model.sheetModel)
                .edgesIgnoringSafeArea(.vertical)

            content()
                .padding(.leading, model.layout.contentMargin.leading)
                .padding(.trailing, model.layout.contentMargin.trailing)
                .padding(.top, model.layout.contentMargin.top)
                .padding(.bottom, model.layout.contentMargin.bottom)
        })
            .frame(width: model.layout.width.value)
    }

}

// MARK:- Actions
private extension VSideBar {
    func dismiss() {
        dismissAction?()
        withAnimation { isPresented = false }
    }
}

// MARK:- Preview
struct VSideBar_Previews: PreviewProvider {
    static var previews: some View {
        Color.red.edgesIgnoringSafeArea(.all)
            .vSideBar(isPresented: .constant(true), content: { Color.blue })
    }
}
