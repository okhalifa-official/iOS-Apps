//
//  DetailView.swift
//  SwiftUI-AppleFrameworks
//
//  Created by Omar Khalifa on 16/02/2026.
//

import SwiftUI

struct DetailView: View {
    @Binding var isShowDetailView: Bool
    var selectedFramework: Framework
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .blur(radius: 100, opaque: true)
                
            VStack{
                HStack{
                    Spacer()
                    Button{
                        // action
                        isShowDetailView = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color(.label))
                            .padding()
                    }
                }
                FrameworkTitleView(framework: selectedFramework, s: 120)
                
                Spacer()
                
                Text(selectedFramework.description)
                    .font(.default)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.6)
                    .foregroundStyle(Color(.label))
                    .padding()
                
                Spacer()
                
                if let url = URL(string: selectedFramework.urlString) {
                    Link(destination: url) {
                        Text("Learn More")
                            .foregroundStyle(Color(.white))
                            .font(.title3)
                            .bold()
                            .frame(width: 220, height: 60)
                            .background(Color(.red))
                            .clipShape(.capsule)
                            .glassEffect()
                    }
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    DetailView(isShowDetailView: .constant(false), selectedFramework: MockData.sampleFramework)
}
