import Foundation
import SwiftUI

enum SearchViewState {
    case initial, presentingResults, loading, error
}

struct SearchState {
    var searchTerm = String()
    var items = [TrackData]()
    var total: Int?
    var viewState: SearchViewState = .initial
}
