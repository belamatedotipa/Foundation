import Foundation
import SwiftUI

enum ErrorDescription: LocalizedStringKey {
    case regular = "error-subtitle-regular"
}

struct ErrorView: View {

    let description: ErrorDescription

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            LottieView(lottieFile: "error", contentMode: .scaleAspectFill)
                .frame(width: 48, height: 48)
            VStack(alignment: .leading, spacing: 4) {
                Text("error-title")
                    .font(.system(size: 16, weight: .bold))
                Text(description.rawValue)
                    .font(.system(size: 16, weight: .light))
                    .opacity(0.8)
            }
            Spacer()
        }
        .foregroundColor(.black)
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 42, trailing: 16))
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 40, x: 0, y: -4)
    }
}
