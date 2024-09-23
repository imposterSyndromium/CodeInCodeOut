//
//  StartContainerView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-07.
//

import SwiftUI

struct StartContainerView: View {
    @State private var isSplashScreenViewPresented = false
    
    var body: some View {
        if isSplashScreenViewPresented {
            MainTabvView()
        } else {
            SplashScreenView(isPresented: $isSplashScreenViewPresented)
        }
    }
}

#Preview {
    StartContainerView()
}
