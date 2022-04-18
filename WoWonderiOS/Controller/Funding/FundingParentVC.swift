//
//  FundingParentVC.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 10/22/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FundingParentVC: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTabbar()
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = NSLocalizedString("Funding", comment: "Funding")

        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.moveToViewController(at: 1)
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.moveToViewController(at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    private func setupTabbar(){
        
    settings.style.buttonBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.selectedBarBackgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
//        UIColor.hexStringToUIColor(hex: "984243")
    settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
    settings.style.selectedBarHeight = 1.0
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemTitleColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
//        UIColor.hexStringToUIColor(hex: "984243")
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
    guard changeCurrentIndex == true else { return }
    oldCell?.label.textColor = .black
        newCell?.label.textColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
//            UIColor.hexStringToUIColor(hex: "984243")
    }}

    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Funding", bundle: nil).instantiateViewController(withIdentifier: "ShowFundingsVC")
        
        let child_2 = UIStoryboard(name: "Funding", bundle: nil).instantiateViewController(withIdentifier: "UserFundingVC")

        return [child_1, child_2]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
