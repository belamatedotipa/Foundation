import SwiftUI

private enum Constants {
    static let minimumPadding: CGFloat = 0
    static let smallPadding: CGFloat = 5
    static let largePadding: CGFloat = 15
    static let imageSize: CGFloat = 50
    static let bodyFontSize: CGFloat = 14
}

struct ListItemView: View {

    let viewData: TrackData

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: viewData.coverURL),
                       content: { image in
                image.resizable()
                .aspectRatio(contentMode: .fit)},
                       placeholder: { ProgressView() })
            .frame(maxWidth: Constants.imageSize,
                   minHeight: Constants.imageSize,
                   maxHeight: Constants.imageSize)
            .padding(.vertical, Constants.largePadding/2)
            .padding(.leading, Constants.largePadding)
            .padding(.trailing, Constants.smallPadding)
            VStack(alignment: .leading,
                   spacing: Constants.smallPadding) {
                Text(viewData.title)
                    .font(.system(size: Constants.bodyFontSize))
                Text(viewData.artist)
                    .foregroundColor(Color("lightGray"))
            }.frame(maxHeight: Constants.imageSize)
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(.horizontal, Constants.minimumPadding)
        .frame(maxWidth: .infinity)
    }
}

// swiftlint:disable line_length
struct ListItemView_Previews: PreviewProvider {

    static let previewData = TrackData(id: "",
                                       title: "Ready to Start",
                                       artist: "Arcade Fire",
                                       coverURL: "https://upload.wikimedia.org/wikipedia/en/8/81/Arcade_Fire_-_The_Suburbs.jpg")
    static var previews: some View {
        ListItemView(viewData: previewData)
    }
}
