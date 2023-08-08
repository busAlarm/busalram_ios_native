//
//  ContentView.swift
//  busalram_ios_native
//
//  Created by 한현민 on 2023/08/08.
//

import SwiftUI

// 1) 날씨 가져오기 (완료)
// 2) 버스 도착 정보 가져오기 (완료)

// 3) 화면 구성하기
// 탭뷰로 나눠서 해보자

// 1. 날씨 항목별
// 현재기온, 최고기온, 최저기온, 날씨
// 미세먼지, 초미세먼지
// 현재시각?

// 2. 정류장 도착정보
// 노선 번호
// 새로고침한 시간
// 첫차, 막차
// 현재 버스 (도착시간, 현재위치)
// 다음 버스 (도착시간, 현재위치)
// 운행 중 여부
// 곧도착 여부 (곧도착이면 AVFoundation으로 음성 안내)
// 푸시알림 기능 구현하면 좋겠는데 이건 시간 남으면 더 해보자

struct ContentView: View {
    @StateObject var busDataStore: BusDataStore = .init()
    @StateObject var weatherDataStore: WeatherDataStore = .init()

    @State var currentTabIndex: Int = 1

    var body: some View {
        // TabView selection 꼭 넣어라...
        // Binding<Int>
        TabView(selection: $currentTabIndex) {
            BusView(busDataStore: busDataStore)
                .tabItem {
                    Image(systemName: "bus.fill")
                    Text("버스")
                }
                .tag(1)

            WeatherView(weatherDataStore: weatherDataStore)
                .tabItem {
                    Image(systemName: "sun.min")
                    Text("날씨")
                }
                .tag(2)
        }
    }
}
