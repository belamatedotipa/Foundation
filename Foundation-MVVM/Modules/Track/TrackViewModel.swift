import Foundation
import UIKit

enum TrackInput {
    case tap(_ index: Int)
    case onAppear
}

final class TrackViewModel: ViewModel {

    @Published internal var state: TrackState
    private let coordinator: AppCoordinator
    private let pixrayRepository: PixrayRepository

    private let supportedTracks = ["5CQ30WqJwcep0pYcV4AMNc",
                           "1i8MaQec4fQXj1enX8ZWF4",
                           "2CVV8PtUYYsux8XOzWkCP0"]

    init(coordinator: AppCoordinator,
         pixrayRepository: PixrayRepository,
         item: TrackData
    ) {
        self.coordinator = coordinator
        self.pixrayRepository = pixrayRepository
        if supportedTracks.contains(item.id) {
            state = .init(item: item,
                          viewState: .prediction(.loading))
        } else {
            state = .init(item: item,
                          viewState: .underConstruction)
        }
    }

    fileprivate func fetchPrediction() {
        guard case .prediction = state.viewState else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            let result = self.pixrayRepository.getPrediction(for: self.state.item.id)
            switch result {
            case .success(let response):
                self.state.prediction = response
                if response.finishedPrediction {
                    self.state.viewState = .prediction(.completedPrediction)
                    return
                } else {
                    self.state.viewState = .prediction(.newImageLoaded)
                    self.fetchPrediction()
                }
            case .failure:
                self.state.viewState = .prediction(.error)
            }
        }
    }

    func trigger(_ input: TrackInput) {
        switch input {
        case .onAppear:
            fetchPrediction()
        case .tap(let index):
            coordinator.showTrack(state.mockedSuggestions[index])
        }
    }
}
