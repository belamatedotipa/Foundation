import XCTest
@testable import Foundation_MVVM

class MockNetwork: Network {
    func cachedFetch<Type>(_ route: Route) async -> Result<Type, Error> where Type: Decodable, Type: Encodable {
        return .failure(NetworkError.serverConnectionFailed)
    }

    func request<Type>(_ route: Route) async -> Result<Type, Error> where Type: Decodable {
        return .failure(NetworkError.serverConnectionFailed)
    }
}

class MockAppCoordinator: AppCoordinating {

    var dependencyContainer: DependencyContainer

    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }

    func start() { }
    func showLogin() { }
    func showTrack() { }
    func showTrack(_: TrackData) { }

}

class FoundationMVVMTests: XCTestCase {

    var sut: SearchViewModel?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()

    }

    // MARK: testSomething_whenConditions_returnsResult
    func testTrigger_whenTap_returnsInitialState() {
        // Arrange
        sut = SearchViewModel(coordinator: MockAppCoordinator(dependencyContainer: DependencyContainer()),
                              spotifyRepository: SpotifyRepository(network: MockNetwork()),
                              state: SearchState(searchTerm: "",
                                                 items: [],
                                                 total: 0,
                                                 viewState: .initial))

        // Act
        sut?.trigger(.tap(1))

        // Assert
        XCTAssertTrue(sut?.state.viewState == .initial,
                      "Login state is \(String(describing: sut?.state.viewState)) after failure")
    }

    // TODO: failing
    func testTrigger_whenScrolledToEnd_returnsLoadingState() {
        // Arrange
        sut = SearchViewModel(coordinator: MockAppCoordinator(dependencyContainer: DependencyContainer()),
                              spotifyRepository: SpotifyRepository(network: MockNetwork()),
                              state: SearchState(searchTerm: "book",
                                                 items: [],
                                                 total: 20,
                                                 viewState: .initial))

        // Act
        sut?.trigger(.scrolledToEnd(index: 15))

        // Assert
        XCTAssertTrue(sut?.state.viewState == .loading,
                      "Login state is \(String(describing: sut?.state.viewState))")
    }

    // TODO: failing
        func testTrigger_whenSearch_returnsLoadinglState() {
        // Arrange
        sut = SearchViewModel(coordinator: MockAppCoordinator(dependencyContainer: DependencyContainer()),
                              spotifyRepository: SpotifyRepository(network: MockNetwork()),
                              state: SearchState(searchTerm: "book",
                                                 items: [],
                                                 total: 5,
                                                 viewState: .initial))

        // Act
            sut?.trigger(.search(for: "book"))

        // Assert
            XCTAssertTrue(sut?.state.viewState == .loading,
                          "Login state is \(String(describing: sut?.state.viewState))")
     }

    func testLoadMore_whenNumerOfItemsIsEqualWithTotalItems_returnsInitialState() {
        // Arrange
        sut = SearchViewModel(coordinator: MockAppCoordinator(dependencyContainer: DependencyContainer()),
                              spotifyRepository: SpotifyRepository(network: MockNetwork()),
                              state: SearchState(searchTerm: "",
                                                 items: [],
                                                 total: 0,
                                                 viewState: .initial))

        // Act
        sut?.loadMore(index: 0)

        // Assert
        XCTAssertTrue(sut?.state.viewState == .initial,
                      "Login state is \(String(describing: sut?.state.viewState)) after failure")
    }

    func testLoadMore_whenNumerOfItemsIsLessThanTotalItems_returnsLoadingState() {
        // Arrange
        sut = SearchViewModel(coordinator: MockAppCoordinator(dependencyContainer: DependencyContainer()),
                              spotifyRepository: SpotifyRepository(network: MockNetwork()),
                              state: SearchState(searchTerm: "",
                                                 items: [],
                                                 total: 5,
                                                 viewState: .initial))

        // Act
        sut?.loadMore(index: 0)

        // Assert
        XCTAssertTrue(sut?.state.viewState == .loading,
                      "Login state is \(String(describing: sut?.state.viewState))")
    }
}
