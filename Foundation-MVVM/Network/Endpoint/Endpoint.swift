import Foundation

struct Endpoint: Hashable {

    private var base: URL
    private var path: String

    init(base: URL, path: String) {
        self.base = base
        self.path = path
    }

    var url: URL {
        return base.appendingPathComponent(path)
    }
}
