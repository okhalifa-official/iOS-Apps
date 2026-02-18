//
//  FrameworkGridViewModel.swift
//  SwiftUI-AppleFrameworks
//
//  Created by Omar Khalifa on 16/02/2026.
//

import SwiftUI
internal import Combine

final class FrameworkGridViewModel: ObservableObject {
    var selectedFramework: Framework?{
        didSet{
            isShowDetailView = true
        }
    }
    
    @Published var isShowDetailView = false
}
