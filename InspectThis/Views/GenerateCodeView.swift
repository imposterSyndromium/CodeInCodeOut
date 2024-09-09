//
//  GenerateCodeView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct GenerateCodeView: View {
    @State private var inputText = ""
    @State private var selectedBarcodeType: BarcodeType = .code128
    var barcodeGenerator = BarcodeGenerator()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Please select the barcode type and enter your data")
                .font(.headline)
                .padding(.bottom, 20)
            
            Picker("Barcode Type", selection: $selectedBarcodeType) {
                ForEach(BarcodeType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.bottom, 10)
            
            TextField("Enter code data", text: $inputText)
                .padding()
                .font(.title)
                .background(Color(.systemGray6))
            
            Spacer()
            
            Text("Press and hold the barcode for more options")
                .font(.headline)
                .padding(.bottom, 20)
            
            VStack(spacing: 0) {
                let image = barcodeGenerator.generateBarcode(text: inputText, type: selectedBarcodeType)
                image
                    .resizable()
                    .scaledToFit()
                
                Text(inputText.isEmpty ? "Unknown data" : inputText)
            }
            .padding()
        }
        .navigationTitle("Barcode Generator")
        .navigationBarTitleDisplayMode(.large)
        .padding()
    }
}

#Preview {
    GenerateCodeView()
}
