//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - V Toast
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable) // No `View.presentationHost(...)` support
@available(tvOS 14.0, *)@available(tvOS, unavailable) // No `View.presentationHost(...)` support
@available(watchOS 7.0, *)@available(watchOS, unavailable) // No `View.presentationHost(...)` support
struct VToast: View {
    // MARK: Properties
    @Environment(\.presentationHostPresentationMode) private var presentationMode: PresentationHostPresentationMode
    @StateObject private var interfaceOrientationChangeObserver: InterfaceOrientationChangeObserver = .init()
    
    private let uiModel: VToastUIModel
    
    private let presentHandler: (() -> Void)?
    private let dismissHandler: (() -> Void)?
    
    private let text: String
    
    @State private var isInternallyPresented: Bool = false
    
    @State private var height: CGFloat = 0
    
    // MARK: Initializers
    init(
        uiModel: VToastUIModel,
        onPresent presentHandler: (() -> Void)?,
        onDismiss dismissHandler: (() -> Void)?,
        text: String
    ) {
        self.uiModel = uiModel
        self.presentHandler = presentHandler
        self.dismissHandler = dismissHandler
        self.text = text
    }

    // MARK: Body
    var body: some View {
        ZStack(content: {
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(.container, edges: .vertical) // Should have horizontal safe area
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier({ view in
                switch uiModel.layout.widthType {
                case .wrapped(let margin): view.padding(.horizontal, margin)
                case .stretched(_, let margin): view.padding(.horizontal, margin)
                case .fixedPoint, .fixedFraction: view
                }
            })
            .ignoresSafeArea(.container, edges: .vertical) // Should have horizontal safe area
            .onAppear(perform: animateIn)
            .onAppear(perform: animateOutAfterLifecycle)
            .onChange(
                of: presentationMode.isExternallyDismissed,
                perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
            )
    }
    
    private var contentView: some View {
        VText(
            type: uiModel.layout.textLineType.toVCoreTextLineType,
            color: uiModel.colors.text,
            font: .init(uiModel.fonts.text),
            text: text
        )
            .padding(uiModel.layout.textMargins)
            .modifier({ view in
                switch uiModel.layout.widthType {
                case .wrapped:
                    view
                
                case .stretched(let alignment, _):
                    view
                        .frame(
                            maxWidth: .infinity,
                            alignment: alignment.toAlignment
                        )
                
                case .fixedPoint(let width, let alignment):
                    view
                        .frame(
                            width: width,
                            alignment: alignment.toAlignment
                        )
                    
                case .fixedFraction(let ratio, let alignment):
                    view
                        .frame(
                            width: MultiplatformConstants.screenSize.width * ratio,
                            alignment: alignment.toAlignment
                        )
                }
            })
            .background(background)
            .onSizeChange(perform: { height = $0.height })
            .offset(y: isInternallyPresented ? presentedOffset : initialOffset)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(uiModel.colors.background)
    }

    // MARK: Offsets
    private var initialOffset: CGFloat {
        let initialOffset: CGFloat = height + 2*uiModel.layout.textMargins.vertical
        
        switch uiModel.layout.presentationEdge {
        case .top: return -initialOffset
        case .bottom: return MultiplatformConstants.screenSize.height + initialOffset
        }
    }

    private var presentedOffset: CGFloat {
        switch uiModel.layout.presentationEdge {
        case .top:
            return
                MultiplatformConstants.safeAreaInsets.top +
                uiModel.layout.presentationEdgeSafeAreaInset

        case .bottom:
            return
                MultiplatformConstants.screenSize.height -
                MultiplatformConstants.safeAreaInsets.bottom -
                height -
                uiModel.layout.presentationEdgeSafeAreaInset
        }
    }

    // MARK: Corner Radius
    private var cornerRadius: CGFloat {
        switch uiModel.layout.cornerRadiusType {
        case .capsule: return height / 2
        case .rounded(let cornerRadius): return cornerRadius
        }
    }
    
    // MARK: Animations
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

    private func animateOutAfterLifecycle() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + uiModel.animations.duration,
            execute: animateOut
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
}

// MARK: - Helpers
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension TextAlignment {
    fileprivate var toNSTextAlignment: NSTextAlignment {
        switch self {
        case .leading: return .left
        case .center: return .center
        case .trailing: return .right
        }
    }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension HorizontalAlignment {
    fileprivate var toAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        default: fatalError()
        }
    }
}

// MARK: - Preview
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VToast_Previews: PreviewProvider {
    private static let widthType: VToastUIModel.Layout.WidthType = .default
    
    private static var text: String { "Lorem ipsum dolor sit amet" }
    private static var textLong: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit" }
    
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        MultiLineTextPreview().previewDisplayName("MultiLine Text")
        PresentationEdgePreview_Top().previewDisplayName("Presentation Edge - Top")
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VToast(
                    uiModel: {
                        var uiModel: VToastUIModel = .init()
                        uiModel.layout.widthType = widthType
                        uiModel.animations.appear = nil
                        uiModel.animations.duration = .infinity
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    text: text
                )
            })
        }
    }
    
    private struct MultiLineTextPreview: View {
        var body: some View {
            PreviewContainer(content: {
                VToast(
                    uiModel: {
                        var uiModel: VToastUIModel = .init()
                        uiModel.layout.widthType = widthType
                        uiModel.layout.textLineType = .multiLine(alignment: .leading, lineLimit: 10)
                        uiModel.animations.appear = nil
                        uiModel.animations.duration = .infinity
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    text: textLong
                )
            })
        }
    }
    
    private struct PresentationEdgePreview_Top: View {
        var body: some View {
            PreviewContainer(content: {
                VToast(
                    uiModel: {
                        var uiModel: VToastUIModel = .init()
                        uiModel.layout.widthType = widthType
                        uiModel.layout.presentationEdge = .top
                        uiModel.animations.appear = nil
                        uiModel.animations.duration = .infinity
                        return uiModel
                    }(),
                    onPresent: nil,
                    onDismiss: nil,
                    text: text
                )
            })
        }
    }
}
