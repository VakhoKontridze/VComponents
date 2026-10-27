//
//  GenericStateImageConfiguration.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 8/4/26.
//

public import SwiftUI
public import VCore

/// Model that describes image configuration.
///
/// `renderingMode` is omitted.
/// Instead, configure it directly via `Image` when passing it as a content or a label.
///
/// `symbolRenderingMode`, `symbolVariableValueMode`, and `symbolColorRenderingMode` are omitted.
/// Instead, configure them via `Image` when passing it as a content or a label.
///
/// `symbolVariant` is omitted.
/// Instead, configure it directly within the `Image` as SF symbol name.
public struct GenericStateImageConfiguration<Colors, Opacities> {
    // MARK: Properties - Rendering
    /// Interpolation.
    public var interpolation: Image.Interpolation?
    
    /// Antialiasing.
    public var isAntialiased: Bool?
    
    // MARK: Properties - Color & Opacity
    /// Colors.
    public var colors: Colors?
    
    /// Opacities.
    public var opacities: Opacities?
    
    // MARK: Properties - Layout
    /// Aspect ratio.
    public var aspectRatio: AspectRatio?
    
    /// Resizability.
    public var resizable: Resizable?
    
    /// Size.
    public var size: CGSize?
    
    /// Font.
    public var font: Font?
    
    /// Scale.
    public var scale: Image.Scale?
    
    /// Dynamic type size type.
    public var dynamicTypeSizeType: DynamicTypeSizeType?
    
    // MARK: Initializers
    /// Initializes `ImageConfiguration`.
    public init(
        interpolation: Image.Interpolation? = nil,
        isAntialiased: Bool? = nil,
        colors: Colors? = nil,
        opacities: Opacities? = nil,
        aspectRatio: AspectRatio? = nil,
        resizable: Resizable? = nil,
        size: CGSize? = nil,
        font: Font? = nil,
        scale: Image.Scale? = nil,
        dynamicTypeSizeType: DynamicTypeSizeType? = nil
    ) {
        self.interpolation = interpolation
        self.isAntialiased = isAntialiased
        self.colors = colors
        self.opacities = opacities
        self.aspectRatio = aspectRatio
        self.resizable = resizable
        self.size = size
        self.font = font
        self.scale = scale
        self.dynamicTypeSizeType = dynamicTypeSizeType
    }
    
    // MARK: Mapping
    /// Maps `GenericImageConfiguration` to `ImageConfiguration`.
    public func toImageConfiguration(
        color: Color?,
        opacity: CGFloat?
    ) -> ImageConfiguration {
        .init(
            interpolation: interpolation,
            isAntialiased: isAntialiased,
            
            color: color,
            opacity: opacity,
            
            aspectRatio: aspectRatio,
            resizable: resizable,
            size: size,
            
            font: font,
            scale: scale,
            dynamicTypeSizeType: dynamicTypeSizeType
        )
    }

    // MARK: Types
    /// Model that describes resizability.
    public typealias Resizable = ImageConfiguration.Resizable
    
    /// Model that describes aspect ratio.
    public typealias AspectRatio = ImageConfiguration.AspectRatio
}
