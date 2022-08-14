//
//  VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Side Bar
struct VSideBar<Content>: View where Content: View {
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let uiModel: VSideBarUIModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let content: () -> Content
    
    @State private var isInternallyPresented: Bool = false

    // MARK: Initializers
    init(
        uiModel: VSideBarUIModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.content = content
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            dimmingView
            sideBar
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: .all)
            .onAppear(perform: animateIn)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
            )
    }
    
    private var dimmingView: some View {
        uiModel.colors.dimmingView
            .ignoresSafeArea()
            .onTapGesture(perform: {
                if uiModel.misc.dismissType.contains(.backTap) { animateOut() }
            })
    }

    private var sideBar: some View {
        ZStack(content: {
            VSheet(uiModel: uiModel.sheetSubUIModel)
                .shadow(
                    color: uiModel.colors.shadow,
                    radius: uiModel.colors.shadowRadius,
                    x: uiModel.colors.shadowOffset.width,
                    y: uiModel.colors.shadowOffset.height
                )

            content()
                .padding(uiModel.layout.contentMargins)
                .safeAreaMarginInsets(edges: uiModel.layout.contentSafeAreaEdges)
        })
            .frame(size: uiModel.layout.sizes._current.size)
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.keyboard, edges: uiModel.layout.ignoredKeyboardSafeAreaEdges)
            .offset(isInternallyPresented ? presentedOffset : initialOffset)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged(dragChanged)
            )
    }

    // MARK: Actions
    private func animateIn() {
        withBasicAnimation(
            uiModel.animations.appear,
            body: { isInternallyPresented = true },
            completion: {
                DispatchQueue.main.async(execute: { presentHandler?() })
            }
        )
    }

    private func animateOut() {
        withBasicAnimation(
            uiModel.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    private func animateOutFromDrag() {
        withBasicAnimation(
            uiModel.animations.dragBackDismiss,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.dismiss()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }
    
    private func animateOutFromExternalDismiss() {
        withBasicAnimation(
            uiModel.animations.disappear,
            body: { isInternallyPresented = false },
            completion: {
                presentationMode.externalDismissCompletion()
                DispatchQueue.main.async(execute: { dismissHandler?() })
            }
        )
    }

    // MARK: Gestures
    private func dragChanged(dragValue: DragGesture.Value) {
        guard
            uiModel.misc.dismissType.contains(.dragBack),
            isDraggedInCorrectDirection(dragValue),
            didExceedDragBackDismissDistance(dragValue)
        else {
            return
        }
        
        animateOutFromDrag()
    }
    
    // MARK: Presentation Edge Offsets
    private var sheetScreenMargins: CGSize {
        .init(
            width: (UIScreen.main.bounds.size.width - uiModel.layout.sizes._current.size.width) / 2,
            height: (UIScreen.main.bounds.size.height - uiModel.layout.sizes._current.size.height) / 2
        )
    }
    
    private var initialOffset: CGSize {
        let x: CGFloat = {
            switch uiModel.layout.presentationEdge {
            case .left: return -uiModel.layout.sizes._current.size.width - sheetScreenMargins.width
            case .right: return UIScreen.main.bounds.size.width - sheetScreenMargins.width
            case .top: return 0
            case .bottom: return 0
            }
        }()
        
        let y: CGFloat = {
            switch uiModel.layout.presentationEdge {
            case .left: return 0
            case .right: return 0
            case .top: return -uiModel.layout.sizes._current.size.height - sheetScreenMargins.height
            case .bottom: return UIScreen.main.bounds.size.height - sheetScreenMargins.height
            }
        }()
        
        return .init(width: x, height: y)
    }
    
    private var presentedOffset: CGSize {
        let x: CGFloat = {
            switch uiModel.layout.presentationEdge {
            case .left: return -sheetScreenMargins.width
            case .right: return sheetScreenMargins.width
            case .top: return 0
            case .bottom: return 0
            }
        }()
        
        let y: CGFloat = {
            switch uiModel.layout.presentationEdge {
            case .left: return 0
            case .right: return 0
            case .top: return -sheetScreenMargins.height
            case .bottom: return sheetScreenMargins.height
            }
        }()
        
        return .init(width: x, height: y)
    }
    
    // MARK: Presentation Edge Dismiss
    private func isDraggedInCorrectDirection(_ dragValue: DragGesture.Value) -> Bool {
        switch uiModel.layout.presentationEdge {
        case .left: return dragValue.translation.width <= 0
        case .right: return dragValue.translation.width >= 0
        case .top: return dragValue.translation.height <= 0
        case .bottom: return dragValue.translation.height >= 0
        }
    }
    
    private func didExceedDragBackDismissDistance(_ dragValue: DragGesture.Value) -> Bool {
        switch uiModel.layout.presentationEdge {
        case .left, .right: return abs(dragValue.translation.width) >= uiModel.layout.dragBackDismissDistance
        case .top, .bottom: return abs(dragValue.translation.height) >= uiModel.layout.dragBackDismissDistance
        }
    }
}

// MARK: - Preview
struct VSideBar_Previews: PreviewProvider {
    @State static var isPresented: Bool = true

    static var previews: some View {
        VPlainButton(
            action: { /*isPresented = true*/ },
            title: "Present"
        )
            .vSideBar(
                id: "side_bar_preview",
                isPresented: $isPresented,
                content: {
                    VList(
                        uiModel: {
                            var uiModel: VListUIModel = .init()
                            uiModel.layout.showsFirstSeparator = false
                            uiModel.layout.showsLastSeparator = false
                            return uiModel
                        }(),
                        data: 0..<20,
                        content: { num in
                            Text(String(num))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    )
                }
            )
    }
}
