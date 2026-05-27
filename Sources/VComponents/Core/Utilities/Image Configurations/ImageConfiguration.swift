//
//  ImageConfiguration.swift
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
public struct ImageConfiguration {
    // MARK: Properties - Rendering
    /// Interpolation.
    public var interpolation: Image.Interpolation?
    
    /// Antialiasing.
    public var isAntialiased: Bool?
    
    // MARK: Properties - Color & Opacity
    /// Color.
    public var color: Color?
    
    /// Opacity.
    public var opacity: CGFloat?
    
    // MARK: Properties - Layout
    /// Aspect ratio.
    public var aspectRatio: AspectRatio?
    
    /// Resizability
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
        color: Color? = nil,
        opacity: CGFloat? = nil,
        aspectRatio: AspectRatio? = nil,
        resizable: Resizable? = nil,
        size: CGSize? = nil,
        font: Font? = nil,
        scale: Image.Scale? = nil,
        dynamicTypeSizeType: DynamicTypeSizeType? = nil
    ) {
        self.interpolation = interpolation
        self.isAntialiased = isAntialiased
        self.color = color
        self.opacity = opacity
        self.aspectRatio = aspectRatio
        self.resizable = resizable
        self.size = size
        self.font = font
        self.scale = scale
        self.dynamicTypeSizeType = dynamicTypeSizeType
    }

    // MARK: Types
    /// Model that describes resizability.
    public struct Resizable: Equatable {
        // MARK: Properties
        /// Cap insets.
        public var capInsets: EdgeInsets
        
        /// Resizing mode.
        public var resizingMode: Image.ResizingMode
        
        // MARK: Initializers
        /// Initializes `Resizable`.
        public init(
            capInsets: EdgeInsets = .init(),
            resizingMode: Image.ResizingMode = .stretch
        ) {
            self.capInsets = capInsets
            self.resizingMode = resizingMode
        }
    }
    
    /// Model that describes aspect ratio.
    public struct AspectRatio {
        // MARK: Properties
        /// Aspect ratio.
        public var aspectRatio: CGFloat?
        
        /// Content mode.
        public var contentMode: ContentMode
        
        // MARK: Initializers
        /// Initializes `AspectRatio`.
        public init(
            aspectRatio: CGFloat? = nil,
            contentMode: ContentMode
        ) {
            self.aspectRatio = aspectRatio
            self.contentMode = contentMode
        }
    }
}

// Needs to be extended on `Image` for several modifiers to work

extension Image {
    /// Applies `ImageConfiguration`.
    ///
    ///     let configuration: ImageConfiguration = ...
    ///
    ///     var body: some View {
    ///         Image(...)
    ///             .imageConfiguration(configuration)
    ///     }
    ///
    public func imageConfiguration(_ configuration: ImageConfiguration) -> some View {
        self
            .interpolation(configuration.interpolation ?? .medium)
            .antialiased(configuration.isAntialiased ?? true)
            .applyIfLet(configuration.resizable) { $0.resizable(capInsets: $1.capInsets, resizingMode: $1.resizingMode) } // Needs to be applied here
        
            .applyIfLet(configuration.color) { $0.foregroundStyle($1) }
            .opacity(configuration.opacity ?? 1)
        
            .applyIfLet(configuration.aspectRatio) { $0.aspectRatio($1.aspectRatio, contentMode: $1.contentMode) }
            //.applyIfLet(configuration.resizable) { $0.resizable(...) }
            .frame(size: configuration.size)
            .font(configuration.font)
            .applyIfLet(configuration.scale) { $0.imageScale($1) }
            .applyIfLet(configuration.dynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }
}
