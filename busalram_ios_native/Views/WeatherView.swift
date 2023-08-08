//
//  WeatherView.swift
//  busalram_ios_native
//
//  Created by 한현민 on 2023/08/08.
//

import SwiftUI

// 현재기온, 최고기온, 최저기온, 날씨
// 미세먼지, 초미세먼지
// 현재시각?

struct WeatherView: View {
    @ObservedObject var weatherDataStore: WeatherDataStore
    
    @State var isLoading: Bool = true
    
    var body: some View {
        if isLoading {
            ProgressView()
                .task {
                    await weatherDataStore.retrieveWeatherData()
                    debugPrint(weatherDataStore.weatherData)
                    isLoading.toggle()
                }
        } else {
            NavigationStack {
                List {
                    Section("현재 날씨") {
                        HStack(spacing: 24) {
                            Spacer()
                            
                            VStack {
                                Text("현재 기온")
                                Text("\(weatherDataStore.weatherData.currentTemp)°C")
                                    .font(.largeTitle)
                                    .fontWeight(.thin)
                            }
                            
                            Text("\(weatherDataStore.weatherData.weather)")
                                .font(.largeTitle)
                            
                            Spacer()
                        }
                        .padding()
                    }
                    
                    
                    Section("날씨 및 미세먼지 예보") {
                        VStack(spacing: 24) {
                            Grid(alignment: .center, horizontalSpacing: 40, verticalSpacing: 32) {
                                GridRow {
                                    VStack(spacing: 8) {
                                        Label("최고 기온", systemImage: "sun.min")
                                        Text("\(weatherDataStore.weatherData.maxTemp)°C")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    }
                                    
                                    VStack(spacing: 8) {
                                        Label("최저 기온", systemImage: "wind")
                                        Text("\(weatherDataStore.weatherData.minTemp)°C")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                GridRow {
                                    VStack(spacing: 8) {
                                        Text("미세먼지")
                                        Text("\(weatherDataStore.weatherData.microDust)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                    }
                                    
                                    VStack(spacing: 8) {
                                        Text("초미세먼지")
                                        Text("\(weatherDataStore.weatherData.ultraMicroDust)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Text("최근 새로고침: \(weatherDataStore.weatherData.timeStamp)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top)
                    }
                    
                }
                .navigationTitle("날씨")
            }
            .refreshable {
                await weatherDataStore.retrieveWeatherData()
                debugPrint(weatherDataStore.weatherData)
            }
        }
    }
}
