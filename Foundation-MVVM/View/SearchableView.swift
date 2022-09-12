import Foundation
import SwiftUI

struct SearchableView<Content: View>: View {
    @Environment(\.isSearching) var isSearching
    let content: (Bool) -> Content

    var body: some View {
        content(isSearching)
    }

    init(@ViewBuilder content: @escaping (Bool) -> Content) {
        self.content = content
    }
}
