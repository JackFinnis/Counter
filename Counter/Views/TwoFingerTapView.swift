//
//  TwoFingerTapView.swift
//  Counter
//
//  Created by Jack Finnis on 16/05/2023.
//

import SwiftUI

struct TwoFingerTapView: UIViewRepresentable {
    let onEnded: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        let twoFingerTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTwoFingerTap))
        twoFingerTap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(twoFingerTap)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    class Coordinator {
        let parent: TwoFingerTapView
        
        init(parent: TwoFingerTapView) {
            self.parent = parent
        }
        
        @objc
        func handleTwoFingerTap(_ twoFingerTap: UITapGestureRecognizer) {
            parent.onEnded()
        }
    }
}
