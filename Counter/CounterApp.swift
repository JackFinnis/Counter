//
//  CounterApp.swift
//  Counter
//
//  Created by Jack Finnis on 16/05/2023.
//

import SwiftUI
import MessageUI
import StoreKit


@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.requestReview) var requestReview
    @AppStorage("count") var count = 0
    @State var down = false
    @State var showEmailSheet = false
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 0) {
                Button {
                    down = true
                    count -= 1
                    Haptics.tap()
                } label: {
                    Color.red
                }
                Button {
                    down = false
                    count += 1
                    Haptics.tap()
                } label: {
                    Color.green
                }
            }
            .buttonStyle(.plain)
            .opacity(0.1)
            .overlay {
                Text(String(count))
                    .fontDesign(.rounded)
                    .font(.system(size: 150))
                    .fontWeight(.medium)
                    .monospacedDigit()
                    .contentTransition(.numericText(countsDown: down))
                    .animation(.default, value: count)
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea()
            .navigationTitle(Constants.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDocument(Constants.appURL, preview: SharePreview(Constants.name, image: Image(.logo)))
            .emailSheet(recipient: Constants.email, subject: "\(Constants.name) Feedback", isPresented: $showEmailSheet)
            .toolbarTitleMenu {
                Button {
                    requestReview()
                } label: {
                    Label("Rate \(Constants.name)", systemImage: "star")
                }
                Button {
                    AppStore.writeReview()
                } label: {
                    Label("Write a Review", systemImage: "quote.bubble")
                }
                if MFMailComposeViewController.canSendMail() {
                    Button {
                        showEmailSheet.toggle()
                    } label: {
                        Label("Send us Feedback", systemImage: "envelope")
                    }
                } else if let url = Emails.url(subject: "\(Constants.name) Feedback"), UIApplication.shared.canOpenURL(url) {
                    Button {
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Send us Feedback", systemImage: "envelope")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        down = count > 0
                        count = 0
                        Haptics.success()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Help") {
                        Text("Tap on the right increment")
                        Text("Tap on the left decrement")
                    }
                }
            }
        }
    }
}

#Preview {
    RootView()
}
