// MyApp.swift
import SwiftUI

@main
struct MyApp: App {
    @StateObject private var chatViewModel = ChatViewModel()
    
    var body: some Scene {
        WindowGroup {
            UserSelectionView()
                .environmentObject(chatViewModel)
        }
    }
}
