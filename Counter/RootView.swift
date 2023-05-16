//
//  RootView.swift
//  Counter
//
//  Created by Jack Finnis on 16/05/2023.
//

import SwiftUI

struct RootView: View {
    @AppStorage("count") var count = 0
    @State var showResetAlert = false
    
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
                Menu {
                    Button {} label: {
                        Label("Tap with one finger to increment", systemImage: "circlebadge")
                    }
                    Button {} label: {
                        Label("Tap with two fingers to decrement", systemImage: "circle.grid.2x1")
                    }
                    Button {} label: {
                        Label("Shake the device to reset", systemImage: "iphone.radiowaves.left.and.right")
                    }
                } label: {
                    Image(systemName: "questionmark.circle")
                }
                .font(.title)
                .foregroundColor(.white)
                .padding()
            }
            .onShake {
                if count != 0 {
                    showResetAlert = true
                }
            }
            .alert("Reset Counter?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    count = 0
                }
            }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
