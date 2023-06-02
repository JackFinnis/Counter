//
//  RootView.swift
//  Counter
//
//  Created by Jack Finnis on 16/05/2023.
//

import SwiftUI
import MessageUI

struct RootView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("count") var count = 0
    @State var showShareSheet = false
    @State var showEmailSheet = false
    
    @State var flashUp = false
    @State var flashDown = false
    @AppStorage("shouldFlash") var shouldFlash = true
    @AppStorage("shouldTap") var shouldTap = true
    
    var color: Color { .primary }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(flashUp ? .systemGreen : (flashDown ? .systemRed : .systemBackground)).ignoresSafeArea()
                    .opacity(colorScheme == .light ? 1 : 0.3)
                    .animation(.default, value: flashUp)
                    .animation(.default, value: flashDown)
                
                Text(String(count))
                    .font(.system(size: 150).weight(.semibold).monospacedDigit())
                    .foregroundColor(color)
                
                TwoFingerTapView {
                    count -= 1
                    if shouldTap {
                        Haptics.tap()
                    }
                    if shouldFlash {
                        flashDown = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            flashDown = false
                        }
                    }
                }
                .onTapGesture(count: 1) {
                    count += 1
                    if shouldTap {
                        Haptics.tap()
                    }
                    if shouldFlash {
                        flashUp = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            flashUp = false
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Menu {
                        Section {
                            Label("Tap with one finger to increment", systemImage: "circlebadge")
                            Label("Tap with two fingers to decrement", systemImage: "circle.grid.2x1")
                        }
                        Section {
                            Toggle(isOn: $shouldFlash) {
                                Label("Flash on tap", systemImage: "rays")
                            }
                            Toggle(isOn: $shouldTap) {
                                Label("Vibrate on tap", systemImage: "iphone.radiowaves.left.and.right")
                            }
                        }
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Menu {
                        Button {
                            showShareSheet = true
                        } label: {
                            Label("Share the App", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            Store.requestRating()
                        } label: {
                            Label("Rate the App", systemImage: "star")
                        }
                        Button {
                            Store.writeReview()
                        } label: {
                            Label("Write a Review", systemImage: "quote.bubble")
                        }
                        if MFMailComposeViewController.canSendMail() {
                            Button {
                                showEmailSheet.toggle()
                            } label: {
                                Label("Send us Feedback", systemImage: "envelope")
                            }
                        } else if let url = Emails.mailtoUrl(subject: "\(Constants.name) Feedback"), UIApplication.shared.canOpenURL(url) {
                            Button {
                                UIApplication.shared.open(url)
                            } label: {
                                Label("Send us Feedback", systemImage: "envelope")
                            }
                        }
                    } label: {
                        HStack {
                            Text(Constants.name)
                                .font(.headline)
                            MenuChevron()
                        }
                        .foregroundColor(.primary)
                    }
                    .sharePopover(url: Constants.appUrl, showsSharedAlert: true, isPresented: $showShareSheet)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        count = 0
                        Haptics.success()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            }
        }
        .emailSheet(recipient: Constants.email, subject: "\(Constants.name) Feedback", isPresented: $showEmailSheet)
        .navigationViewStyle(.stack)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
