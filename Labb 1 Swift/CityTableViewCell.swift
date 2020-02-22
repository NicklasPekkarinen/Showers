//
//  CityTableViewCell.swift
//  Labb 1 Swift
//
//  Created by Nicklas Pekkarinen on 2020-02-05.
//  Copyright © 2020 Nicklas Pekkarinen. All rights reserved.
//

import UIKit
import Lottie

class CityTableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var animatedWeatherIcon: AnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startAnimation()
    }
    
    override func prepareForReuse() {
        startAnimation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // Lottie animation
    func startAnimation() {
        animatedWeatherIcon.animation = Animation.named("sun-weather")
        animatedWeatherIcon.loopMode = .loop
        animatedWeatherIcon.play()
    }


}
