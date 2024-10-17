//
//  SplashScreenView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-07.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isPresented: Bool
    @State private var animationsRunning = false
    @State private var showWord = false
    @State private var topWordOffset: CGFloat = 500
    @State private var bottomWordOffset: CGFloat = -500

    
    var body: some View {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        // The word that will slide in
                        Text("CODE IN")
                            .font(Font.custom("CrackedMirrorRegular", size: 90))
                            .foregroundColor(.white)
                            .offset(x: showWord ? 0 : topWordOffset)
                            .opacity(showWord ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: showWord)                  
                    }
                    .padding()
                    
                    TextShimmerView(content: .symbol("qrcode.viewfinder"), speed: 1.3, fontSize: 250, rotationAngle: 90, shimmerColor: .red, delay: 0.7, autoReverse: true, repeatCount: 2)
                        .symbolEffect(.bounce, value: animationsRunning)
                    
                    HStack {
                        // The word that will slide in
                        Text("CODE OUT")
                            .font(Font.custom("CrackedMirrorRegular", size: 90))
                            .foregroundColor(.white)
                            .offset(x: showWord ? 0 : bottomWordOffset)
                            .opacity(showWord ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: showWord)
                    }
                    .padding()
                }
                .preferredColorScheme(.dark)
            }
            .onAppear {
                // trigger the SFSymbol effect to start
                animationsRunning.toggle()
                
                // wait 0.5 seconds to show the sliding word
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        showWord = true
                    }
                }
                
                // wait 3 seconds to dismiss the screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isPresented = true
                    }
                }
            }
            // allow a tap to skip the 3 second wait set in .onAppear
            .onTapGesture {
                isPresented = true
            }
        }
}

#Preview {
    SplashScreenView(isPresented: .constant(true))
}
