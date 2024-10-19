//
//  GenerateCodeView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//

import SwiftUI

struct GenerateCodeView: View {
    @State private var inputText = ""
    @State private var selectedBarcodeType: BarcodeType = .code128
    @State private var barcodeImage: UIImage? = nil
    
    private var barcodeGenerator = BarcodeGenerator()

    var body: some View {
        VStack {
            Text("Select the barcode type, then enter your barcode data to generate a barcode image")
                .foregroundStyle(.secondary)
                .padding(.bottom, 20)

            barcodeImageView
            
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
        .onChange(of: inputText) {
            generateBarcodeImage()
        }
        .onChange(of: selectedBarcodeType) {
            generateBarcodeImage()
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
    
    var barcodeImageView: some View {
        Group {
            if let barcodeImage = barcodeImage {
                Image(uiImage: barcodeImage)
                    .resizable()
                    .scaledToFit()
                    //.frame(height: 240)
                    .contextMenu {
                        ShareLink(item: Image(uiImage: barcodeImage), preview: SharePreview("Barcode: \(inputText)", image: Image(uiImage: barcodeImage))) {
                            Label("Share code", systemImage: "square.and.arrow.up")
                        }
                        
                        Button("Save to photos") {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: barcodeImage)
                        }
                    }
            }
        }
        .padding()
        .background(Color.white)
        .disabled(inputText.isEmpty)
    }
    
    private func generateBarcodeImage() {
        if !inputText.isEmpty {
            barcodeImage = barcodeGenerator.generateBarcode(text: inputText, type: selectedBarcodeType)
        } else {
            barcodeImage = nil
        }
    }
}


#Preview {
    //GenerateCodeView()
    MainTabView()
}
