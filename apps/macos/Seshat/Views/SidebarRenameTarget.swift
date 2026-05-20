import Foundation

enum SidebarRenameTarget {
    case file(URL)
    case folder(URL)

    var url: URL {
        switch self {
        case .file(let url), .folder(let url): url
        }
    }
}
