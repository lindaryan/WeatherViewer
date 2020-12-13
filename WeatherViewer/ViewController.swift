import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerLabel)
        view.addSubview(searchField)
        view.addSubview(searchButton)
        view.addSubview(temperatureLabel)
        view.addSubview(temperatureValueLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionValueLabel)
        view.addSubview(highTemperatureLabel)
        view.addSubview(highTemperatureValueLabel)
        view.addSubview(lowTemperatureLabel)
        view.addSubview(lowTemperatureValueLabel)
        
        toggleDisplay(isHidden: true)
        
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var headerLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.text = "Weather Viewer"
        view.font = view.font.withSize(36)
        view.textAlignment = .center
        
        return view
    }()
    
    lazy var searchField: UITextField! = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.placeholder = "City"
        view.textAlignment = .left
        view.font = .systemFont(ofSize: 24)
        
        return view
    }()
    
    lazy var searchButton: UIButton! = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.setTitle("Search", for: .normal)
        view.backgroundColor = UIColor.white
        view.setTitleColor(UIColor.black, for: .normal)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        
        view.addTarget(self, action: #selector(onSearchClicked), for: .touchDown)
        
        return view
    }()
    
    @objc func onSearchClicked() {
        guard let location = searchField.text else {
            print("Error getting text")
            return
        }
        
        let apiManager:ApiManager = ApiManager()
        
        DispatchQueue.global(qos: .userInitiated).async {
            apiManager.getWeatherData(location: location, success: {(data) -> Void in
                
                guard let weatherData = data else {
                    print("Error getting weather data")
                    return
                }
                
                DispatchQueue.main.async {
                    self.temperatureValueLabel.text = String(weatherData.currentTemperature) + "°C"
                    self.descriptionValueLabel.text = weatherData.description
                    self.highTemperatureValueLabel.text = "High: " + String(weatherData.highTemperature) + "°C"
                    self.lowTemperatureValueLabel.text = "Low: " + String(weatherData.lowTemperature) + "°C"

                    self.toggleDisplay(isHidden: false)
                }
            }, failure: {() -> Void in
                DispatchQueue.main.async {
                    self.showMessage(message: "Failed to get weather data, please try again.")
                }
            })
        }
    }
    
    private func showMessage(message: String) {
        
        let rect = CGRect(
            x: self.view.frame.size.width / 2 - 150,
            y: self.view.frame.size.height / 2 - 100,
            width: 300,
            height: 45
        )
        
        let toastLabel = UILabel(frame: rect)
        
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 1.0
        toastLabel.alpha = 1
        toastLabel.numberOfLines = 0
        toastLabel.text = message
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, animations: {
            toastLabel.alpha = 0
        })
    }
    
    private func toggleDisplay(isHidden: Bool) {
        temperatureLabel.isHidden = isHidden
        temperatureValueLabel.isHidden = isHidden
        descriptionLabel.isHidden = isHidden
        descriptionValueLabel.isHidden = isHidden
        highTemperatureLabel.isHidden = isHidden
        highTemperatureValueLabel.isHidden = isHidden
        lowTemperatureLabel.isHidden = isHidden
        lowTemperatureValueLabel.isHidden = isHidden
    }
    
    func createLabel(text: String) -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = text
        view.font = view.font.withSize(20)
        return view
    }
    
    lazy var temperatureLabel: UILabel! = {
        return createLabel(text: "Temperature:")
    }()
    
    lazy var temperatureValueLabel: UILabel! = {
        return createLabel(text: "25°C")
    }()
    
    lazy var descriptionLabel: UILabel! = {
        return createLabel(text: "Description:")
    }()
    
    lazy var descriptionValueLabel: UILabel! = {
        return createLabel(text: "Sunny")
    }()
    
    lazy var highTemperatureLabel: UILabel! = {
        return createLabel(text: "Tomorrow's High: ")
    }()
    
    lazy var highTemperatureValueLabel: UILabel! = {
        return createLabel(text: "")
    }()
    
    lazy var lowTemperatureLabel: UILabel! = {
        return createLabel(text: "Tomorrow's Low: ")
    }()
    
    lazy var lowTemperatureValueLabel: UILabel! = {
        return createLabel(text: "")
    }()
    
    override func updateViewConstraints() {
        let margins = view.layoutMarginsGuide
        
        headerLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        searchField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        searchField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 5).isActive = true

        temperatureLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        temperatureValueLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20).isActive = true
        temperatureValueLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionValueLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10).isActive = true
        descriptionValueLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        
        highTemperatureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        highTemperatureLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        highTemperatureValueLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        highTemperatureValueLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        
        lowTemperatureLabel.topAnchor.constraint(equalTo: highTemperatureLabel.bottomAnchor, constant: 10).isActive = true
        lowTemperatureLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        lowTemperatureValueLabel.topAnchor.constraint(equalTo: highTemperatureLabel.bottomAnchor, constant: 10).isActive = true
        lowTemperatureValueLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true

        super.updateViewConstraints()
    }
}














