//
//  LoadingView.swift
//  travelize
//
//  Created by Kavya Subramanian on 11/21/24.
//

import SwiftUI


struct LoadingView: View {
    @State private var dragOffset = CGSize.zero
    @State private var rotation: Double = 0
    @State private var isAnimating = true
    let emojiSize: CGFloat = 60
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)

            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.cyan.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            Text("✈️")
                .font(.system(size: emojiSize))
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                
                                dragOffset = CGSize.zero
                            }
                        }
                )
                .rotationEffect(.degrees(rotation))
                .animation(.easeOut(duration: 1.0), value: isAnimating)
                .onAppear {
                    isAnimating = true
                    
                    withAnimation(
                        .linear(duration: 2.0)
                        .repeatForever(autoreverses: false)
                    ) {
                        rotation = 360
                    }
                }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
