import SwiftUI

extension FocusedValues {
    /// Set by the reader showing the key window's document so the File menu can export it.
    @Entry var exportPDF: (@MainActor () -> Void)?

    /// Same document, sent to the system print panel through the PDF pipeline.
    @Entry var printDocument: (@MainActor () -> Void)?
}
