//
//  ContentView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    var body: some View {
        NavigationStack {
            ScannedQRDataListView(modelContext: ModelContext)
        }

    }
}

#Preview {
    ContentView()
}
