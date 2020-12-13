import Foundation

class WeatherData {
    
    let location: String
    let currentTemperature: Int
    let description: String
    let highTemperature: Int
    let lowTemperature: Int
    
    init(
        location: String,
        currentTemperature: Int,
        description: String,
        highTemperature: Int,
        lowTemperature: Int
    ) {
        
        self.location = location
        self.currentTemperature = currentTemperature
        self.description = description
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
    }
}
