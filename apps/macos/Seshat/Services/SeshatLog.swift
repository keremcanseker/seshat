import Foundation

@inlinable
func seshatLog(_ message: @autoclosure () -> String) {
    #if DEBUG
    FileHandle.standardError.write(Data("[seshat] \(message())\n".utf8))
    #endif
}
