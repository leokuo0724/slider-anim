//
//  ViewController.swift
//  slider-anim
//
//  Created by 郭家銘 on 2020/11/15.
//

import UIKit

extension UIImageView {
    func setTint(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var moonImageView: UIImageView!
    
    typealias gradientSet = Array<Array<CGFloat>>
    
    let gradientLayer = CAGradientLayer()
    
    let startGradient: gradientSet = [[251/255, 215/255, 134/255], [198/255, 1, 221/255]]
    let endGradient: gradientSet = [[44/255, 83/255, 100/255], [15/255, 32/255, 39/255]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // building image view init
        buildingImageView.image = UIImage(named: "hades_000.png")
        buildingImageView.setTint(color: UIColor.red)
        
        // gradient layer init
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            CGColor(srgbRed: startGradient[0][0], green: startGradient[0][1], blue: startGradient[0][2], alpha: 1),
            CGColor(srgbRed: startGradient[1][0], green: startGradient[1][1], blue: startGradient[1][2], alpha: 1)
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // moon image view init
        moonRising(degrees: -30)
    }

    @IBAction func changeViews(_ sender: UISlider) {
        let result: String = String(format: "hades_%03d.png", arguments: [Int(sender.value)])
        buildingImageView.image = UIImage(named: result)
        
        let gradi0 = convertGradientSet(index: 0, startGradi: startGradient, endGradi: endGradient, currentVal: sender.value)
        let gradi1 = convertGradientSet(index: 1, startGradi: startGradient, endGradi: endGradient, currentVal: sender.value)
        
        gradientLayer.colors = [
            CGColor(srgbRed: gradi0[0], green: gradi0[1], blue: gradi0[2], alpha: 1),
            CGColor(srgbRed: gradi1[0], green: gradi1[1], blue: gradi1[2], alpha: 1)
        ]
        
        moonRising(degrees: CGFloat(sender.value))
    }
    
    func convertGradientSet(index: Int, startGradi: gradientSet, endGradi: gradientSet, currentVal: Float) -> Array<CGFloat> {
        var result: Array<CGFloat> = []
        for i in 0...2 {
            let value = convertGradient(origColor: startGradi[index][i], targetColor: endGradi[index][i], currentVal: currentVal)
            result.append(value)
        }
        return result
    }
    
    func convertGradient(origColor: CGFloat, targetColor: CGFloat, currentVal: Float) -> CGFloat {
        return origColor + (targetColor - origColor)*CGFloat(currentVal)/CGFloat(slider.maximumValue)
    }
    
    func moonRising(degrees: CGFloat) {
        moonImageView.transform = CGAffineTransform.identity.rotated(by: -CGFloat.pi / 180 * (degrees - 30)).translatedBy(x: 290, y: 0)
    }
    
}

