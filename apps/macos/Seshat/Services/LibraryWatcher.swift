import CoreServices
import Foundation

final class LibraryWatcher: @unchecked Sendable {
    private var stream: FSEventStreamRef?
    private let onChange: @Sendable () -> Void
    private let queue = DispatchQueue(label: "io.seshat.LibraryWatcher")

    init(onChange: @escaping @Sendable () -> Void) {
        self.onChange = onChange
    }

    deinit {
        stopInternal()
    }

    func start(rootURL: URL) {
        queue.sync {
            stopInternal()

            let info = Unmanaged.passUnretained(self).toOpaque()
            var context = FSEventStreamContext(
                version: 0,
                info: info,
                retain: nil,
                release: nil,
                copyDescription: nil
            )

            let paths = [rootURL.path] as CFArray
            let flags = UInt32(
                kFSEventStreamCreateFlagFileEvents |
                kFSEventStreamCreateFlagUseCFTypes |
                kFSEventStreamCreateFlagNoDefer
            )

            let callback: FSEventStreamCallback = { _, info, _, _, _, _ in
                guard let info else { return }
                let watcher = Unmanaged<LibraryWatcher>.fromOpaque(info).takeUnretainedValue()
                watcher.onChange()
            }

            guard let newStream = FSEventStreamCreate(
                kCFAllocatorDefault,
                callback,
                &context,
                paths,
                FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
                0.4,
                flags
            ) else { return }

            FSEventStreamSetDispatchQueue(newStream, .main)
            FSEventStreamStart(newStream)
            stream = newStream
        }
    }

    func stop() {
        queue.sync {
            stopInternal()
        }
    }

    private func stopInternal() {
        guard let stream else { return }
        FSEventStreamStop(stream)
        FSEventStreamInvalidate(stream)
        FSEventStreamRelease(stream)
        self.stream = nil
    }
}
