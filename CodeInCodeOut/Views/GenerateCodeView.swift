//
//  GenerateCodeView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//

import SwiftUI
//import CoreImage.CIFilterBuiltins

struct GenerateCodeView: View {
    @State private var inputText = ""
    @State private var selectedBarcodeType: BarcodeType = .code128
    @State private var barcodeImage: UIImage? = UIImage()
    
    private var barcodeGenerator = BarcodeGenerator()
    

    var body: some View {
        VStack {
            Text("Select the barcode type, then enter your barcode data to generate a barcode image")
                .foregroundStyle(.secondary)
                .padding(.bottom, 20)

            
            barcodeImageView
            
            // Show the press and hold message only if a barcode is showing
            Text(!inputText.isEmpty ? "Press and hold the barcode for more options" : "")
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            HStack {
                TextField("Enter code data", text: $inputText)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .padding()
                
                Spacer()
                
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        inputText = ""
                    }
                    .padding()
                    .opacity(inputText.isEmpty ? 0 : 1)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.orange)
            )
        }
        .navigationTitle("Barcode Generator")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        // Generate the barcode image and assign it to barcodeImage using onChange/onAppear
        .onAppear {
            inputText = ""
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
        .toolbar {
            ToolbarItem {
                Menu(content: {
                    Picker("Barcode Type", selection: $selectedBarcodeType) {
                        ForEach(BarcodeType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                }, label: { Image(systemName: "barcode")})
            }
        }
        
        
    }
    
    
    /// Image of barcode
    var barcodeImageView: some View {
        VStack(spacing: 0) {
            if let barcodeImage = barcodeImage {
                Image(uiImage: barcodeImage)
                    .resizable()
                    .scaledToFit()
                
                    // The menu that appears when press + hold Image
                    .contextMenu {
                        ShareLink(item: Image(uiImage: barcodeImage), preview: SharePreview("Scanned data: \(inputText)", image: Image(uiImage: barcodeImage))) {
                            Label("Share code", systemImage: "square.and.arrow.up")
                        }
                        
                        Button("Save to photos") {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: barcodeImage)
                        }
                    }
                    // disable the entire image of the barcode if the barcode data entry text field is empty
                    .disabled(inputText.isEmpty)
                
                Text(inputText)
            }
        }
        .padding()
    }
    
    
    
    private func generateBarcodeImage(from text: String, codeType type: BarcodeType) {
        barcodeImage = barcodeGenerator.generateBarcode(text: text, type: type)
    }
    
    
    
}

#Preview {
    //GenerateCodeView()
    MainTabView()
}
