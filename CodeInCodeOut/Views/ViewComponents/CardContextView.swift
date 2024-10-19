//
//  SwiftUIView.swift
//  SwiftExamples
//
//  Created by Robin O'Brien on 2024-10-13.
//

import SwiftUI

struct CardContextMenu<Content: View>: View {
    @Binding var isPresented: Bool
    let content: () -> Content
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea(edges: .all)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                VStack {
                    content() // <-- whatever view is passed in using trailing closure
                }
                .padding()
                .background(
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial)) // Frosted glass effect
                        Color.white.opacity(0.1)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                .transition(.scale)
                .animation(.spring(), value: isPresented)
            }
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

