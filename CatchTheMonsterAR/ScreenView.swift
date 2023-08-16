//
//  ScreenView.swift
//  CatchTheMonsterAR
//

import SwiftUI

struct ScreenView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.darkBlue
                .ignoresSafeArea()
            logo()
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .overlay {
                    Capsule()
                        .foregroundColor(.darkBlue)
                        .scaleEffect(isAnimating ? 0 : 2)
                        .animation(.easeOut(duration: 2.0), value: isAnimating)
                }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 2.0).delay(0.5)) {
                isAnimating = true
            }
        }
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
    }
}
