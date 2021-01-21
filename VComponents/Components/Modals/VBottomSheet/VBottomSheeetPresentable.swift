//
//  VBottomSheeetPresenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK:- V Bottom Sheet VC Representable
struct VBottomSheetVCRepresentable<BottomSheetContent, BlindingContent>
    where
        BottomSheetContent: View,
        BlindingContent: View
    {
    // MARK: Properties
    @Binding private var isPresented: Bool

    private let content: BottomSheetContent
    private let blinding: BlindingContent
 
    private let contentHeight: CGFloat   // Doesn't need to be updated with updateUIViewController(), as somehow passign content to HC does it
    private let animationCurve: UIView.AnimationCurve
    private let animationDuration: TimeInterval
    private let backTapAction: (() -> Void)?

    // MARK: Initializers
    init(
        isPresented: Binding<Bool>,
        content: BottomSheetContent,
        blinding: BlindingContent,
        contentHeight: CGFloat,
        animationCurve: UIView.AnimationCurve,
        animationDuration: TimeInterval,
        onBackTap backTapAction: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.content = content
        self.blinding = blinding
        self.contentHeight = contentHeight
        self.animationCurve = animationCurve
        self.animationDuration = animationDuration
        self.backTapAction = backTapAction
    }
}

// MARK:- Representabe
extension VBottomSheetVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VBottomSheetVC<BottomSheetContent, BlindingContent> {
        .init(
            content: content,
            blinding: blinding,
            contentHeight: contentHeight,
            animationCurve: animationCurve,
            animationDuration: animationDuration,
            onBackTap: backTapAction
        )
    }

    func updateUIViewController(_ uiViewController: VBottomSheetVC<BottomSheetContent, BlindingContent>, context: Context) {
        switch isPresented {
        case false:
            uiViewController.dismiss()
        
        case true:
            uiViewController.bottomSheetHC?.rootView = content
            uiViewController.blindingHC?.rootView = blinding
        }
    }
}

// MARK:- V Bottom Sheet VC
final class VBottomSheetVC<BottomSheetContent, BlindingContent>: UIViewController
    where
        BottomSheetContent: View,
        BlindingContent: View
{
    // MARK: Properties
    private let bottomSheetID: Int = 999_999_995
    private let blindingID: Int = 999_999_994
    
    fileprivate var bottomSheetHC: UIHostingController<BottomSheetContent>!
    fileprivate var blindingHC: UIHostingController<BlindingContent>!
    
    private var initialTransform: CGAffineTransform {
        .init(translationX: 0, y: UIScreen.main.bounds.height + (contentHeight + UIKitPresenterCommon.safeAreaHeight))
    }
    private var presentedTransform: CGAffineTransform {
        .init(translationX: 0, y: UIScreen.main.bounds.height - (contentHeight + UIKitPresenterCommon.safeAreaHeight))
    }
    private var dismissedTransform: CGAffineTransform {
        initialTransform
    }
    
    private let contentHeight: CGFloat
    private let animationCurve: UIView.AnimationCurve
    private let animationDuration: TimeInterval
    private let backTapAction: (() -> Void)?

    // MARK: Initializers
    init(
        content: BottomSheetContent,
        blinding: BlindingContent,
        contentHeight: CGFloat,
        animationCurve: UIView.AnimationCurve,
        animationDuration: TimeInterval,
        onBackTap backTapAction: (() -> Void)?
    ) {
        self.contentHeight = contentHeight
        self.animationCurve = animationCurve
        self.animationDuration = animationDuration
        self.backTapAction = backTapAction
        super.init(nibName: nil, bundle: nil)
        present(content, blinding: blinding)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Misc
    // Extensions of generic classes cannot contain '@objc' members
    @objc func didTapBlindingView(_ sender: UITapGestureRecognizer) { backTapAction?() }
}

// MARK:- Presenting
private extension VBottomSheetVC {
    func present(_ content: BottomSheetContent, blinding: BlindingContent) {
        presentBlinding(blinding)
        presentBottomSheet(content)
    }
    
    func presentBlinding(_ blinding: BlindingContent) {
        blindingHC = UIKitPresenterCommon.presentBlinding(blinding, id: blindingID)
        
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(didTapBlindingView))
        blindingHC?.view.addGestureRecognizer(tapGesture)
    }
    
    func presentBottomSheet(_ content: BottomSheetContent) {
        guard let appSuperView = UIKitPresenterCommon.appSuperView else { return }
        
        bottomSheetHC = UIKitPresenterCommon.createHostingController(content: content, id: bottomSheetID)
        let bottomSheetView: UIView = bottomSheetHC.view

        appSuperView.addSubview(bottomSheetView)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: appSuperView.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: appSuperView.trailingAnchor),
            bottomSheetView.topAnchor.constraint(equalTo: appSuperView.topAnchor)
        ])
        appSuperView.bringSubviewToFront(bottomSheetView)
        
        bottomSheetView.transform = initialTransform
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationCurve.animationOption,
            animations: { [weak self] in
                guard let self = self else { return }
                bottomSheetView.transform = self.presentedTransform
            },
            completion: nil
        )
    }
}

// MARK:- Dismissing
private extension VBottomSheetVC {
    func dismiss() {
        dismissBlinding()
        dismissBottomSheet()
    }
    
    func dismissBlinding() {
        UIKitPresenterCommon.dismissView(id: blindingID)
    }
    
    func dismissBottomSheet() {
        guard let bottomSheetView = UIKitPresenterCommon.view(id: bottomSheetID) else { return }
        
        bottomSheetView.transform = presentedTransform
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationCurve.animationOption,
            animations: { [weak self] in
                guard let self = self else { return }
                bottomSheetView.transform = self.dismissedTransform
            },
            completion: { _ in
                bottomSheetView.removeFromSuperview()
            }
        )
    }
}
