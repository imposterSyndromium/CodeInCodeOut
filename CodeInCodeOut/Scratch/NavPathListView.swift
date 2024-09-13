//
//  SwiftUIView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-12.
//

import SwiftUI

struct NavPathListView: View {
    @State private var navPath = NavigationPath()

        var body: some View {
            NavigationStack(path: $navPath) {
                Button("Jump to random") {
                    navPath.append(Int.random(in: 1..<50))
                }

                List(1..<50) { i in
                    NavigationLink(value: "Row \(i)") {
                        Label("Row \(i)", systemImage: "\(i).circle")
                    }
                }
                .navigationDestination(for: Int.self) { i in
                    Text("Int Detail \(i)")
                }
                .navigationDestination(for: String.self) { i in
                    Text("String Detail \(i)")
                }
                .navigationTitle("Navigation")
            }
        }
}

#Preview {
    NavPathListView()
}
