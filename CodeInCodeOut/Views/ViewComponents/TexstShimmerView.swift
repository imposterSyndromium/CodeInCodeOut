//
//  TexstShimmerView.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-10-14.
//

import SwiftUI



enum ShimmerContent {
    case text(String)
    case symbol(String)
}

struct TextShimmerView: View {
    @State private var animation = false
    var content: ShimmerContent
    
    var multiColors: Bool = false
    var speed: CGFloat = 2.0
    var fontSize: CGFloat = 75
    var rotationAngle: Double = 70
    var shimmerColor: Color = .white
    var repeatShimmer: Bool = false
    var delay: Double = 0.1
    var autoReverse: Bool = false
    var repeatCount: Int = 1
    
    @ViewBuilder
    private var contentView: some View {
        switch content {
        case .text(let text):
            Text(text)
        case .symbol(let symbolName):
            Image(systemName: symbolName)
        }
    }
    
    var body: some View {
        ZStack {
            contentView
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(Color.white.opacity(1))
          
            HStack(spacing: 0) {
                switch content {
                case .text(let text):
                    ForEach(0..<text.count, id: \.self) { index in
                        Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                            .font(.system(size: fontSize, weight: .light))
                            .foregroundColor(multiColors ? randomColor() : shimmerColor)
                    }
                case .symbol(let symbolName):
                    Image(systemName: symbolName)
                        .font(.system(size: fontSize, weight: .bold))
                        .foregroundColor(multiColors ? randomColor() : shimmerColor)
                }
            }
            // Add Masking For Shimmer Effect
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .init(colors: [Color.white.opacity(0.5), Color.white, Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 500, height: 30)
                    .rotationEffect(.init(degrees: rotationAngle))
                    .padding(20)
                    // Moving View Continuously so it will create Shimmer Effect...
                    .offset(x: -250)
                    .offset(x: animation ? 500 : 0)
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { //<-- Delay
                    withAnimation(repeatShimmer ?
                                  Animation.linear(duration: speed).repeatForever(autoreverses: autoReverse)
                                  :
                                  Animation.linear(duration: speed).repeatCount(repeatCount, autoreverses: autoReverse)) {
                        animation.toggle()
                    }
                }
            }
            
            
        }
    }
    
    // Random Color....
    func randomColor() -> Color {
        let color = UIColor(red: .random(in: 1...1),
                            green: .random(in: 0...1),
                            blue: .random(in: 0...1),
                            alpha: 1)
        return Color(color)
    }
}
