//
//  TestView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-11.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        (Text("Code In ") + Text(Image(systemName: "qrcode")) + Text(" Code Out"))
            .foregroundStyle(.blue)
            .font(.largeTitle)
    }
}

#Preview {
    TestView()
}
