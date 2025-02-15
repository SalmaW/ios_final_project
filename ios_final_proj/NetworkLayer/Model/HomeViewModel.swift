import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var featuredGIFs: [Gif] = []
    @Published var categories: [GifCategory] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var isOffline = false
    
    @Published var username: String {
        didSet { saveUserName() }
    }
    
    init() {
        self.username = UserDefaults.standard.string(forKey: "name") ?? "John Doe"
    }
    
    private func saveUserName() {
        UserDefaults.standard.set(username, forKey: "name")
    }
    
    func fetchTrendingGIFs(limit: Int = 10) async {
        isLoading = true
        let request = APIRouter.GetTrendingGIFs(limit: limit)
        
        do {
            let response = try await NetworkManager.shared.sendRequestAsync(modelType: GIFResponse.self, request)
            self.featuredGIFs = response.results
            self.errorMessage = nil
            self.isOffline = false
            
            await GIFCache.shared.cacheGIFs(response.results)
        } catch {
            
            if let cachedGIFs = await GIFCache.shared.getCachedGIFs() {
                self.featuredGIFs = cachedGIFs
                self.isOffline = true
                self.errorMessage = "Using cached data (offline mode)"
            } else {
                self.errorMessage = "Failed to fetch GIFs"
            }
        }
        
        isLoading = false
    }
    
    func searchGIFs(query: String, limit: Int = 10) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Search query is empty, fetching trending GIFs instead")
            await fetchTrendingGIFs(limit: limit)
            return
        }
        print("Searching GIFs for: \(query)")
        
        isLoading = true
        let request = APIRouter.SearchGIFs(query: query, limit: limit)
        
        do {
            let response = try await NetworkManager.shared.sendRequestAsync(modelType: GIFResponse.self, request)
            self.featuredGIFs = response.results
            print("Found \(response.results.count) GIFs")
            self.errorMessage = nil
            self.isOffline = false
        } catch {
            print("Error searching GIFs: \(error.localizedDescription)")
            self.errorMessage = "Failed to search GIFs"
        }
        
        isLoading = false
    }
}
