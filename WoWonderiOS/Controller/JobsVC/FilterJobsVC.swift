//
//  FilterJobsVC.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 7/22/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import UIKit
import WoWonderTimelineSDK

class FilterJobsVC: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet var filterBtn: RoundButton!
    @IBOutlet var filterLbl: UILabel!
    @IBOutlet var distanceLbl: UILabel!
    
    var delegate :ProductDistanceDelegate!
    var distance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.distanceSlider.thumbTintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.distanceSlider.minimumTrackTintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.filterLbl.text = NSLocalizedString("Filter", comment: "Filter")
        self.filterBtn.setTitle(NSLocalizedString("APPLY FILTER", comment: "APPLY FILTER"), for: .normal)
        self.distanceLbl.text = NSLocalizedString("Distance", comment: "Distance")
        self.distanceSlider.value =  (self.distance as NSString).floatValue
        self.distanceLabel.text! = "\(self.distance)\(" Km")"
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SliderChangedValue(_ sender: Any) {
        self.distanceLabel.text! = "\(String(format: "%i",Int(self.distanceSlider.value)))\(" km")"
        self.distance = String(format: "%i",Int(self.distanceSlider.value))
//        "\(self.distanceSlider.value)\(" ")\("Km")"
    }
    
    
    @IBAction func ApplyFilter(_ sender: Any) {
        self.dismiss(animated: true) {
                    self.delegate.productDistance(distance: Int(self.distance) ?? 0)

        }
    }
    

}
