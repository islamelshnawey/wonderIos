

import UIKit
import XLPagerTabStrip
import WoWonderTimelineSDK

class SearchController:ButtonBarPagerTabStripViewController,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var navView: UIView!
    @IBOutlet var filterBtn: RoundButton!
    @IBOutlet var gradientView: UIView!
    
    var isFromPage = 0
    var isFromGroup = 0
    
    let Storyboard = UIStoryboard(name: "Search", bundle: nil)
    override func viewDidLoad() {
        self.setupTabbar()
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.navView.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.searchBar.barTintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.filterBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        self.searchBar.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.SetUpSearchField()
        self.searchBar.tintColor = .white
        self.searchBar.backgroundColor = .clear
        self.searchBar.layer.borderColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor).cgColor
        self.searchBar.backgroundImage = UIImage()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor).cgColor, UIColor.hexStringToUIColor(hex: "#000000").cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.gradientView.frame.size.width, height: self.gradientView.frame.size.height)
        self.gradientView.layer.insertSublayer(gradient, at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.isFromPage == 1){
            self.moveToViewController(at: 1)
        }
        if (self.isFromGroup == 1){
            self.moveToViewController(at: 2)
        }
    }
    
    /// Network Connectivity
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print("Status",status)
        }
    }
    private func SetUpSearchField(){
        if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.clearButtonMode = .never
            textfield.backgroundColor = .clear
            textfield.attributedPlaceholder = NSAttributedString(string:"\(" ")\(NSLocalizedString("Search...", comment: "Search..."))", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
            textfield.textColor = .white
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }
        }
    }
    
    private func setupTabbar(){
     settings.style.buttonBarBackgroundColor = .clear
     settings.style.buttonBarItemBackgroundColor = .clear
     settings.style.selectedBarBackgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
//        UIColor.hexStringToUIColor(hex:"#994141")
     settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
     settings.style.selectedBarHeight = 2.0
     settings.style.buttonBarMinimumLineSpacing = 0
     settings.style.buttonBarItemTitleColor = .white
     settings.style.buttonBarItemsShouldFillAvailableWidth = true
     settings.style.buttonBarLeftContentInset = 0
     settings.style.buttonBarRightContentInset = 0

     changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
     guard changeCurrentIndex == true else { return }
        oldCell?.label.textColor = UIColor.hexStringToUIColor(hex: "#DAC2C0")
        newCell?.label.textColor = .white
        print(self?.currentIndex ?? 0)
        if (self?.currentIndex == 0){
            self?.filterBtn.isHidden = false
        }
        else if (self?.currentIndex == 1){
            self?.filterBtn.isHidden = true
        }
        else if (self?.currentIndex == 2){
            self?.filterBtn.isHidden = true
        }
     }
        
    }
    
    
    func changeIndex(){
        self.moveToViewController(at: 0)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchUserVC") as! SearchUserController
        self.filterBtn.isHidden = false
        let child_2 = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchPageVC") as! SearchPageController
//        self.filterBtn.isHidden = true
        if (self.isFromPage == 1){
            child_2.isFromPage = 1
        }
        let child_3 = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchGroupVC") as! SearchGroupController
//        self.filterBtn.isHidden = true
        if (self.isFromGroup == 1){
            child_3.isFromGroup = 1
        }
    return [child_1,child_2,child_3]
    }
    
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
        print(toIndex)
    }
    
    
//     override func moveToViewController(at index: Int, animated: Bool = true) {
//        print(index)
//    }
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Filter(_ sender: Any) {
        let vc = Storyboard.instantiateViewController(withIdentifier: "SearchFilterVC") as! SearchFilterController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let userInfo =  ["gender": "","country": "","verified": "","status": "","profilePic": "","filterbyage": "","age_from": "", "age_to": "","keyword": self.searchBar.text!] as [String : Any]
        self.searchBar.resignFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadFilterData"), object: nil, userInfo: userInfo)
    }
}

public protocol PagerTabStripDelegate: class {

    func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int)
}

public protocol PagerTabStripIsProgressiveDelegate : PagerTabStripDelegate {

    func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool)
}
