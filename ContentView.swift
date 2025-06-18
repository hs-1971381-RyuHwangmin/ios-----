// LanguageExchangeApp.swift
import SwiftUI
import AVFoundation

enum User: String, Codable {
    case lena
    case hwangmin
    
    var name: String {
        switch self {
        case .lena: return "레나"
        case .hwangmin: return "황민"
        }
    }
    
    var profileImage: String {
        switch self {
        case .lena: return "person.circle.fill"
        case .hwangmin: return "person.circle.fill"
        }
    }
}

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let user: User
    let text: String
    let time: String
    var isRead: Bool = false
}

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var selectedVoiceIdentifierForLena: String?
    @Published var selectedVoiceIdentifierForHwangmin: String?
    let synthesizer = AVSpeechSynthesizer()
    
    func sendMessage(from user: User, text: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let message = ChatMessage(user: user, text: text, time: formatter.string(from: Date()), isRead: false)
        messages.append(message)
    }
    
    func markMessagesAsRead(for user: User) {
        for i in 0..<messages.count {
            if messages[i].user != user {
                messages[i].isRead = true
            }
        }
    }
    
    func speak(text: String, language: String, for user: User) {
        let selectedVoiceIdentifier = user == .lena ? selectedVoiceIdentifierForLena : selectedVoiceIdentifierForHwangmin
        guard let voice = selectedVoiceIdentifier.flatMap({ AVSpeechSynthesisVoice(identifier: $0) }) ?? AVSpeechSynthesisVoice(language: language) else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        synthesizer.speak(utterance)
    }
    
    func voices(for language: String) -> [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix(language) }
    }
}

struct UserSelectionView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ChatView(currentUser: .lena)) {
                    HStack {
                        Image(systemName: User.lena.profileImage)
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("레나 화면")
                    }
                }
                NavigationLink(destination: ChatView(currentUser: .hwangmin)) {
                    HStack {
                        Image(systemName: User.hwangmin.profileImage)
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("황민 화면")
                    }
                }
            }
            .navigationTitle("사용자 선택")
        }
    }
}

struct ChatView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    let currentUser: User
    @State private var inputText = ""
    @State private var showVoicePicker = false
    @State private var showVoiceSetting = false
    
    var otherUser: User {
        currentUser == .lena ? .hwangmin : .lena
    }
    
    var voiceLanguage: String {
        currentUser == .lena ? "ko" : "ja"
    }
    
    var selectedVoiceBinding: Binding<String?> {
        currentUser == .lena ? $viewModel.selectedVoiceIdentifierForLena : $viewModel.selectedVoiceIdentifierForHwangmin
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text(otherUser.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                Spacer()
                Button(action: {
                    showVoiceSetting.toggle()
                }) {
                    Image(systemName: "gearshape")
                        .imageScale(.large)
                }
            }
            .padding()
            
            ScrollView {
                ForEach(viewModel.messages) { message in
                    HStack(alignment: .bottom, spacing: 8) {
                        if message.user != currentUser {
                            Image(systemName: message.user.profileImage)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        
                        VStack(alignment: message.user == currentUser ? .trailing : .leading, spacing: 4) {
                            Text(message.text)
                                .padding(10)
                                .background(message.user == currentUser ? Color.blue.opacity(0.1) : Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .onTapGesture {
                                    let lang = currentUser == .lena ? "ko-KR" : "ja-JP"
                                    viewModel.speak(text: message.text, language: lang, for: currentUser)
                                }
                            
                            HStack(spacing: 4) {
                                Text(message.time)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                if message.user == currentUser && message.isRead {
                                    Text("읽음")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        if message.user == currentUser {
                            Image(systemName: message.user.profileImage)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: message.user == currentUser ? .trailing : .leading)
                    .padding(.horizontal)
                }
            }
            .onAppear {
                viewModel.markMessagesAsRead(for: currentUser)
            }
            
            HStack {
                TextField("메시지 입력", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    viewModel.sendMessage(from: currentUser, text: inputText)
                    inputText = ""
                }) {
                    Image(systemName: "paperplane.fill")
                }
            }
            .padding()
            
            if showVoiceSetting {
                VStack(spacing: 10) {
                    Text("보이스 설정")
                        .font(.headline)
                    Picker("음성 선택", selection: selectedVoiceBinding) {
                        ForEach(viewModel.voices(for: voiceLanguage), id: \ .identifier) { voice in
                            Text(voice.name).tag(voice.identifier as String?)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                    .clipped()
                }
                .padding()
            }
        }
        .navigationTitle("")
    }
}
