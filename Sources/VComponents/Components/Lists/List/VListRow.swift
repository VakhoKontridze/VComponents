//
//  VListRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK: - V List Row
/// `View` in container that presents rows of data arranged in a single column.
///
/// Component is designed to be used within `List` and `ScrollView`.
/// When creating a `List`, `.vListStyle()` modifier must be applied.
///
/// UI Model can be passed as parameter.
///
/// Default `List` can be created as:
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
/// Default `ScrollView` can be created as:
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
/// "Static list" can be created as:
///
///     LazyVStack(spacing: 0, content: {
///         ForEach(titles, id: \.self, content: { title in
///             VListRow(content: {
///                 Text(title)
///             })
///         })
///     })
///
/// Separators can be removed in the following way:
///
///     List(content: {
///         ForEach(titles, id: \.self, content: { title in
///             VListRow(uiModel: .none, content: {
///                 Text(title)
///             })
///         })
///     })
///     .vListStyle()
///
/// `iOS` `15`-like enclosed `List` can be created as:
///
///     List(content: {
///         ForEach(titles.enumeratedArray(), id: \.element, content: { (i, title) in
///             VListRow(uiModel: .rowEnclosingSeparators(isFirst: i == 0), content: {
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
    // MARK: Properties
    private let uiModel: VListRowUIModel
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
        VStack(alignment: .leading, spacing: 0, content: {
            if uiModel.layout.separatorType.contains(.top) { separator }
            
            content()
                .padding(uiModel.layout.margins)
            
            if uiModel.layout.separatorType.contains(.bottom) { separator }
        })
        .listRowInsets(EdgeInsets())
        .listRowBackground(uiModel.colors.background)
        .modifier({
#if os(iOS) || os(macOS)
            $0.listRowSeparator(.hidden)
#else
            $0
#endif
        })
    }
    
    private var separator: some View {
        uiModel.colors.separator
            .frame(maxWidth: .infinity)
            .frame(height: uiModel.layout.separatorHeight)
            .padding(uiModel.layout.separatorMargins)
    }
}

// MARK: - Preview
#if DEBUG
import VCore
#endif

@available(iOS 15.0, macOS 13.0, tvOS 13.0, *)
@available(watchOS, unavailable)
struct VListRow_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            SeparatorsPreview().previewDisplayName("Separator")
        })
        .environment(\.layoutDirection, languageDirection)
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
                                        uiModel: {
                                            var uiModel: VListRowUIModel = .init()
                                            uiModel.layout.separatorType = .none
                                            return uiModel
                                        }(),
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
                                        uiModel: .noFirstAndLastSeparators(isFirst: i == 0),
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
