//
//  TextAndImageSpacingType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 5/5/26.
//

import SwiftUI

/// Text and image spacing type.
nonisolated public enum TextAndImageSpacingType: Sendable {
    // MARK: Cases
    /// Fixed spacing.
    case fixed(spacing: CGFloat)

    /// Stretched spacing.
    case stretched(spacing: CGFloat)
    
    // MARK: Properties
    fileprivate var spacing: CGFloat {
        switch self {
        case .fixed(let spacing): spacing
        case .stretched(let spacing): spacing
        }
    }
    
    fileprivate var hasFlexibleSpacing: Bool {
        switch self {
        case .fixed: false
        case .stretched: true
        }
    }
    
    fileprivate var centeredElementMaxWidth: CGFloat? {
        if hasFlexibleSpacing {
            CGFloat.infinity
        } else {
            nil
        }
    }
}

struct StretchedComponentTextAndImageContent<TextElement, ImageElement>: View
    where
        TextElement: View,
        ImageElement: View
{
    // MARK: Properties - Appearance
    private let textAndImagePlacement: TextAndImagePlacement
    private let spacingType: TextAndImageSpacingType
    
    @State private var imageWidth: CGFloat?
    
    // MARK: Properties - Content
    private let text: () -> TextElement
    private let image: () -> ImageElement
    
    // MARK: Initializers
    init(
        textAndImagePlacement: TextAndImagePlacement,
        spacingType: TextAndImageSpacingType,
        text: @escaping () -> TextElement,
        image: @escaping () -> ImageElement
    ) {
        self.textAndImagePlacement = textAndImagePlacement
        self.spacingType = spacingType
        self.text = text
        self.image = image
    }
    
    // MARK: Body
    var body: some View {
        HStack(spacing: 0) {
            if !spacingType.hasFlexibleSpacing {
                Spacer()
            }
            
            switch textAndImagePlacement {
            case .textAndImage: imageCompensatorView
            case .imageAndText: _image
            }
            
            Spacer().frame(width: spacingType.spacing)
            
            ZStack {
                text()
            }
            .frame(maxWidth: spacingType.centeredElementMaxWidth)
            
            Spacer().frame(width: spacingType.spacing)
            
            switch textAndImagePlacement {
            case .textAndImage: _image
            case .imageAndText: imageCompensatorView
            }
            
            if !spacingType.hasFlexibleSpacing {
                Spacer()
            }
        }
    }
    
    private var _image: some View {
        ZStack {
            image()
        }
        .onGeometryChange(of: { $0.size.width }) { imageWidth = $0 }
    }
    
    private var imageCompensatorView: some View {
        Spacer()
            .frame(width: imageWidth)
    }
}
