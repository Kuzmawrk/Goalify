import SwiftUI

public struct LocalStorage {
    public static let shared = LocalStorage()
    
    @AppStorage("APP_LINK") public var savedLink = ""
    @AppStorage("FIRST_LAUNCH") public var isFirstLaunch = true
}

enum ViewState: Equatable {
    case main, service
}

