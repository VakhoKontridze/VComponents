//
//  VFetchingAsyncImage.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 10.03.23.
//

import SwiftUI

// MARK: - V Fetching Async Image
/// `View` that asynchronously loads and displays an `Image` with a fetch handler.
///
/// Request can be customized with access token and headers, implement custom caching, and more.
///
///     var body: some View {
///         VFetchingAsyncImage(
///             from: #URL("https://somewebsite.com/content/image.jpg"),
///             fetch: fetchImage,
///             contentWithPhase: { phase in
///                 if let image = phase.image {
///                     image
///                         .resizable()
///                         .scaledToFit()
///                         .foregroundStyle(Color.blue)
///
///                 } else if phase.error != nil {
///                     ErrorView()
///
///                 } else {
///                     ProgressView()
///                 }
///             }
///         )
///         .frame(dimension: 200)
///     }
///
///     ...
///
///     private let cache: NSCache<NSString, UIImage> = .init()
///
///     private func fetchImage(url: URL) async throws -> Image {
///         let key: NSString = .init(string: url.absoluteString)
///
///         switch cache.object(forKey: key) {
///         case nil:
///             let data: Data = try await URLSession.shared.data(from: url).0
///             guard let uiImage: UIImage = .init(data: data) else { throw URLError(.cannotDecodeContentData) }
///
///             cache.setObject(uiImage, forKey: key)
///
///             return Image(uiImage: uiImage)
///
///         case let uiImage?:
///             return Image(uiImage: uiImage)
///         }
///     }
///
public struct VFetchingAsyncImage<Parameter, CustomContent, CustomPlaceholderContent>: View, Sendable
    where
        Parameter: Equatable,
        CustomContent: View,
        CustomPlaceholderContent: View
{
    // MARK: Properties - UI Model
    private let uiModel: VFetchingAsyncImageUIModel

    // MARK: Properties - Fetching
    private let parameter: Parameter?
    private let fetchHandler: (Parameter) async throws -> Image
    
    @State private var parameterFetched: Parameter? // Needed for avoiding fetching an-already fetched image
    @State private var result: Result<Image, any Error>?
    
    // MARK: Properties - Content
    private let content: VFetchingAsyncImageContent<CustomContent, CustomPlaceholderContent>

    // MARK: Properties - Cancellables
    @State private var task: Task<Void, Never>?

    // MARK: Initializers
    /// Initializes `VFetchingAsyncImage` with parameter and fetch method.
    public init(
        uiModel: VFetchingAsyncImageUIModel = .init(),
        from parameter: Parameter?,
        fetch fetchHandler: @escaping (Parameter) async throws -> Image
    )
        where
            CustomContent == Never,
            CustomPlaceholderContent == Never
    {
        self.uiModel = uiModel
        self.parameter = parameter
        self.fetchHandler = fetchHandler
        self.content = .auto
    }
    
    /// Initializes `VFetchingAsyncImage` with parameter, fetch method, and content.
    public init(
        uiModel: VFetchingAsyncImageUIModel = .init(),
        from parameter: Parameter?,
        fetch fetchHandler: @escaping (Parameter) async throws -> Image,
        @ViewBuilder content customContent: @escaping (Image) -> CustomContent
    )
        where
            CustomPlaceholderContent == Never
    {
        self.uiModel = uiModel
        self.parameter = parameter
        self.fetchHandler = fetchHandler
        self.content = .content(
            customContent: customContent
        )
    }
    
    /// Initializes `VFetchingAsyncImage` with parameter, fetch method, content, and placeholder content.
    public init(
        uiModel: VFetchingAsyncImageUIModel = .init(),
        from parameter: Parameter?,
        fetch fetchHandler: @escaping (Parameter) async throws -> Image,
        @ViewBuilder content customContent: @escaping (Image) -> CustomContent,
        @ViewBuilder placeholder customPlaceholderContent: @escaping () -> CustomPlaceholderContent
    ) {
        self.uiModel = uiModel
        self.parameter = parameter
        self.fetchHandler = fetchHandler
        self.content = .contentAndPlaceholder(
            customContent: customContent,
            customPlaceholderContent: customPlaceholderContent
        )
    }
    
    /// Initializes `VFetchingAsyncImage` with parameter, fetch method, and phase-dependent content.
    public init(
        uiModel: VFetchingAsyncImageUIModel = .init(),
        from parameter: Parameter?,
        fetch fetchHandler: @escaping (Parameter) async throws -> Image,
        @ViewBuilder contentWithPhase customContentWithPhase: @escaping (AsyncImagePhase) -> CustomContent
    )
        where CustomPlaceholderContent == Never
    {
        self.uiModel = uiModel
        self.parameter = parameter
        self.fetchHandler = fetchHandler
        self.content = .contentWithPhase(
            customContentWithPhase: customContentWithPhase
        )
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(content: {
            switch content {
            case .auto:
                if case .success(let image) = result {
                    image
                } else {
                    defaultPlaceholderView
                }
                
            case .content(let content):
                if case .success(let image) = result {
                    content(image)
                } else {
                    defaultPlaceholderView
                }
                
            case .contentAndPlaceholder(let customContent, let customPlaceholderContent):
                if case .success(let image) = result {
                    customContent(image)
                } else {
                    customPlaceholderContent()
                }
                
            case .contentWithPhase(let customContentWithPhase):
                customContentWithPhase({
                    switch result {
                    case nil: AsyncImagePhase.empty
                    case .success(let image): AsyncImagePhase.success(image)
                    case .failure(let error): AsyncImagePhase.failure(error)
                    }
                }())
            }
        })
        .applyModifier({
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                $0
                    .onChange(
                        of: parameter,
                        initial: true,
                        { (_, newValue) in fetch(from: newValue) }
                    )
            } else {
                $0
                    .onAppear(perform: { fetch(from: parameter) })
                    .onChange(of: parameter, perform: { fetch(from: $0) })
            }
        })
        .onDisappear(perform: {
            if uiModel.removesImageOnDisappear { reset() }
        })
    }
    
    private var defaultPlaceholderView: some View {
        uiModel.placeholderColor
    }

    // MARK: Fetch
    private func fetch(
        from parameter: Parameter?
    ) {
        guard let parameter else {
            zeroData()
            return
        }

        guard parameter != parameterFetched else { return }
        
        parameterFetched = parameter
        if uiModel.removesImageOnParameterChange { result = nil }

        task?.cancel()
        task = Task(operation: { @MainActor in
            do {
                let image: Image = try await fetchHandler(parameter)
                guard !Task.isCancelled else { return }
                
                result = .success(image)

            } catch {
                guard !Task.isCancelled else { return }
                
                result = .failure(error)
            }
        })
    }
    
    private func zeroData() {
        parameterFetched = nil
        result = nil
    }

    private func reset() {
        zeroData()

        task?.cancel()
        task = nil
    }
}

// MARK: - Preview
#if DEBUG

#Preview(body: {
    PreviewContainer(content: {
        VFetchingAsyncImage(
            from: "-",
            fetch: { _ in throw URLError(.badURL) }
        )
        .frame(dimension: 64)

        VFetchingAsyncImage(
            from: "-",
            fetch: { _ in Image(systemName: "swift") },
            content: { image in
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.blue)
            }
        )
        .frame(dimension: 64)
    })
})

#endif
