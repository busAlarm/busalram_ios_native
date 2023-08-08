//
//  BusData.swift
//  busalram_ios_native
//
//  Created by 한현민 on 2023/08/08.
//

import Foundation
import SwiftUI

struct BusData: Codable {
    var routeID, timeStamp, firstTime, lastTime: String
    var predictTime1, stationNm1, predictTime2, stationNm2: String
    var isRunning, arrivalSoon: Bool

    enum CodingKeys: String, CodingKey {
        case routeID = "routeId"
        case timeStamp, firstTime, lastTime, predictTime1, stationNm1, predictTime2, stationNm2, isRunning, arrivalSoon
    }
}

extension BusData {
    static let dummy = BusData(routeID: "", timeStamp: "", firstTime: "", lastTime: "", predictTime1: "", stationNm1: "", predictTime2: "", stationNm2: "", isRunning: false, arrivalSoon: false)
    
    static let colors: [String: Color] = [
        "24": .orange,
        "720-3": .green,
        "shuttle": .blue,
        "셔틀": .blue,
    ]
    
    static func getBusColor(name: String) -> Color {
        switch name {
        case "24":
            return colors[name]!
        case "720-3":
            return colors[name]!
        case "셔틀", "shuttle":
            return colors[name]!
        default:
            return .white
        }
    }
    
    static func getBusName(name: String) -> String {
        switch name {
        case "shuttle":
            return "셔틀"
        default:
            return name
        }
    }
}

@MainActor
class BusDataStore: ObservableObject {
    @Published var busData: [String: BusData] = [
        "24": BusData.dummy,
        "720-3": BusData.dummy,
        "shuttle": BusData.dummy
    ]
    
    var recentRefreshTimeStamp: String = ""
    
    // ["24", "720-3", "shuttle"]
    let availableRoutes: [String] = ["24", "720-3", "shuttle"]
    
    func retrieveBusData(routeNumber: String) async -> RequestStatus {
        if !Array(busData.keys).contains(where: {
            routeNumber == $0
        }) {
            return .invalidParamError
        }
        
        let baseUrl: String = "https://2ot8ocxpaf.execute-api.ap-northeast-2.amazonaws.com/businfo"
        
        let url = URL(string: "\(baseUrl)?bus=\(routeNumber)")!
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // 네트워크 오류 감지
            guard let response = response as? HTTPURLResponse else {
                debugPrint("failed to communicate with server")
                return .commError
            }
            
            // 네트워크 오류 감지 2
            if response.statusCode != 200 {
                debugPrint("failed to communicate with server")
                return .commError
            }
            
            // 응답 body를 BusData로 형변환
            busData[routeNumber] = try JSONDecoder().decode(BusData.self, from: data)
            recentRefreshTimeStamp = busData[routeNumber]?.timeStamp ?? ""
            return .success
            
        } catch _ as URLError {
            debugPrint("failed to convert URL")
            return .urlError
        } catch _ as DecodingError {
            debugPrint("failed to decode retrieved data")
            return .decodeError
        } catch {
            debugPrint("failed to handling network error")
            return .commError
        }
    }
}
