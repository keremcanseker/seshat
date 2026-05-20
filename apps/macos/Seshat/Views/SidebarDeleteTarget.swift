import Foundation

enum SidebarDeleteTarget {
    case file(LibraryFile)
    case folder(LibraryFolder)

    var url: URL {
        switch self {
        case .file(let file): file.url
        case .folder(let folder): folder.url
        }
    }
}
