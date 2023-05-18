//
//  RootView.swift
//  Counter
//
//  Created by Jack Finnis on 16/05/2023.
//

import SwiftUI
import MessageUI

struct RootView: View {
    @AppStorage("count") var count = 0
    @State var showShareSheet = false
    @State var showEmailSheet = false
    
    var body: some View {
        Color.indigo.ignoresSafeArea()
            .overlay {
                Text(String(count))
                    .font(.system(size: 200).weight(.bold).monospaced())
                    .foregroundColor(.white)
            }
            .overlay {
                TwoFingerTapView {
                    if count != 0 {
                        count -= 1
                    }
                }
            }
            .onTapGesture(count: 1) {
                count += 1
            }
            .overlay(alignment: .top) {
                HStack {
                    Menu {
                        Button {
                            showShareSheet.toggle()
                        } label: {
                            Label("Share \(Constants.name)", systemImage: "square.and.arrow.up")
                        }
                        Button {
                            Store.requestRating()
                        } label: {
                            Label("Rate \(Constants.name)", systemImage: "star")
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
                        Image(systemName: "info.circle")
                    }
                    .font(.title)
                    
                    Spacer()
                    Button("Reset") {
                        count = 0
                        Haptics.tap()
                    }
                    .font(.title2)
                    
                    Spacer()
                    Menu {
                        Button {} label: {
                            Label("Tap with one finger to increment", systemImage: "circlebadge")
                        }
                        Button {} label: {
                            Label("Tap with two fingers to decrement", systemImage: "circle.grid.2x1")
                        }
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                    .font(.title)
                }
                .foregroundColor(.white)
                .padding(.top)
                .padding(.horizontal, 20)
            }
            .shareSheet(url: Constants.appUrl, showsSharedAlert: true, isPresented: $showShareSheet)
            .emailSheet(recipient: Constants.email, subject: "\(Constants.name) Feedback", isPresented: $showEmailSheet)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
