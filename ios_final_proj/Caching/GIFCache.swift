import SDWebImageSwiftUI
import Foundation

actor GIFCache {
    static let shared = GIFCache()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheDirectory = cachesDirectory.appendingPathComponent("GIFCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func cacheGIFs(_ gifs: [Gif]) async {
        do {
            
            let cachedGifs = gifs.map { CachedGif(from: $0) }
            let data = try JSONEncoder().encode(cachedGifs)
            let fileURL = cacheDirectory.appendingPathComponent("trending.json")
            try data.write(to: fileURL)
            
            for gif in gifs {
                if let url = URL(string: gif.media_formats.tinygif.url) {
                    if let imageData = try? await downloadImage(from: url) {
                        let imageFileURL = cacheDirectory.appendingPathComponent("\(gif.id).gif")
                        try imageData.write(to: imageFileURL)
                    }
                }
            }
            
        } catch {
            print("Failed to cache GIFs: \(error)")
        }
    }
    
    func getCachedGIFs() async -> [Gif]? {
        let fileURL = cacheDirectory.appendingPathComponent("trending.json")
        guard let data = try? Data(contentsOf: fileURL),
              let cachedGifs = try? JSONDecoder().decode([CachedGif].self, from: data) else {
            return nil
        }
        
        return cachedGifs.map { $0.toApiGif() }
    }
    
    func getCachedImageURL(for gifId: String) -> URL? {
        let imageFileURL = cacheDirectory.appendingPathComponent("\(gifId).gif")
        return fileManager.fileExists(atPath: imageFileURL.path) ? imageFileURL : nil
    }
    
    private func downloadImage(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}


