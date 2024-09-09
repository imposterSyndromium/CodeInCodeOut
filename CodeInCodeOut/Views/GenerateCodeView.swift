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
    @State private var barcodeImage: UIImage? = UIImage()
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
            
            barcodeImageView
        }
        .navigationTitle("Barcode Generator")
        .navigationBarTitleDisplayMode(.large)
        .padding()
        // Generate the barcode image and assign it to barcodeImage using onChange/onAppear
        .onAppear {
            withAnimation {
                generateBarcodeImage(from: inputText, codeType: selectedBarcodeType)
            }
        }
        .onChange(of: inputText) {
            generateBarcodeImage(from: inputText, codeType: selectedBarcodeType)
        }
        .onChange(of: selectedBarcodeType) {
            withAnimation {
                generateBarcodeImage(from: inputText, codeType: selectedBarcodeType)
            }
        }
        
    }
    
    
    var barcodeImageView: some View {
        VStack(spacing: 0) {
            if let barcodeImage = barcodeImage {
                Image(uiImage: barcodeImage)
                    .resizable()
                    .scaledToFit()
                    .contextMenu {
                        ShareLink(item: Image(uiImage: barcodeImage), preview: SharePreview("Scanned data: \(inputText)", image: Image(uiImage: barcodeImage))) {
                            Label("Share code", systemImage: "square.and.arrow.up")
                        }
                        
                        Button("Save to photos") {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: barcodeImage)
                        }
                    }
                    .disabled(inputText.isEmpty)
                
                Text(inputText)
                
                Button { } label: {
                    ShareLink(item: Image(uiImage: barcodeImage), preview: SharePreview("Scanned data: \(inputText)", image: Image(uiImage: barcodeImage))) {
                        Label("Share code", systemImage: "square.and.arrow.up")
                    }
                }
                .padding(.top, 10)
                .disabled(inputText.isEmpty)
            }
        }
        .padding()
    }
    
    
    private func generateBarcodeImage(from text: String, codeType type: BarcodeType) {
        barcodeImage = barcodeGenerator.generateBarcode(text: text, type: type)
    }
}

#Preview {
    GenerateCodeView()
}
