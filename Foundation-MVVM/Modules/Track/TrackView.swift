import Foundation
import Combine
import SwiftUI
import Shimmer

private enum Strings {
    static let suggestion = LocalizedStringKey("prediction-suggestion")
    static let title = LocalizedStringKey("prediction-title")
    static let predictionRunning = LocalizedStringKey("prediction-running")
    static let predictionCompleted = LocalizedStringKey("prediction-completed")
}

private enum Constants {
    static let smallPadding: CGFloat = 5
    static let standardPadding: CGFloat = 10
    static let largePadding: CGFloat = 20
    static let smallLottieSize: CGFloat = 48
    static let largeLottieSize: CGFloat = 150
}

struct TrackView: View {

    @EnvironmentObject var viewModel: AnyViewModel<TrackState, TrackInput>
    @State var showingPopup = false

    let gradient = LinearGradient(colors: [Color.orange, Color.green],
                                  startPoint: .top, endPoint: .bottom)

    var body: some View {
        ZStack {
            gradient
                .opacity(0.25)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    VStack(spacing: Constants.standardPadding) {
                        image()
                            .padding(.bottom, Constants.largePadding)
                        VStack(alignment: .leading, spacing: Constants.smallPadding) {
                            Text(Strings.title)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.custom("GalanoGrotesqueDEMO-Bold",
                                              size: 38))
                            Text(viewModel.state.item.title)
                            Text("by \(viewModel.state.item.artist)")
                                .font(.footnote)
                                .padding(.bottom, Constants.largePadding)
                                .foregroundColor(Color("lightGray"))
                            Text(Strings.suggestion)
                                .font(.custom("GalanoGrotesqueDEMO-Bold",
                                              size: 38))
                            ForEach(Array(viewModel.state.mockedSuggestions.enumerated()),
                                    id: \.element.id) { index, element in
                                ListItemView(viewData: element)
                                    .onTapGesture {
                                        viewModel.trigger(.tap(index))
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
        }
        .onChange(of: self.viewModel.state.viewState, perform: { newValue in
            showingPopup = (newValue == .prediction(.error))
        })
        .popup(isPresented: $showingPopup,
               type: .toast,
               position: .bottom,
               animation: .spring(),
               autohideIn: 3.5) { ErrorView(description: .regular) }
            .onAppear {
                viewModel.trigger(.onAppear)
            }
    }

    @ViewBuilder
    func image() -> some View {
        switch viewModel.state.viewState {
        case .prediction(let predictionState):
            switch predictionState {
            case .error:
                EmptyView()
            case .newImageLoaded:
                VStack {
                    Image(viewModel.state.prediction?.image ?? "")
                        .resizable()
                        .scaledToFill()
                    HStack(spacing: 0) {
                        LottieView(lottieFile: "loader", contentMode: .scaleAspectFill)
                            .frame(width: 90, height: Constants.smallLottieSize)
                            .padding(.horizontal, -Constants.largePadding)
                        Text(Strings.predictionRunning)
                    }.padding(.top, Constants.standardPadding)
                }
            case .completedPrediction:
                VStack {
                    Image(viewModel.state.prediction?.image ?? "")
                        .resizable()
                        .scaledToFill()
                    HStack(spacing: Constants.standardPadding) {
                        LottieView(lottieFile: "checkmark", loopMode: .playOnce)
                            .frame(width: Constants.smallLottieSize, height: Constants.smallLottieSize)
                        Text(Strings.predictionCompleted)
                    }.padding(.top, Constants.standardPadding)
                }
            case .loading:
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: .infinity)
                    .aspectRatio(1.0, contentMode: .fill)
                    .shimmering()
            }

        case .underConstruction:
            LottieView(lottieFile: "construction", loopMode: .loop)
                .frame(width: Constants.largeLottieSize,
                       height: Constants.largeLottieSize,
                       alignment: .center)
                .opacity(0.8)
        }
    }

    struct TrackView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                TrackView()
                TrackView()
                    .preferredColorScheme(.dark)
            }
        }

    }
}
