import SDWebImageSwiftUI
import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("name") private var username: String = "User Name"
    @State private var searchText = ""
    @State private var searchTask: Task<Void, Never>?  // Task for debouncing
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                    .padding(.horizontal)

                if !isSearching {
                    Text("Welcome back, \(username)!")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.indigo)
                        .padding(.top, 20)
                }

                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }

                if viewModel.isOffline {
                    Text("Offline Mode")
                        .foregroundColor(.orange)
                        .padding(.horizontal)
                }

                gifGridView
                    .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Home")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileScreen()) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.indigo)
                    }
                }
            }
            .task {
                if searchText.isEmpty {
                    await viewModel.fetchTrendingGIFs()
                }
            }
        }
    }
}

// MARK: - Search Bar Extensions
extension HomeScreen {
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search GIFs...", text: $searchText)
                .autocorrectionDisabled()
                .onChange(of: searchText) { newValue in
                    searchTask?.cancel()
                    searchTask = Task {
                        if newValue.isEmpty {
                            await viewModel.fetchTrendingGIFs()
                        } else {
                            await viewModel.searchGIFs(query: newValue)
                        }
                    }
                }

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    isSearching = false
                    searchTask?.cancel()
                    Task {
                        await viewModel.fetchTrendingGIFs()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)

    }

    var gifGridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))], spacing: 18)
            {
                ForEach(viewModel.featuredGIFs) { gif in
                    NavigationLink(destination: DetailScreen()) {
                        CachedGifView(gif: gif)
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
        }
        .refreshable {
            if searchText.isEmpty {
                await viewModel.fetchTrendingGIFs()
            } else {
                await viewModel.searchGIFs(query: searchText)
            }
        }
    }
}

#Preview {
    HomeScreen()
}
