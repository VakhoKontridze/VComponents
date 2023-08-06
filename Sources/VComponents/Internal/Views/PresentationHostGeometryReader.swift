//
//  PresentationHostGeometryReader.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 06.08.23.
//

import SwiftUI

// MARK: - Presentation Host Geometry Reader
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct PresentationHostGeometryReader<Content>: View where Content: View {
    // MARK: Properties
    private let content: () -> Content

    // MARK: Initializers
    init(
        /*@ViewBuilder*/ content: @escaping () -> Content
    ) {
        self.content = content
    }

    // MARK: Body
    var body: some View {
        GeometryReader(content: { proxy in
            content()
                .environment(\.presentationHostGeometryReaderSize, proxy.size)
                .environment(\.presentationHostGeometryReaderSafeAreaInsets, proxy.safeAreaInsets)
        })
    }
}

// MARK: - Presentation Host Geometry Reader Size Environment Value
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {
    var presentationHostGeometryReaderSize: CGSize {
        get { self[PresentationHostGeometryReaderSizeEnvironmentKey.self] }
        set { self[PresentationHostGeometryReaderSizeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Presentation Host Geometry Reader Size Environment Key
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct PresentationHostGeometryReaderSizeEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGSize = .zero
}

// MARK: - Presentation Host Geometry Reader Safe Area Insets Environment Value
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EnvironmentValues {
    var presentationHostGeometryReaderSafeAreaInsets: EdgeInsets {
        get { self[PresentationHostGeometryReaderSafeAreaInsetsEnvironmentKey.self] }
        set { self[PresentationHostGeometryReaderSafeAreaInsetsEnvironmentKey.self] = newValue }
    }
}

// MARK: - Presentation Host Geometry Reader Safe Area Insets Environment Key
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct PresentationHostGeometryReaderSafeAreaInsetsEnvironmentKey: EnvironmentKey {
    static var defaultValue: EdgeInsets = .init()
}
