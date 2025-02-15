import Foundation

struct GIFResponse: Decodable {
    let results: [Gif]
}

struct Gif: Decodable, Identifiable, Equatable {
    let id: String
    let title: String
    let media_formats: MediaFormats
    static func == (lhs: Gif, rhs: Gif) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MediaFormats: Decodable {
    let tinygif: GifDetails
}

struct GifDetails: Decodable {
    let url: String
}

struct GifCategoriesResponse: Decodable {
    let tags: [GifCategory]
}

struct GifCategory: Decodable, Identifiable {
    let searchterm: String
    let path: String
    let image: String
    let name: String

    var id: String { searchterm }

}
