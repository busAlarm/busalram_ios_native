//
//  WeatherData.swift
//  busalram_ios_native
//
//  Created by 한현민 on 2023/08/08.
//

import Foundation

struct WeatherData: Codable {
    let timeStamp: String
    let minTemp, currentTemp, maxTemp, weather: String
    let microDust, ultraMicroDust: String
}

extension WeatherData {
    static let dummy = WeatherData(timeStamp: "", minTemp: "", currentTemp: "", maxTemp: "", weather: "", microDust: "", ultraMicroDust: "")
}

// SwiftUI 뷰에 영향을 끼치는 요소를 건드리는 메서드가 있는 class, struct, enum 등이 있을 때는 선언부 위에 @MainActor를 써 해당 코드가 백그라운드 스레드가 아닌 메인 스레드에서 실행되게 해야 한다.
@MainActor
class WeatherDataStore: ObservableObject {
    @Published var weatherData: WeatherData = WeatherData.dummy
    
    func retrieveWeatherData() async -> RequestStatus {
        let baseUrl: String = "https://b6m7et9sdl.execute-api.ap-northeast-2.amazonaws.com/weather"
        
        let url = URL(string: "\(baseUrl)")!
        
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
            weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
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
