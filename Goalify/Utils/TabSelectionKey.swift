import SwiftUI

private struct TabSelectionKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

extension EnvironmentValues {
    var tabSelection: Int {
        get { self[TabSelectionKey.self] }
        set { self[TabSelectionKey.self] = newValue }
    }
}