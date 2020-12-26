//
//  VSideBarStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Side Bar Standard
struct VSideBarStandard<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSideBarStandardModel
    @Binding private var isPresented: Bool
    private let dismiss: () -> Void
    private let content: Content

    // MARK: Initializers
    init(
        model: VSideBarStandardModel,
        isPresented: Binding<Bool>,
        dismiss: @escaping () -> Void,
        content: Content
    ) {
        self.model = model
        self._isPresented = isPresented
        self.dismiss = dismiss
        self.content = content
    }
}

// MARK:- Body
extension VSideBarStandard {
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
            VSheet(.roundCustom(model.sheetModel))
                .edgesIgnoringSafeArea(.vertical)

            content
                .padding(.leading, model.layout.contentMargin.leading)
                .padding(.trailing, model.layout.contentMargin.trailing)
                .padding(.top, model.layout.contentMargin.top)
                .padding(.bottom, model.layout.contentMargin.bottom)
        })
            .frame(width: model.layout._width)
    }

}

// MARK:- Preview
struct VSideBarStandard_Previews: PreviewProvider {
    static var previews: some View {
        Color.red.edgesIgnoringSafeArea(.all)
            .overlay(VSideBarStandard(model: .init(), isPresented: .constant(true), dismiss: {}, content: Color.blue))
    }
}
