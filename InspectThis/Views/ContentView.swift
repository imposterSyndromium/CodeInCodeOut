//
//  ContentView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//

//import SwiftUI
//import SwiftData
//
//struct ContentView: View {
//    @State private var viewModel = ScannedQRDataList_ViewModel()
//    
//    
//    var body: some View {
//        NavigationStack {
//            ScannedQRDataListView()
//        }
//
//    }
//}
import SwiftUI
import SwiftData

struct ContentView: View {
    

    var body: some View {
        NavigationStack {
            ScannedQRDataListView()
        }
    }
}

#Preview {
    ContentView()
}
