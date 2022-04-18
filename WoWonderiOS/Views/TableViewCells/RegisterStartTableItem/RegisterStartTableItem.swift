//
//  RegisterStartTableItem.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 5/24/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class RegisterStartTableItem: UITableViewCell {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var registerUsingEmailBtn: UIView!
    @IBOutlet weak var facebookRegisterBtn: UIButton!
    @IBOutlet weak var googleRegisterBtn: UIButton!
    
    var vc:RegisterStartVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        registerUsingEmailBtn.applyBlurEffect1()
        facebookRegisterBtn.addBlurEffect()
        googleRegisterBtn.addBlurEffect()
        blurView.applyBlurEffect()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        registerUsingEmailBtn.addGestureRecognizer(tapGesture)


    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let vc = R.storyboard.authentication.registerVC()
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
      }

    @IBAction func googlePressed(_ sender: Any) {
        self.vc?.googleLogin()
    }
    
    @IBAction func facebookpressed(_ sender: Any) {
        self.vc?.facebookLogin()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        self.vc?.navigationController?.popViewController(animated: true)
    }
}
