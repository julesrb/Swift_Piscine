class WeatherVM: ObservableObject {
    @State var weather : Weather?
    
    func startWeatherRequest(lat: Double, longi: Double) {
        Task {
            do {
                let data = try await WeatherAPI.fetchWeather(lat: lat, longi: longi)
                print(data)
                weather = data
            } catch {
                print("error with API call")
            }
        }
    }
}