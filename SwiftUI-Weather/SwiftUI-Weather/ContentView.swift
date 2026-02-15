//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Omar Khalifa on 13/02/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var isNight: Bool = false
    var body: some View {
        ZStack {
            BackgroundView(isNight: isNight)
            VStack {
                CurrentDayWeatherView()
                Spacer()
                HStack(spacing: 15) {
                    WeatherDayView(day: "TUE", temperature: 23, icon: "sun.max.fill")
                    WeatherDayView(day: "WED", temperature: 21, icon: "sunset.fill")
                    WeatherDayView(day: "THU", temperature: 14, icon: "sun.rain.fill")
                    WeatherDayView(day: "FRI", temperature: 25, icon: "sun.max.fill")
                    WeatherDayView(day: "SAT", temperature: 18, icon: "sun.rain.fill")
                }
                Spacer()
                Button{
                    isNight.toggle()
                } label: {
                    WeatherButtonView(isNight: isNight)
                }
                .glassEffect(.regular.interactive(), in: Capsule())
            }
        }
    }
}

#Preview {
    ContentView()
}

struct WeatherDayView: View {
    var day: String
    var temperature: Int
    var icon: String
    var body: some View {
        VStack {
            Text(day)
                .font(Font.system(size: 18, weight: .medium))
                .foregroundStyle(Color.white)
            Image(systemName: icon)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperature)°C")
                .font(Font.system(size: 24, weight: .bold))
                .foregroundStyle(Color.white)
        }
    }
}

struct CurrentDayWeatherView: View {
    var body: some View {
        Text("Giza, Egypt")
            .font(Font.largeTitle.bold())
            .foregroundStyle(Color.white)
            .padding()
            .padding()
        VStack(spacing: 8) {
            Image(systemName: "cloud.sun.fill")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("21°C")
                .font(Font.system(size: 40, weight: .medium))
                .foregroundStyle(Color.white)
        }
    }
}

struct BackgroundView: View {
    var isNight: Bool
    var body: some View {
        LinearGradient(colors: [isNight ? .black : .blue, Color("navyBlue")], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}
