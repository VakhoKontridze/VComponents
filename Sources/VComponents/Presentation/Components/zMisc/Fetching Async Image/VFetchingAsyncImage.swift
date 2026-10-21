//
//  VFetchingAsyncImage.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 10.03.23.
//

public import SwiftUI
import VCore

/// `View` that asynchronously loads and displays an `Image` with a fetch action.
///
/// Request can be customized with access token and headers, implement custom caching, and more.
///
/// When `cachedImage` returns an `Image`, it's displayed immediately, and `fetch` isn't called.
/// This avoids a placeholder flash when the component is recreated, or when parameter changes to an already-cached value.
///
///     private let imageDimension: CGFloat = 200
///
///     @Environment(\.displayScale) private var displayScale: CGFloat
///
///     private let imageStore: ImageStore = DIContainer.shared.imageStore.resolve()
///
///     var body: some View {
///         VFetchingAsyncImage(
///             from: #URL("https://website.com/content/image.jpg"),
///             cachedImage: {
///                 imageStore.resizedImageFromMemoryCache(
///                     parameter: .remote(url: $0),
///                     size: CGSize(dimension: imageDimension * displayScale)
///                 )
///             },
///             fetch: {
///                 try await imageStore.fetchResizedImage(
///                     parameter: .remote(url: $0),
///                     size: CGSize(dimension: imageDimension * displayScale)
///                 )
///             },
///             contentWithPhase: { phase in
///                 if let image: Image = phase.image {
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
///         .frame(dimension: imageDimension)
///     }
///
public struct VFetchingAsyncImage<Parameter, CustomContent, CustomPlaceholderContent>: View
    where
        Parameter: Equatable,
        CustomContent: View,
        CustomPlaceholderContent: View
{
    // MARK: Properties - Appearance
    private let appearance: VFetchingAsyncImageAppearance

    // MARK: Properties - Fetching
    private let parameter: Parameter?
    private let cachedImage: ((Parameter) -> Image?)?
    private let fetch: (Parameter) async throws -> Image
    
    @State private var parameterFetched: Parameter? // Needed for avoiding fetching an-already fetched image. Cleared on failure, so that the next appearance retries.
    @State private var result: Result<Image, any Error>?
    
    // MARK: Properties - Content
    private let content: VFetchingAsyncImageContent<CustomContent, CustomPlaceholderContent>

    // MARK: Properties - Subscriptions
    @State private var task: Task<Void, Never>?

    // MARK: Initializers
    /// Initializes `VFetchingAsyncImage` with parameter, cached image, and fetch method.
    public init(
        appearance: VFetchingAsyncImageAppearance = .init(),
        from parameter: Parameter?,
        cachedImage: ((Parameter) -> Image?)? = nil,
        fetch: @escaping (Parameter) async throws -> Image
    )
        where
            CustomContent == Never,
            CustomPlaceholderContent == Never
    {
        self.appearance = appearance
        self.parameter = parameter
        self.cachedImage = cachedImage
        self.fetch = fetch
        self.content = .auto
    }
    
    /// Initializes `VFetchingAsyncImage` with parameter, cached image, fetch method, and content.
    public init(
        appearance: VFetchingAsyncImageAppearance = .init(),
        from parameter: Parameter?,
        cachedImage: ((Parameter) -> Image?)? = nil,
        fetch: @escaping (Parameter) async throws -> Image,
        @ViewBuilder content customContent: @escaping (Image) -> CustomContent
    )
        where
            CustomPlaceholderContent == Never
    {
        self.appearance = appearance
        self.parameter = parameter
        self.cachedImage = cachedImage
        self.fetch = fetch
        self.content = .content(
            contentBuilder: customContent
        )
    }
    
    /// Initializes `VFetchingAsyncImage` with parameter, fetch method, content, and placeholder content.
    public init(
        appearance: VFetchingAsyncImageAppearance = .init(),
        from parameter: Parameter?,
        cachedImage: ((Parameter) -> Image?)? = nil,
        fetch: @escaping (Parameter) async throws -> Image,
        @ViewBuilder content customContent: @escaping (Image) -> CustomContent,
        @ViewBuilder placeholder customPlaceholderContent: @escaping () -> CustomPlaceholderContent
    ) {
        self.appearance = appearance
        self.parameter = parameter
        self.cachedImage = cachedImage
        self.fetch = fetch
        self.content = .contentAndPlaceholder(
            contentBuilder: customContent,
            placeholderBuilder: customPlaceholderContent
        )
    }
    
    /// Initializes `VFetchingAsyncImage` with parameter, cached image, fetch method, and phase-dependent content.
    public init(
        appearance: VFetchingAsyncImageAppearance = .init(),
        from parameter: Parameter?,
        cachedImage: ((Parameter) -> Image?)? = nil,
        fetch: @escaping (Parameter) async throws -> Image,
        @ViewBuilder contentWithPhase customContentWithPhase: @escaping (AsyncImagePhase) -> CustomContent
    )
        where CustomPlaceholderContent == Never
    {
        self.appearance = appearance
        self.parameter = parameter
        self.cachedImage = cachedImage
        self.fetch = fetch
        self.content = .contentWithPhase(
            contentBuilder: customContentWithPhase
        )
    }
    
    // MARK: Body
    public var body: some View {
        ZStack {
            switch content {
            case .auto:
                if case .success(let image) = result {
                    image
                } else {
                    defaultPlaceholderView
                }
                
            case .content(let contentBuilder):
                if case .success(let image) = result {
                    contentBuilder(image)
                } else {
                    defaultPlaceholderView
                }
                
            case .contentAndPlaceholder(let contentBuilder, let placeholderBuilder):
                if case .success(let image) = result {
                    contentBuilder(image)
                } else {
                    placeholderBuilder()
                }
                
            case .contentWithPhase(let contentBuilder):
                contentBuilder({
                    switch result {
                    case nil: AsyncImagePhase.empty
                    case .success(let image): AsyncImagePhase.success(image)
                    case .failure(let error): AsyncImagePhase.failure(error)
                    }
                }())
            }
        }
        .onAppear { fetch(from: parameter) } // `onChange(of:initial:)` doesn't re-fire on re-appearance, which would leave the image empty after `removesImageOnDisappear`
        .onChange(of: parameter) { fetch(from: $1) }
        .onDisappear {
            if appearance.removesImageOnDisappear { reset() }
        }
    }
    
    private var defaultPlaceholderView: some View {
        appearance.placeholderColor
    }

    // MARK: Fetch
    private func fetch(
        from parameter: Parameter?
    ) {
        guard let parameter else {
            reset()
            return
        }

        guard parameter != parameterFetched else { return }
        
        parameterFetched = parameter

        task?.cancel()
        task = nil

        // Assigned synchronously, so the placeholder isn't rendered for a frame while a `Task` is scheduled
        if let image: Image = cachedImage?(parameter) {
            result = .success(image)
            return
        }

        if appearance.removesImageOnParameterChange { result = nil }

        task = Task {
            let image: Image
            do {
                image = try await fetch(parameter)
                try Task.checkCancellation() // `fetch` may ignore cancellation, and return an image for a stale parameter

            } catch is CancellationError {
                return
                
            } catch {
                result = .failure(error)
                parameterFetched = nil
                return
            }
            
            result = .success(image)
        }
    }

    private func reset() {
        parameterFetched = nil
        result = nil

        task?.cancel()
        task = nil
    }
}

#if DEBUG

#Preview {
    PreviewContainer {
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
    }
}

#endif
