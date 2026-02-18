//
//  FrameworkGridView.swift
//  SwiftUI-AppleFrameworks
//
//  Created by Omar Khalifa on 16/02/2026.
//

import SwiftUI

struct FrameworkGridView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @StateObject var frameworkModel = FrameworkGridViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                ScrollView{
                    LazyVGrid(columns: columns){
                        ForEach(MockData.frameworks){ framework in
                            FrameworkButton(framework: framework, selectedFramework: $frameworkModel.selectedFramework)
                        }
                        
                    }
                    .padding()
                }
            }
            .navigationTitle("🍎 Apple Frameworks")
        }
        .sheet(isPresented: $frameworkModel.isShowDetailView){
            DetailView(isShowDetailView: $frameworkModel.isShowDetailView, selectedFramework: frameworkModel.selectedFramework!)
        }
    }
}

#Preview {
    FrameworkGridView()
}

struct FrameworkButton: View {
    let framework: Framework
    @Binding var selectedFramework: Framework?
    
    var body: some View {
        Button{
            // action
            selectedFramework = framework
        } label: {
            FrameworkTitleView(framework: framework, s: 80)
        }
    }
}

struct FrameworkTitleView: View {
    let framework: Framework
    let s: CGFloat
    
    var body: some View {
        VStack{
            Image(framework.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: s, height: s)
            Text(framework.name)
                .font(.title2)
                .fontWeight(.semibold)
                .scaledToFit()
                .minimumScaleFactor(0.6)
                .foregroundStyle(Color(.label))
        }
        .padding()
    }
}
