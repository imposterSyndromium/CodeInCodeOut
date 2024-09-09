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
            Text("Please select the barcode type and enter your barcode data")
                .font(.headline)
                .padding(.bottom, 20)
            
            Picker("Barcode Type", selection: $selectedBarcodeType) {
                ForEach(BarcodeType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.menu)
            .padding(.bottom, 10)
            
            TextField("Enter code data", text: $inputText)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .padding()
                .font(.title)
                .background(Color(.systemGray6))
            
            Spacer()
            
            Text(!inputText.isEmpty ? "Press and hold the barcode for more options" : "")
                .font(.headline)
                .padding(.bottom, 20)
            
            VStack(spacing: 0) {
                let image = barcodeGenerator.generateBarcode(text: inputText, type: selectedBarcodeType)
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .contextMenu {
                        ShareLink(item: Image(uiImage: image), preview: SharePreview("Scanned code: \(inputText)", image: Image(uiImage: image)))
                        
                        Button("Save") {
                            // TODO - save tp photos
                        }
                    }
                    .disabled(inputText.isEmpty ? true : false)
                
                Text(inputText)
                
                Button { } label: {
                    ShareLink(item: Image(uiImage: image), preview: SharePreview("Scanned code: \(inputText)", image: Image(uiImage: image))) {
                        Label("Share code", systemImage: "square.and.arrow.up")
                            
                    }
                }
                .padding(.top, 10)
                .disabled(inputText.isEmpty ? true : false)
                
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
