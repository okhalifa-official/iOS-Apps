//
//  File.swift
//  SwiftUI-Weather
//
//  Created by Omar Khalifa on 15/02/2026.
//

import SwiftUI

struct WeatherButtonView: View {
    var isNight: Bool
    var body: some View {
        Text("Change Day Time")
            .frame(width: 200, height: 60)
            .background(isNight ? Color.navyBlue : Color.blue)
            .font(Font.system(size: 18, weight: .bold))
            .foregroundStyle(Color.white)
            .clipShape(.capsule)
    }
}
