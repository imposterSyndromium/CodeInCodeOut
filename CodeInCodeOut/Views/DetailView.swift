//
//  DetailView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-15.
//

import SwiftUI

struct DetailView: View {
    @Bindable var codeScan: CodeScanData  //<-- this Bindable property is what keeps the notes field attached to SwiftData
    @State private var isShowingZoomableImage = false
    @FocusState private var isNotesFocused: Bool
    

    
    var body: some View {
        List {
            Section(header: Text("Scanned Code Data"), footer: Text("(Press and hold for more options)")) {
                VStack(alignment: .leading) {
                    Text(codeScan.codeStingData)
                        .textSelection(.enabled)
                        .contextMenu {
                            // ShareLink
                            ShareLink(item: codeScan.codeStingData, preview: SharePreview(codeScan.codeStingData))
                            
                            // copy to clip board
                            Button(action: {
                                UIPasteboard.general.string = codeScan.codeStingData
                            }) {
                                Label("Copy to Clipboard", systemImage: "document.on.document")
                            }
                            
                            // open in browser if the scan was a URL, otherwise do not show
                            if let url = URL(string: codeScan.codeStingData), UIApplication.shared.canOpenURL(url) {
                                Button(action: {
                                    UIApplication.shared.open(url)
                                }) {
                                    Label("Open in Browser", systemImage: "safari")
                                }
                            }
                            
                        }
                }
            }
            .listRowBackground(Color.listRowColor)
            
            Section("Date Scanned") {
                Text(codeScan.dateAdded.formatted(date: .abbreviated, time: .shortened))
            }
            .listRowBackground(Color.listRowColor)
            
            // Section("Notes") .. code layout is different because of the Done button
            Section {
                TextEditorWithPlaceholderText(text: $codeScan.notes, placeholder: "Enter notes here...")
                    .frame(height: 100) // Adjust this value to show the desired number of lines
                    .focused($isNotesFocused)
            } header: {
                HStack {
                    Text("Notes (tap to edit)")
                    Spacer()
                    if isNotesFocused {
                        Button("Done") {
                            isNotesFocused = false
                        }
                    }
                }
            }
            .listRowBackground(Color.listRowColor)
            
                        
            Section("Original Scan Image") {
                if let qrImage = codeScan.image {
                    
                    Button {
                        isShowingZoomableImage.toggle()
                    } label: {
                        // force unwrap the image data because we already know it has data
                        Image(uiImage: UIImage(data: qrImage)!)
                            .resizable()
                            .scaledToFit()
                    }
                    
                } else {
                    ContentUnavailableView("Image not available", systemImage: "photo", description: Text("There is no image history for this scan"))
                }
            }
            .listRowBackground(Color.listRowColor)
            
            Section("Scan Location") {
                if let location = codeScan.location {
                    
                    
                    MapSinglePinView(locationData: location, isInteractionDisabled: false)
                        .frame(height: 400)
                        .padding()
                    
                } else {
                    ContentUnavailableView("Location not available", systemImage: "location.slash", description: Text("There is no location history for this scan.  To enable future scan location availability, go to Settings > Privacy & Security > Location Services > CodeInCodeOut"))
                }
            }
            .listRowBackground(Color.listRowColor)
        }
        .sheet(isPresented: $isShowingZoomableImage) {
            ZoomableScrollableImage_View(uiImage: UIImage(data: codeScan.image!)!)
        }
        
        
    }
    
    
    // uses a ZStack to contain a TextEditor field with placeholder text on top (to mimic a regular TextField)
    struct TextEditorWithPlaceholderText: View {
        @Binding var text: String
        let placeholder: String
        
        var body: some View {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(.placeholderText))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
                TextEditor(text: $text)
                    .padding(.horizontal, -4)
            }
        }
    }
    
    
}


#Preview {
    let preview = Preview()
    preview.addExampleData(CodeScanData.sampleScans)
    return MainTabView()
        .modelContainer(preview.container)
}
