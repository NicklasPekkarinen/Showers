//
//  DetailsViewController.swift
//  Labb 1 Swift
//
//  Created by Nicklas Pekkarinen on 2020-02-07.
//  Copyright © 2020 Nicklas Pekkarinen. All rights reserved.
//

import UIKit
import Lottie

class DetailsViewController: UIViewController {
    
    var forecast : Forecast!
    var animatedWeatherIcon = AnimationView()
    var tempLabel = UILabel()
    var clothingImage = UIImageView()
    var animator: UIDynamicAnimator!
    var snap: UISnapBehavior!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    @IBOutlet var detailsView: UIStackView!
    @IBOutlet var detailsViewHeight: NSLayoutConstraint!
    @IBOutlet var sunriseHeader: UILabel!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var sunsetHeader: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var windHeader: UILabel!
    @IBOutlet var windspeedLabel: UILabel!
    @IBOutlet var feelsLikeHeader: UILabel!
    @IBOutlet var feelslikeLabel: UILabel!
    @IBOutlet var pressureHeader: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var humidityHeader: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    // MARK - Lifetime
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = forecast.name
        self.navigationController?.navigationBar.tintColor = .black
        initUI()
        startAnimation()
        setLabels()
        getDressCode()
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        let point = CGPoint.init(x: width * 0.5, y: animatedWeatherIcon.frame.size.height + tempLabel.frame.size.height + height * 0.255)
        animator = UIDynamicAnimator(referenceView: self.view)
        snap = UISnapBehavior(item: self.clothingImage, snapTo: point)
        snap.damping = 2
        animator.addBehavior(snap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.detailsView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        UIView.animate(withDuration: 1) {
            self.detailsView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    // MARK - UI
    func initUI() {
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        animatedWeatherIcon.frame = CGRect(x: width * 0.5 - width * 0.3 / 2, y: height * 0.2, width: width * 0.3, height: width * 0.3)
        view.addSubview(animatedWeatherIcon)
        tempLabel.frame = CGRect(x: width * 0.5 - width * 0.3 / 2, y: animatedWeatherIcon.frame.size.height + height * 0.2, width: width * 0.3, height: width * 0.3)
        tempLabel.textAlignment = .center
        tempLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(tempLabel)
        clothingImage.frame = CGRect(x: -500, y: animatedWeatherIcon.frame.size.height + tempLabel.frame.size.height + height * 0.2, width: width * 0.2, height: width * 0.2)
        view.addSubview(clothingImage)
        
        if (width > 413) {
            detailsViewHeight.constant = 170
            tempLabel.font = UIFont.systemFont(ofSize: 60, weight: UIFont.Weight.thin)
            sunriseHeader.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            sunriseLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
            sunsetHeader.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            sunsetLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
            windHeader.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            windspeedLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
            feelsLikeHeader.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            feelslikeLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
            pressureHeader.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            pressureLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
            humidityHeader.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            humidityLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
        } else {
            detailsViewHeight.constant = 150
            tempLabel.font = UIFont.systemFont(ofSize: 54, weight: UIFont.Weight.thin)
            sunriseHeader.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
            sunsetHeader.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
            windHeader.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
            feelsLikeHeader.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
            pressureHeader.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
            humidityHeader.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        }
    }
    
    func startAnimation() {
        animatedWeatherIcon.animation = Animation.named(forecast.weather[0].icon)
        animatedWeatherIcon.loopMode = .loop
        animatedWeatherIcon.play()
    }
    
    func setLabels() {
        tempLabel.text = String(Int(forecast.main.temp.rounded())) + "°"
        sunriseLabel.text = getDate(unixdate: forecast.sys.sunrise)
        sunsetLabel.text = getDate(unixdate: forecast.sys.sunset)
        windspeedLabel.text = String(Int(forecast.wind.speed.rounded())) + " m/s"
        feelslikeLabel.text = String(Int(forecast.main.feelsLike.rounded())) + "°"
        pressureLabel.text = String(forecast.main.pressure) + " hPa"
        humidityLabel.text = String(forecast.main.humidity) + "%"
    }
    
    func getDate(unixdate: Int) -> String {
        let time = NSDate.init(timeIntervalSince1970:TimeInterval(unixdate))
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let dateString = timeFormatter.string(from: time as Date)
        return dateString
    }
    
    func getDressCode() {
        switch forecast.weather[0].weatherDescription {
        case _ where forecast.weather[0].weatherDescription.contains("rain") : self.clothingImage.image = UIImage.init(named: "umbrella")
        case _ where forecast.weather[0].weatherDescription.contains("drizzle") : self.clothingImage.image = UIImage.init(named: "umbrella")
        default: switch Int(forecast.main.temp.rounded()) {
            case 30...50: self.clothingImage.image = UIImage.init(named:"sunglasses")
            case 20...29: self.clothingImage.image = UIImage.init(named:"tshirt")
            case 15...19: self.clothingImage.image = UIImage.init(named:"hoodie")
            case 10...14: self.clothingImage.image = UIImage.init(named:"jumper")
            case 5...9: self.clothingImage.image = UIImage.init(named:"jacket")
            case -20...4: self.clothingImage.image = UIImage.init(named:"coat")
            case -100 ... -21: self.clothingImage.image = UIImage.init(named:"ice")
            default: break
            }
        }
    }
}
