import Foundation

struct CachedGif: Codable, Identifiable {
    let id: String
    let title: String
    let media_formats: CachedMediaFormats

    init(from apiGif: Gif) {
        self.id = apiGif.id
        self.title = apiGif.title
        self.media_formats = CachedMediaFormats(from: apiGif.media_formats)
    }

    func toApiGif() -> Gif {
        return Gif(
            id: self.id,
            title: self.title,
            media_formats: self.media_formats.toApiMediaFormats()
        )
    }
}

struct CachedMediaFormats: Codable {
    let tinygif: CachedGifDetails

    init(from apiMediaFormats: MediaFormats) {
        self.tinygif = CachedGifDetails(from: apiMediaFormats.tinygif)
    }

    func toApiMediaFormats() -> MediaFormats {
        return MediaFormats(tinygif: self.tinygif.toApiGifDetails())
    }
}

struct CachedGifDetails: Codable {
    let url: String

    init(from apiGifDetails: GifDetails) {
        self.url = apiGifDetails.url
    }

    func toApiGifDetails() -> GifDetails {
        return GifDetails(url: self.url)
    }
}
