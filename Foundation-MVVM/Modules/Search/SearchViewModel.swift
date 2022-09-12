import Foundation
import UIKit

enum SearchItemInput {
    case tap(_ index: Int)
    case scrolledToEnd(index: Int)
    case search(for: String)
    case cancelSearch
}

struct TrackData: Identifiable {
    var id: String
    var title: String
    var artist: String
    var coverURL: String
}

final class SearchViewModel: ViewModel {

    @Published internal var state: SearchState
    private let coordinator: AppCoordinating
    private let spotifyRepository: SpotifyRepository

    init(coordinator: AppCoordinating,
         spotifyRepository: SpotifyRepository,
         state: SearchState = SearchState(items: [], total: nil, viewState: .initial)) {
        self.coordinator = coordinator
        self.spotifyRepository = spotifyRepository
        self.state = state
    }

    func trigger(_ input: SearchItemInput) {
        switch input {
        case .tap(let index):
            let track = state.items[index]
            coordinator.showTrack(track)
        case .scrolledToEnd(let index):
            DispatchQueue.main.async {
                Task {
                    self.loadMore(index: index)
                }
            }
        case .search(let searchTerm):
                state.items = []
                state.searchTerm = searchTerm
                DispatchQueue.main.async {
                    Task {
                        await self.loadData()
                    }
                }
        case .cancelSearch:
            state.viewState = .initial
        }
    }

    @MainActor fileprivate func loadData(with offset: Int = 0) async {

        let result = await spotifyRepository.searchTracks(for: state.searchTerm,
                                                          with: offset)
        switch result {
        case .success(let response):
            state.items += response.tracks.items.map {
                TrackData(id: $0.id,
                          title: $0.name,
                          artist: $0.artists.first?.name ?? "Unknown artist",
                          coverURL: $0.album.images.last?.url ?? "")
            }
            state.total = response.tracks.total
            state.viewState = .presentingResults
        case .failure:
            state.viewState = .error
        }
    }

    internal func loadMore(index: Int) {
        if let total = state.total,
           total > state.items.count,
           state.viewState != .loading {
            state.viewState = .loading
            Task {
                await loadData(with: state.items.count)
            }
        }
    }
}
