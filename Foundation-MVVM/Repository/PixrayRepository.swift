import Foundation

struct PixrayDTO {
    var image: String
    var finishedPrediction: Bool
}

enum ImageError: Error {
    case indexDoesNotExist, nameDoesNotExist
}

struct ImageHelper {
    let numberOfImages: Int
    let id: String
    let name: String

    func imageName(nextImage: Int) -> String? {
        if numberOfImages >= nextImage {
            return "\(name)_\(nextImage)"
        } else {
            return nil
        }
    }
}

final class PixrayRepository {

    private var nextImage: Int = 0
    private let images: [ImageHelper] = [ImageHelper(numberOfImages: 26,
                                                     id: "1i8MaQec4fQXj1enX8ZWF4",
                                                     name: "kiss"),
                                         ImageHelper(numberOfImages: 20,
                                                     id: "2CVV8PtUYYsux8XOzWkCP0",
                                                     name: "alien"),
                                         ImageHelper(numberOfImages: 6,
                                                     id: "5CQ30WqJwcep0pYcV4AMNc",
                                                     name: "heaven")
    ]

    func getPrediction(for id: String) -> Result<PixrayDTO, Error> {
        let helper = images.filter {
            $0.id == id
        }.first
        if let first = helper, let resource = first.imageName(nextImage: nextImage) {
            nextImage += 1
            let nextResourceExists: Bool = first.imageName(nextImage: nextImage) != nil
            if !nextResourceExists { nextImage = 0 }
            let response = PixrayDTO(image: resource, finishedPrediction: !nextResourceExists)
            return .success(response)
        } else {
            return .failure(ImageError.nameDoesNotExist)
        }
    }
}
