//
//  GamesParentVC.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 7/15/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class GamesParentVC: ButtonBarPagerTabStripViewController,UISearchBarDelegate {

    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 300, height: 40))
    let placeholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.white])

    
    override func viewDidLoad() {
        self.setupUI()
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    private func setupUI(){
           self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
           
           let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
               navigationController?.navigationBar.titleTextAttributes = textAttributes
           self.navigationItem.largeTitleDisplayMode = .never
   
//           self.navigationItem.title = NSLocalizedString("Games", comment: "Games")
//           let lineColor = UIColor.black
        self.searchBar.delegate = self
        self.searchBar.tintColor = .white
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = leftNavBarButton
        if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.clearButtonMode = .never
            textfield.textColor = .white
            textfield.backgroundColor = UIColor.clear
            textfield.attributedPlaceholder = NSAttributedString(string: "\(" ")\(NSLocalizedString("Search...", comment: "Search..."))", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
           
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }
        }
        
           let lineColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
           settings.style.buttonBarItemBackgroundColor = .clear
           settings.style.selectedBarBackgroundColor = lineColor
           settings.style.buttonBarItemFont =  UIFont.systemFont(ofSize: 15.0)
           settings.style.selectedBarHeight = 2
           settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
           settings.style.buttonBarItemsShouldFillAvailableWidth = true
           settings.style.buttonBarLeftContentInset = 0
           settings.style.buttonBarRightContentInset = 0
           let color = UIColor(red:26/255, green: 34/255, blue: 78/255, alpha: 0.4)
//           let newCellColor = UIColor.black
           let newCellColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
           changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
               guard changeCurrentIndex == true else { return }
               oldCell?.label.textColor = color
               newCell?.label.textColor = newCellColor
               print("OldCell",oldCell)
               print("NewCell",newCell)
           }
           
       }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        if (self.searchBar.text?.isEmpty == true) || (self.searchBar.text == " ") || (self.searchBar.text == "  "){
            self.view.makeToast(NSLocalizedString("Please enter search text", comment: "Please enter search text"))
        }
        else{
            
            let userInfo =  ["text": self.searchBar.text!] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadSearchData"), object: nil, userInfo: userInfo)
            self.moveToViewController(at: 0)
        }
   }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
       override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
           let storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
           
           let SendMoneyVC =  storyboard.instantiateViewController(withIdentifier: "GsmesVC") as! GsmesVC
           let AddFundsVC =  storyboard.instantiateViewController(withIdentifier: "MyGamesVC") as! MyGamesVC
           return [SendMoneyVC,AddFundsVC]
           
       }
}
