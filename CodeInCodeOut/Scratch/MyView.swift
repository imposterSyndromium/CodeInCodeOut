//
//  MyView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-13.
//

import SwiftUI

class FirstResponderField: UITextField {
    init() {
        super.init(frame: .zero)
        becomeFirstResponder()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct FirstResponderFieldView: UIViewRepresentable {
    func makeUIView(context: Context) -> FirstResponderField {
        return FirstResponderField()
    }

    func updateUIView(_ uiView: FirstResponderField, context: Context) {}
}

struct MyView: View {

    @FocusState var isFocused: Bool
    @State private var text = ""
    var body: some View {
        ZStack {
            FirstResponderFieldView() // this makes the keyboard to appear with a single animation
                .frame(width: 0, height: 0)
                .opacity(0)
            TextField("Email", text: $text)
                .focused($isFocused)

        }
        .onAppear {
            isFocused = true // After the view appears, you want to focus to actual SwiftUI view.
        }
    }
}

#Preview {
    MyView()
}
