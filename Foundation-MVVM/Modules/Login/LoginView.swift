import Foundation
import Combine
import SwiftUI
import PopupView

private enum Constants {
    static let minimumPadding: CGFloat = 4
    static let smallPadding: CGFloat = 10
    static let largePadding: CGFloat = 20
    static let buttonHeight: CGFloat = 50
    static let buttonWidht: CGFloat = 214
    static let iconSize: CGFloat = 30
    static let titleFontSize: CGFloat = 38
    static let bodyFontSize: CGFloat = 16
}

private enum Strings {
    static let buttonTitle = LocalizedStringKey("login-button-title")
    static let title = LocalizedStringKey("login-title")
    static let USPs = [String(localized: "usp1"),
                       String(localized: "usp2"),
                       String(localized: "usp3")]
}

struct LoginView: View {

    @EnvironmentObject var viewModel: AnyViewModel<LoginState, LoginInput>
    @State var showingPopup = false
    @State private var isShowingCTA = true

    let gradient = LinearGradient(colors: [Color.orange, Color.green],
                                  startPoint: .top, endPoint: .bottom)

    @ViewBuilder
    func buttonContent() -> some View {
        switch viewModel.state {
        case .initial, .error:
            HStack {
                Image("spotify")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.iconSize)
                Text(Strings.buttonTitle)
                    .foregroundColor(.white)
                    .font(.system(size: Constants.bodyFontSize, weight: .medium, design: .rounded))
            }
            .padding(Constants.smallPadding)
        case .loading:
            HStack {
                Spacer()
                LottieView(lottieFile: "loader", contentMode: .scaleAspectFill)
                Spacer()
            }
            .frame(width: Constants.buttonWidht, height: Constants.buttonHeight)
        }
    }

    var body: some View {
        ZStack {
            gradient
                .opacity(0.20)
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .center, spacing: Constants.largePadding) {
                    if isShowingCTA {
                        VStack(alignment: .leading) {
                            Text(Strings.title)
                                .font(.custom("GalanoGrotesqueDEMO-Bold",
                                              size: Constants.titleFontSize))
                                .opacity(0.85)
                                .padding(.bottom, Constants.minimumPadding)
                            VStack(alignment: .leading,
                                   spacing: Constants.smallPadding) {
                                ForEach(Strings.USPs, id: \.self) { usp in
                                    Text("✓ "+usp)
                                }
                            }
                                   .padding(.bottom, Constants.largePadding)
                                   .font(.system(size: Constants.bodyFontSize))
                                   .opacity(0.8)
                        }
                        .transition(.scale)
                    }
                    buttonContent()
                        .tint(Color(uiColor: UIColor(red: 28,
                                                     green: 204,
                                                     blue: 91,
                                                     alpha: 1)))
                        .background(Color("spotifyGreen"))
                        .cornerRadius(Constants.buttonHeight/2)
                        .onTapGesture {
                            isShowingCTA.toggle()
                            viewModel.trigger(.tap)
                        }
                }
                .navigationBarHidden(true)
            }
        }
        .onChange(of: self.viewModel.state, perform: { newValue in
            showingPopup = (newValue == .error)
        })
        .popup(isPresented: $showingPopup,
               type: .toast,
               position: .bottom,
               animation: .spring(),
               autohideIn: 3.5) { ErrorView(description: .regular) }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
