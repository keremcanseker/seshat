import Foundation

/// Result of an attempted write that guards against clobbering an external edit
/// (concurrent CLI write, Dropbox sync, `vim` save) made since the file was loaded.
enum WriteOutcome: Equatable {
    case wrote(modificationDate: Date?)
    case externalChange(remoteContent: String)
}
