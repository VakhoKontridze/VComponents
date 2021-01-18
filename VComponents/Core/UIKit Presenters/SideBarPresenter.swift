//
//  SideBarPresenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/18/21.
//

import SwiftUI

// MARK:- V Side Bar VC Representable
struct VSideBarVCRepresentable<SideBarContent, BlindingContent>
    where
        SideBarContent: View,
        BlindingContent: View
    {
    // MARK: Properties
    @Binding private var isPresented: Bool

    private let content: SideBarContent
    private let blinding: BlindingContent

    private let contentWidth: CGFloat
    private let animationCurve: UIView.AnimationCurve
    private let animationDuration: TimeInterval
    private let backTapAction: (() -> Void)?

    // MARK: Initializers
    init(
        isPresented: Binding<Bool>,
        content: SideBarContent,
        blinding: BlindingContent,
        contentWidth: CGFloat,
        animationCurve: UIView.AnimationCurve,
        animationDuration: TimeInterval,
        onBackTap backTapAction: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.content = content
        self.blinding = blinding
        self.contentWidth = contentWidth
        self.animationCurve = animationCurve
        self.animationDuration = animationDuration
        self.backTapAction = backTapAction
    }
}

// MARK:- Representabe
extension VSideBarVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<Self>
    ) -> VSideBarVC<SideBarContent, BlindingContent> {
        .init(
            content: content,
            blinding: blinding,
            contentWidth: contentWidth,
            animationCurve: animationCurve,
            animationDuration: animationDuration,
            onBackTap: backTapAction
        )
    }

    func updateUIViewController(
        _ uiViewController: VSideBarVC<SideBarContent, BlindingContent>,
        context: UIViewControllerRepresentableContext<Self>
    ) {
        switch isPresented {
        case false:
            uiViewController.dismiss()
        
        case true:
            uiViewController.sideBarHC?.rootView = content
            uiViewController.blindingHC?.rootView = blinding
        }
    }
}

// MARK:- V Side Bar VC
final class VSideBarVC<SideBarContent, BlindingContent>: UIViewController where
        SideBarContent: View,
        BlindingContent: View
{
    // MARK: Properties
    private let sideBarID: Int = 999_999_997
    private let blindingID: Int = 999_999_996
    
    fileprivate var sideBarHC: UIHostingController<SideBarContent>!
    fileprivate var blindingHC: UIHostingController<BlindingContent>!
    
    private var initialTransform: CGAffineTransform { .init(translationX: -contentWidth, y: 0) }
    private var presentedTransform: CGAffineTransform { .init(translationX: 0, y: 0) }
    private var dismissedTransform: CGAffineTransform { initialTransform }
    
    private let contentWidth: CGFloat
    private let animationCurve: UIView.AnimationCurve
    private let animationDuration: TimeInterval
    private let backTapAction: (() -> Void)?

    // MARK: Initializers
    init(
        content: SideBarContent,
        blinding: BlindingContent,
        contentWidth: CGFloat,
        animationCurve: UIView.AnimationCurve,
        animationDuration: TimeInterval,
        onBackTap backTapAction: (() -> Void)?
    ) {
        self.contentWidth = contentWidth
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
private extension VSideBarVC {
    func present(_ content: SideBarContent, blinding: BlindingContent) {
        presentBlinding(blinding)
        presentSideBar(content)
    }
    
    func presentBlinding(_ blinding: BlindingContent) {
        blindingHC = UIKitPresenterCommon.presentBlinding(blinding, id: blindingID)
        
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(didTapBlindingView))
        blindingHC?.view.addGestureRecognizer(tapGesture)
    }
    
    func presentSideBar(_ content: SideBarContent) {
        guard let appSuperView = UIKitPresenterCommon.appSuperView else { return }
        
        sideBarHC = UIKitPresenterCommon.createHostingController(content: content, id: sideBarID)
        let sideBarView: UIView = sideBarHC.view

        appSuperView.addSubview(sideBarView)
        NSLayoutConstraint.activate([
            sideBarView.leadingAnchor.constraint(equalTo: appSuperView.leadingAnchor),
            sideBarView.topAnchor.constraint(equalTo: appSuperView.topAnchor),
            sideBarView.bottomAnchor.constraint(equalTo: appSuperView.bottomAnchor)
        ])
        appSuperView.bringSubviewToFront(sideBarView)
        
        sideBarView.transform = initialTransform
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationCurve.animationOption,
            animations: { [weak self] in
                guard let self = self else { return }
                sideBarView.transform = self.presentedTransform
            },
            completion: nil
        )
    }
}

// MARK:- Dismissing
private extension VSideBarVC {
    func dismiss() {
        dismissBlinding()
        dismissSideBar()
    }
    
    func dismissBlinding() {
        UIKitPresenterCommon.dismissView(id: blindingID)
    }
    
    func dismissSideBar() {
        guard let sideBarView = UIKitPresenterCommon.view(id: sideBarID) else { return }
        
        sideBarView.transform = presentedTransform
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationCurve.animationOption,
            animations: { [weak self] in
                guard let self = self else { return }
                sideBarView.transform = self.dismissedTransform
            },
            completion: { _ in
                sideBarView.removeFromSuperview()
            }
        )
    }
}
