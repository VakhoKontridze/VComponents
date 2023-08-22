//
//  VListRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI
import VCore

// MARK: - V List Row
/// Row component in container that presents rows of data arranged in a single column.
///
/// Component is designed to be used within `List` and `ScrollView`.
/// When creating a `List`, `.vListStyle()` modifier must be applied.
///
/// ListRow can be placed in `List` to manage dividers.
///
///     List(content: {
///         ForEach(titles, id: \.self, content: { title in
///             VListRow(content: {
///                 Text(title)
///             })
///         })
///     })
///     .vListStyle()
///
/// ListRow can be placed in `ScrollView` for additional customization.
///
///     ScrollView(content: {
///         LazyVStack(spacing: 0, content: {
///             ForEach(titles, id: \.self, content: { title in
///                 VListRow(content: {
///                     Text(title)
///                 })
///             })
///         })
///     })
///
/// Static, non-scrollable list layout can be created by wrapping ListRow in vertical stacks.
///
///     LazyVStack(spacing: 0, content: {
///         ForEach(titles, id: \.self, content: { title in
///             VListRow(content: {
///                 Text(title)
///             })
///         })
///     })
///
/// Separators can be customized or removed entirely via UI model.
///
///     List(content: {
///         ForEach(titles, id: \.self, content: { title in
///             VListRow(uiModel: .noSeparators(), content: {
///                 Text(title)
///             })
///         })
///     })
///     .vListStyle()
///
@available(iOS 15.0, macOS 13.0, tvOS 13.0, *)
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines
public struct VListRow<Content>: View
    where Content: View
{
    // MARK: Properties - UI Model
    private let uiModel: VListRowUIModel
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - Content
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes `VListRow` with content.
    public init(
        uiModel: VListRowUIModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0,
            content: {
                if uiModel.separatorType.contains(.top) { separator }
                
                content()
                    .padding(uiModel.margins)
                
                if uiModel.separatorType.contains(.bottom) { separator }
            }
        )
        .listRowInsets(EdgeInsets())
        .listRowBackground(uiModel.backgroundColor)
        .applyModifier({
#if os(iOS) || os(macOS)
            $0.listRowSeparator(.hidden)
#else
            $0
#endif
        })
    }
    
    private var separator: some View {
        uiModel.separatorColor
            .frame(maxWidth: .infinity)
            .frame(height: uiModel.separatorHeight.toPoints(scale: displayScale))
            .padding(uiModel.separatorMargins)
    }
}

// MARK: - Preview
import VCore

// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(watchOS, unavailable)
struct VListRow_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            SeparatorsPreview().previewDisplayName("Separators")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static var titles: [String] { (1...3).map { String($0) } }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                List(content: {
                    ForEach(titles, id: \.self, content: { title in
                        VListRow(uiModel: .noFirstSeparator(), content: {
                            Text(title)
                        })
                    })
                })
                .vListStyle()
            })
        }
    }
    
    private struct SeparatorsPreview: View {
        var body: some View {
            PreviewContainer(
                embeddedInScrollView: true,
                content: {
                    PreviewRow(
                        axis: .vertical,
                        paddedEdges: .vertical,
                        title: "None",
                        content: {
                            List(content: {
                                ForEach(titles, id: \.self, content: { title in
                                    VListRow(
                                        uiModel: .noSeparators(),
                                        content: { Text(title) }
                                    )
                                })
                            })
                            .vListStyle()
                            .frame(height: 120)
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        paddedEdges: .vertical,
                        title: "No First",
                        content: {
                            List(content: {
                                ForEach(titles, id: \.self, content: { title in
                                    VListRow(
                                        uiModel: .noFirstSeparator(),
                                        content: { Text(title) }
                                    )
                                })
                            })
                            .vListStyle()
                            .frame(height: 120)
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        paddedEdges: .vertical,
                        title: "No Last",
                        content: {
                            List(content: {
                                ForEach(titles, id: \.self, content: { title in
                                    VListRow(
                                        uiModel: .noLastSeparator(),
                                        content: { Text(title) }
                                    )
                                })
                            })
                            .vListStyle()
                            .frame(height: 120)
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        paddedEdges: .vertical,
                        title: "No First and Last",
                        content: {
                            List(content: {
                                ForEach(titles.enumeratedArray(), id: \.element, content: { (i, title) in
                                    VListRow(
                                        uiModel: .noFirstAndLastSeparators(isFirst: i == 0),
                                        content: { Text(title) }
                                    )
                                })
                            })
                            .vListStyle()
                            .frame(height: 120)
                        }
                    )
                    
                    PreviewRow(
                        axis: .vertical,
                        paddedEdges: .vertical,
                        title: "Row-Enclosing",
                        content: {
                            List(content: {
                                ForEach(titles.enumeratedArray(), id: \.element, content: { (i, title) in
                                    VListRow(
                                        uiModel: .rowEnclosingSeparators(isFirst: i == 0),
                                        content: { Text(title) }
                                    )
                                })
                            })
                            .vListStyle()
                            .frame(height: 120)
                        }
                    )
                }
            )
        }
    }
}
