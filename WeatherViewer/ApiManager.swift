import Foundation
import OAuthSwift

class ApiManager {

    private let oauth:OAuth1Swift?
    private let url:String = "https://weather-ydn-yql.media.yahoo.com/forecastrss"

    private var headers:[String: String] {
        return [
            "X-Yahoo-App-Id": "R5o7yOX8"
        ]
    }

    init() {
        self.oauth = OAuth1Swift(
            consumerKey: "dj0yJmk9MVJ1SDdLN2xlTDVSJmQ9WVdrOVVqVnZOM2xQV0RnbWNHbzlNQT09JnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PTEx",
            consumerSecret: "6bf332ddc29cca61cdf1213b7c9747ae0375ee55"
        )
    }

    func getWeatherData(
        location: String,
        success: @escaping (WeatherData?) -> Void,
        failure: @escaping () -> Void
    ) {

        makeRequest(location: location, success: {(jsonData) -> Void in

            guard let json = jsonData as? [String: Any],
                let current = json["current_observation"] as? [String: Any],
                let condition = current["condition"] as? [String: Any] else {
                    print("Error processing condition")
                    failure()
                    return
            }

            guard let temperature = condition["temperature"] as? Int,
                let description = condition["text"] as? String else {
                    print("Error getting today's data")
                    failure()
                    return
            }

            guard let forecasts = json["forecasts"] as? [[String: Any]] else {
                print("Error getting forecasts")
                failure()
                return
            }

            guard let highTemperature = forecasts[0]["high"] as? Int,
                let lowTemperature = forecasts[0]["low"] as? Int else {
                    print("Error getting today's forecast")
                    failure()
                    return
            }

            let weatherData = WeatherData(
                location:location,
                currentTemperature: temperature,
                description: description,
                highTemperature: highTemperature,
                lowTemperature: lowTemperature
            )

            success(weatherData)
        }, failure: {() -> Void in
            failure()
        })
    }

    func makeRequest(
        location: String,
        success: @escaping (Any?) -> Void,
        failure: @escaping () -> Void
    ) {

        let parameters = ["location":location, "format":"json", "u":"c"]

        self.oauth?.client.request(
            self.url,
            method: .GET,
            parameters: parameters,
            headers: self.headers,
            body: nil,
            checkTokenExpiration: true,
            success: {(data) -> Void in

                guard let json = try? JSONSerialization.jsonObject(with: data.data) else {
                    print("Unable to convert to JSON")
                    return
                }
                success(json)
            }, failure: {(data) -> Void in
                failure()
                print(data)
            }
        )
    }
}















