//
//  CounterView.swift
//  Counter
//
//  Created by Jack Finnis on 17/02/2024.
//

import SwiftUI
import MessageUI
import StoreKit

struct CounterView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.requestReview) var requestReview
    @AppStorage("count") var count = 0
    @State var down = false
    @State var showEmailSheet = false
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.roundedSystemFont(style: .headline)]
    }
    
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
                    .disabled(count == 0)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .font(.headline)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Help") {
                        ControlGroup {
                            Label {
                                Text("Tap on the left to decrement")
                            } icon: {
                                getIcon(color: .red)
                            }
                            Label {
                                Text("Tap on the right to increment")
                            } icon: {
                                getIcon(color: .green)
                            }
                        }
                    }
                    .menuStyle(.button)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .font(.headline)
                }
            }
            .fontDesign(.rounded)
        }
    }
    
    func getIcon(color: Color) -> Image {
        Image(uiImage: UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: UIColor(color.opacity(0.5))))!)
    }
}

#Preview {
    CounterView()
}
