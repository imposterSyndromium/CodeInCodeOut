//
//  TxtKeyboardTestView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-13.
//

import SwiftUI

struct TxtKeyboardTestView: View {
    
    @State var text = ""
    @FocusState var isFocused: Bool
    @FocusState var isFocusedInToolbar: Bool
    
    var body: some View {
        Button("Show Keyboard") {
            isFocused = true
        }
        .opacity(isFocusedInToolbar ? 0 : 1)
        
        TextField("Enter Text", text: $text)            // Invisible Proxy TextField
            .focused($isFocused)
            .opacity(0)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        TextField("", text: $text)          // Toolbar TextField
                            .textFieldStyle(.roundedBorder)
                            .focused($isFocusedInToolbar)
                        Button("Done") {
                            isFocused = false
                            isFocusedInToolbar = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
            }
            .onChange(of: isFocused) { //newValue in
//                if newValue {
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
//                        isFocusedInToolbar = true
//                    }
//                }
                isFocusedInToolbar = true
            }
    }
}


#Preview {
    TxtKeyboardTestView()
}
