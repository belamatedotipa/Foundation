import Foundation
import SwiftUI

enum PredictionState: Equatable {
    case error
    case loading
    case newImageLoaded
    case completedPrediction
}

enum TrackViewState: Equatable {
    case prediction(_ : PredictionState)
    case underConstruction
}

struct TrackState {
    var item: TrackData
    var prediction: PixrayDTO?
    var viewState: TrackViewState
    let mockedSuggestions =  [TrackData(id: "5CQ30WqJwcep0pYcV4AMNc",
                                        title: "Stairway to heaven",
                                        artist: "Led Zeppelin",
                                        coverURL: "https://m.media-amazon.com/images/I/51h-cJeHf0L._AC_.jpg"),
                              TrackData(id: "1i8MaQec4fQXj1enX8ZWF4",
                                        title: "Boreal Kiss Pt. 1",
                                        artist: "Tim Hecker",
                                        coverURL: "https://f4.bcbits.com/img/a2000272884_10.jpg"),
                              TrackData(id: "2CVV8PtUYYsux8XOzWkCP0", title: "Subterranean Homesick Alien",
                                        artist: "Radiohead",
                                        coverURL: "https://upload.wikimedia.org/wikipedia/en/b/ba/Radioheadokcomputer.png")]
}
