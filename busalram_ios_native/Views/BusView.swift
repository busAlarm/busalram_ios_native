//
//  BusView.swift
//  busalram_ios_native
//
//  Created by 한현민 on 2023/08/08.
//

import SwiftUI

// 2. 정류장 도착정보
// 노선 번호
// 새로고침한 시간
// 첫차, 막차
// 현재 버스 (도착시간, 현재위치)
// 다음 버스 (도착시간, 현재위치)
// 운행 중 여부
// 곧도착 여부 (곧도착이면 AVFoundation으로 음성 안내)
// 푸시알림 기능 구현하면 좋겠는데 이건 시간 남으면 더 해보자

struct BusView: View {
    @ObservedObject var busDataStore: BusDataStore

    @State var arrivalSoonBuses: [String: Bool] = [
        "24": true,
        "720-3": true,
        "shuttle": true
    ]

    @State var isLoading: Bool = true

    var body: some View {
        if isLoading {
            ProgressView()
                .task {
                    for bus in Array(arrivalSoonBuses.keys) {
                        await busDataStore.retrieveBusData(routeNumber: bus)
                        arrivalSoonBuses[bus] = busDataStore.busData[bus]!.arrivalSoon
                    }
                    debugPrint(busDataStore.busData)
                    isLoading.toggle()
                }
        } else {
            GeometryReader { _ in
                NavigationStack {
                    List {
                        Section {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("곧 도착하는 버스")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                if Array(arrivalSoonBuses.values).contains(where: {
                                    $0 == true
                                }) {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(Array(arrivalSoonBuses.keys), id: \.self) { key in
                                                if arrivalSoonBuses[key]! {
                                                    // 바깥쪽 윤곽선이랑 안쪽 배경은 따로따로 만들어줘야 한다!
                                                    BusCardView(cardColor: BusData.getBusColor(name: key), innerText: BusData.getBusName(name: key))
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    Text("현재 도착 예정인 노선이 없습니다.")
                                }
                            }
                        }
                        
                        Section {
                            VStack(alignment: .leading, spacing: 30) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("노선별 버스 도착정보")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Text("최근 새로고침: \(busDataStore.recentRefreshTimeStamp)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                                    GridRow {
                                        Text("노선명")
                                            .fontWeight(.bold)
                                            .frame(width: 80)

                                        Text("정류장 및 남은 시간")
                                            .fontWeight(.bold)
                                    }
                                    
                                    Divider()
                                    
                                    ForEach(busDataStore.availableRoutes, id: \.self) { key in
                                        let bus = busDataStore.busData[key]!
                                        GridRow {
                                            BusCardView(cardColor: BusData.getBusColor(name: bus.routeID), innerText: bus.routeID)
                                            
                                            if !bus.isRunning {
                                                Text("운행 정보 없음")
                                                    .foregroundColor(.gray)
                                            } else if bus.predictTime1 == "" && bus.predictTime2 == "" {
                                                Text("운행 정보 없음")
                                                    .foregroundColor(.gray)
                                            } else {
                                                VStack(spacing: 4) {
                                                    Text(bus.stationNm1)
                                                        .font(.caption)
                                                    
                                                    if bus.predictTime1 != "" {
                                                        Text("\(bus.predictTime1)분 후")
                                                            .foregroundColor(.red)
                                                    }
                                                    
                                                    if bus.predictTime2 != "" {
                                                        Text("\(bus.predictTime2)분 후")
                                                            .foregroundColor(.red)
                                                    }
                                                }
                                            }
                                        }
                                        
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                }
                .navigationTitle("버스 도착 알리미")
            }
            .refreshable {
                for bus in Array(arrivalSoonBuses.keys) {
                    await busDataStore.retrieveBusData(routeNumber: bus)
                    arrivalSoonBuses[bus] = busDataStore.busData[bus]!.arrivalSoon
                }
                debugPrint(busDataStore.busData)
                isLoading.toggle()
            }
        }
    }
}
