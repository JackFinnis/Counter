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
    @State var showEmailSheet = false
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemFont(.body, weight: .semibold)]
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
            .navigationTitle("Counter")
            .navigationBarTitleDisplayMode(.inline)
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
                            Button(action: {}) {
                                Label {
                                    Text("Tap on the left to decrement")
                                } icon: {
                                    Image(systemName: "circle.fill", color: .red)
                                }
                            }
                            Button(action: {}) {
                                Label {
                                    Text("Tap on the right to increment")
                                } icon: {
                                    Image(systemName: "circle.fill", color: .green)
                                }
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

extension UIFont {
    class func systemFont(_ style: TextStyle = .body, weight: UIFont.Weight = .regular, design: UIFontDescriptor.SystemDesign = .default) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).withDesign(design)!.addingAttributes([.traits : [UIFontDescriptor.TraitKey.weight : weight]])
        return UIFont(descriptor: descriptor, size: descriptor.pointSize)
    }
}

extension Image {
    init(systemName: String, color: Color) {
        self.init(uiImage: UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: UIColor(color)))!)
    }
}
