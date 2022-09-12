import Foundation
import Combine
import SwiftUI

private enum Constants {
    static let minimumPadding: CGFloat = 0
    static let largePadding: CGFloat = 50
    static let lottieSize: CGFloat = 200
    static let bodyFontSize: CGFloat = 16
}

private enum Strings {
    static let emptyState = LocalizedStringKey("empty-state")
}

struct SearchView: View {

    @EnvironmentObject var viewModel: AnyViewModel<SearchState, SearchItemInput>
    @Environment(\.dismissSearch) var dismissSearch
    @State var showingPopup = false
    @State var searchTerm: String = ""

    let gradient = LinearGradient(colors: [Color.orange, Color.green],
                                  startPoint: .top, endPoint: .bottom)

    var body: some View {
        ZStack {
            gradient
                .opacity(0.25)
                .ignoresSafeArea()
            VStack {
                SearchableView { isSearching in
                    EmptyView()
                        .onChange(of: isSearching) { searching in
                            if !searching {
                                viewModel.trigger(.cancelSearch)
                            }
                        }
                }
                .searchable(text: $searchTerm)
                .onSubmit(of: .search) {
                    viewModel.trigger(.search(for: searchTerm))
                }
                resultView()
                if viewModel.viewState == .loading {
                    ProgressView()
                }

            }
        }
        .searchable(text: $searchTerm)
        .onChange(of: self.viewModel.state.viewState, perform: { newValue in
             showingPopup = (newValue == .error)
        })
        .popup(isPresented: $showingPopup,
               type: .toast,
               position: .bottom,
               animation: .spring(),
               autohideIn: 3.5) { ErrorView(description: .regular) }
            .onAppear {
                let coloredNavAppearance = UINavigationBarAppearance()
                coloredNavAppearance.configureWithTransparentBackground()
                coloredNavAppearance.backgroundColor =  UIColor(Color.black.opacity(0.1))
                coloredNavAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                UINavigationBar.appearance().standardAppearance = coloredNavAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
            }
    }

    @ViewBuilder
    func resultView() -> some View {
        if viewModel.state.viewState == .initial {
            VStack(spacing: Constants.largePadding) {
                LottieView(lottieFile: "astronaut", contentMode: .scaleAspectFit)
                    .frame(maxHeight: Constants.lottieSize)
                Text(Strings.emptyState)
                    .font(.system(size: Constants.bodyFontSize))
            }
            .opacity(0.3)
            .frame(maxWidth: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: Constants.minimumPadding) {
                    ForEach(Array(viewModel.state.items.enumerated()), id: \.element.id) { index, element in

                        ListItemView(viewData: TrackData(id: element.id,
                                                         title: element.title,
                                                         artist: element.artist,
                                                         coverURL: element.coverURL))
                        .onTapGesture {
                            viewModel.trigger(.tap(index))
                        }
                        .onAppear {
                            if index == viewModel.state.items.count-5 {
                                viewModel.trigger(.scrolledToEnd(index: index))
                            }
                        }
                        .onTapGesture {
                            viewModel.trigger(.tap(index))
                        }
                    }
                }
            }
        }
    }
}
