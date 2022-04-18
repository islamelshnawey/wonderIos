//
//  EndLiveStreamController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/16/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class EndLiveStreamController: UIViewController {
    
    
    @IBOutlet var readyLbl: UILabel!
    @IBOutlet var textLbl: UILabel!
    @IBOutlet var yesBtn: UIButton!
    @IBOutlet var noBtn: UIButton!
    
    var delegate: endLiveDelegate?
    
    var readyText = ""
    var textTxt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.readyLbl.text = readyText
        self.textLbl.text = textTxt
        self.yesBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.noBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)

    }
    

    @IBAction func Yes(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.endLive()
        }
    }
    

    @IBAction func No(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
