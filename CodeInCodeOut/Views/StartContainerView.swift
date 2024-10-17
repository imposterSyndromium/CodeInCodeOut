//
//  StartContainerView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-07.
//

import SwiftUI
import Foundation

struct StartContainerView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var isSplashScreenViewPresented = false
    
    var body: some View {
        
        
            if isSplashScreenViewPresented {
                MainTabView()    
            } else {
                SplashScreenView(isPresented: $isSplashScreenViewPresented)
            }
                
    }
}

#Preview {
    StartContainerView()
}
