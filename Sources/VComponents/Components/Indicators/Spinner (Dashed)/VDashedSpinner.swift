//
//  VDashedSpinner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Dashed Spinner
/// Indicator component that indicates activity.
///
/// UI model can be passed as parameter.
///
///     var body: some View {
///         VDashedSpinner()
///     }
///
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct VDashedSpinner: View {
    // MARK: Properties
    private let uiModel: VDashedSpinnerUIModel
    
    // MARK: Initializers
    /// Initializes `VDashedSpinner`
    public init(
        uiModel: VDashedSpinnerUIModel = .init()
    ) {
        self.uiModel = uiModel
    }
    
    // MARK: Body
    public var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: uiModel.colors.spinner))
    }
}

// MARK: - Preview
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct VDashedSpinner_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
        })
        .environment(\.layoutDirection, languageDirection)
        .colorScheme(colorScheme)
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VDashedSpinner()
            })
        }
    }
}
