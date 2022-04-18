//
//  _VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - _ V Side Bar
struct _VSideBar<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSideBarModel
    
    @Binding private var isHCPresented: Bool
    @State private var isViewPresented: Bool = false
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        model: VSideBarModel,
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) {
        self.model = model
        self._isHCPresented = isPresented
        self.content = content
    }

    // MARK: Body
    var body: some View {
        ZStack(alignment: .leading, content: {
            blinding
            sideBarView
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: animateIn)
    }
    
    private var blinding: some View {
        model.colors.blinding
            .edgesIgnoringSafeArea(.all)
            .onTapGesture(perform: animateOut)
    }
    
    private var sideBarView: some View {
        ZStack(content: {
            VSheet(model: model.sheetSubModel)
                .edgesIgnoringSafeArea(.all)

            content()
                .padding(.leading, model.layout.contentMargins.leading)
                .padding(.trailing, model.layout.contentMargins.trailing)
                .padding(.top, model.layout.contentMargins.top)
                .padding(.bottom, model.layout.contentMargins.bottom)
                .edgesIgnoringSafeArea(edgesToIgnore)
        })
            .frame(width: model.layout.width)
            .offset(x: isViewPresented ? 0 : -model.layout.width)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged(dragChanged)
            )
    }

    // MARK: Actions
    private func animateIn() {
        withAnimation(model.animations.appear?.asSwiftUIAnimation, { isViewPresented = true })
    }
    
    private func animateOut() {
        withAnimation(model.animations.disappear?.asSwiftUIAnimation, { isViewPresented = false })
        DispatchQueue.main.asyncAfter(deadline: .now() + (model.animations.disappear?.duration ?? 0), execute: { isHCPresented = false })
    }

    // MARK: Gestures
    private func dragChanged(drag: DragGesture.Value) {
        let isDraggedLeft: Bool = drag.translation.width <= 0
        guard isDraggedLeft else { return }
        
        guard abs(drag.translation.width) >= model.layout.translationToDismiss else { return }
        
        animateOut()
    }
    
    // MARK: Helpers
    private var edgesToIgnore: Edge.Set {
        switch (model.layout.hasSafeAreaMarginTop, model.layout.hasSafeAreaMarginBottom) {
        case (false, false): return [.top, .bottom]
        case (false, true): return .top
        case (true, false): return .bottom
        case (true, true): return []
        }
    }
}

// MARK: - Preview
struct VSideBar_Previews: PreviewProvider {
    static var previews: some View {
        _VSideBar(
            model: .init(),
            isPresented: .constant(true),
            content: { ColorBook.accent }
        )
    }
}
