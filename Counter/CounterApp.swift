//
//  CounterApp.swift
//  Counter
//
//  Created by Jack Finnis on 16/05/2023.
//

import SwiftUI

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView()
        }
    }
}

struct CounterView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("count") var count = 0
    @State var down = false
    
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button("Reset") {
                        down = count > 0
                        count = 0
                        Haptics.success()
                    }
                    .foregroundStyle(.background)
                    .disabled(count == 0)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .font(.headline)
                }
            }
            .fontDesign(.rounded)
        }
    }
}

#Preview {
    CounterView()
}

struct Haptics {
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
