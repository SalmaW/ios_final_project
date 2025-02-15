import SDWebImageSwiftUI
import SwiftUI

struct CachedGifView: View {
    let gif: Gif
    @State private var cachedURL: URL?

    var body: some View {
        VStack {
            Group {
                if let url = cachedURL
                    ?? URL(string: gif.media_formats.tinygif.url)
                {
                    WebImage(url: url)
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    ProgressView()
                        .frame(width: 120, height: 120)
                }
            }

            Text(gif.title)
                .font(.caption)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 120)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 3)
        )
        .task {
            if let cached = await GIFCache.shared.getCachedImageURL(for: gif.id)
            {
                cachedURL = cached
            }
        }
    }
}
