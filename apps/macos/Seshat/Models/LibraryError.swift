import Foundation

enum LibraryError: LocalizedError, Equatable {
    case invalidName
    case alreadyExists
    case notInLibrary
    case notFound
    case writeFailed
    case folderNotEmpty
    case sameLocation

    var errorDescription: String? {
        switch self {
        case .invalidName:
            "That name isn’t valid. Avoid empty names and characters like / or :."
        case .alreadyExists:
            "An item with that name already exists here."
        case .notInLibrary:
            "That item isn’t in your Seshat library."
        case .notFound:
            "The file or folder could not be found."
        case .writeFailed:
            "Couldn’t update the library on disk."
        case .folderNotEmpty:
            "Move or delete the files in this folder first."
        case .sameLocation:
            "The item is already in that folder."
        }
    }
}
