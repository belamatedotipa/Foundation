import Foundation
import SwiftUI

protocol AppCoordinating {
    var dependencyContainer: DependencyContainer { get }

    func start()
    func showLogin()
    func showTrack(_: TrackData)

}

final class AppCoordinator: AppCoordinating {
    internal let dependencyContainer: DependencyContainer
    private let navigationController: UINavigationController

    init(dependencyContainer: DependencyContainer,
         navigationController: UINavigationController) {
        self.dependencyContainer = dependencyContainer
        self.navigationController = navigationController
    }

    // swiftlint:disable line_length
    func start() {
        let viewModel: AnyViewModel<SearchState, SearchItemInput> = AnyViewModel(SearchViewModel(coordinator: self,
                                                                                                 spotifyRepository: dependencyContainer.spotifyRepository))
        let swiftUIView = SearchView().environmentObject(viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController.pushViewController(hostingController,
                                                animated: false) {
            self.showLogin()
        }
    }

    func showLogin() {
        let viewModel: AnyViewModel<LoginState,
                                    LoginInput> = AnyViewModel(LoginViewModel(coordinator: self,
                                                                              spotifyController: dependencyContainer.spotifyController))
        let swiftUIView = LoginView().environmentObject(viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.modalPresentationStyle = .fullScreen

        navigationController.present(hostingController,
                                     animated: false)
    }

    func showTrack(_ item: TrackData) {
        let viewModel: AnyViewModel<TrackState, TrackInput> = AnyViewModel(TrackViewModel(coordinator: self,
                                                                                          pixrayRepository: dependencyContainer.pixrayRepository, item: item))
        let swiftUIView = TrackView().environmentObject(viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController.navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationController.navigationBar.tintColor = .white
        navigationController.pushViewController(hostingController,
                                                animated: true)
    }

    func dismiss() {
        self.navigationController.dismiss(animated: true)
    }
}
