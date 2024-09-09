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
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "qrcode.viewfinder")
                    .symbolEffect(.bounce, value: animationsRunning)
                    .font(.system(size: 250))
                    .foregroundStyle(.white)
            }
            .font(.largeTitle)
        }
        .onAppear {
            // trigger the SFSymbol effect st to start
            animationsRunning.toggle()
            
            // wait 3 seconds to dismiss the screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                withAnimation {
                    isPresented = true
                }
            })
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
