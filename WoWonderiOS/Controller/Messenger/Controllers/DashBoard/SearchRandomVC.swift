

import UIKit
import Async
import WoWonderTimelineSDK
import GoogleMobileAds
//import FBAudienceNetwork

class SearchRandomVC: BaseVC {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var downTextLable: UILabel!
    @IBOutlet weak var searchContactLabel: UILabel!
    @IBOutlet weak var showStack: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchRandomBtn: UIButton!
    
    var statusIndex:Int? = nil
    var searchText:String? = "random"
    private lazy var searchBar = UISearchBar(frame: .zero)
    private  var refreshControl = UIRefreshControl()
    private var userArray = [SearchModel.User]()
    private let color = UIColor.ButtonColor
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!
    
    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if statusIndex == 0{
            self.tableView.isHidden = true
            self.showStack.isHidden = false
            searchRandomBtn.isHidden = false
            
        }else {
            self.fetchData(textForSearch: searchText ?? "random", country: "", status: "", verified: "", filterByAge: "", ageFrom: "", ageTo: "")
            
        }
//                if ControlSettings.shouldShowAddMobBanner{
//
//
//                                      interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//                                      let request = GADRequest()
//                                      interstitial.load(request)
//
//                                  }
        
        
    }
        func CreateAd() -> GADInterstitialAd {
            
            GADInterstitialAd.load(withAdUnitID:ControlSettings.interestialAddUnitId,
                                   request: GADRequest(),
                                   completionHandler: { (ad, error) in
                                    if let error = error {
                                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                        return
                                    }
                                    self.interstitial = ad
                                   }
            )
            return  self.interstitial
            
        }
    
    @IBAction func setChangePressed(_ sender: Any) {
        let vc = R.storyboard.dashboard.searchFilterVC()
        vc!.modalTransitionStyle = .crossDissolve
        vc!.modalPresentationStyle = .overCurrentContext
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
        //        let vc = R.storyboard.dashboard.searchByVC()
        //        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func searchRandomPressed(_ sender: Any) {
        
        self.fetchData(textForSearch:  "all", country: "", status: "", verified: "", filterByAge: "", ageFrom: "", ageTo: "")
    }
    
    func setupUI(){
        self.searchBtn.backgroundColor = .ButtonColor
        self.searchRandomBtn.backgroundColor = .ButtonColor
        self.searchRandomBtn.setTitle(NSLocalizedString("Search Random", comment: ""), for: .normal)
        
        self.searchContactLabel.text = NSLocalizedString("Search Contact", comment: "")
        self.downTextLable.text = NSLocalizedString("Start writing to search", comment: "")
        self.showStack.isHidden = true
        searchRandomBtn.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.tableView.isHidden = true
//        searchBar.placeholder = "Search..."
//        searchBar.searchTextField.placeholder.colo = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search..", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        if let leftView = searchBar.searchTextField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }

        searchBar.delegate = self
        navigationItem.titleView = searchBar
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register( R.nib.searchRandomTableCell(), forCellReuseIdentifier: R.reuseIdentifier.searchRandom_TableCell.identifier)
        
    }
    @objc func refresh(sender:AnyObject) {
        self.userArray.removeAll()
        self.tableView.reloadData()
        self.fetchData(textForSearch: searchText ?? "random", country: "", status: "", verified: "", filterByAge: "", ageFrom: "", ageTo: "")
        
    }
    
    private func fetchData(textForSearch:String,country:String,status:String,verified:String,filterByAge:String,ageFrom:String,ageTo:String){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        self.userArray.removeAll()
        self.tableView.reloadData()
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let gender = AppInstance.instance.genderText ?? "All"
        Async.background({
            SearchManager.instance.searchUser(session_Token: sessionToken, country: "", status: "", verified: "", filterByAge: "", ageFrom: "", ageTo: "", search_Key: textForSearch, gender: gender) { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.users ?? [])")
                            if (success?.users?.isEmpty)!{
                                self.showStack.isHidden = false
                                self.searchRandomBtn.isHidden = false
                                self.tableView.isHidden = true
                                self.refreshControl.endRefreshing()
                            }else {
                                self.tableView.isHidden = false
                                self.showStack.isHidden = true
                                self.searchRandomBtn.isHidden = true
                                self.userArray = success?.users ?? []
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText)
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            
                        }
                    })
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(serverError?.errors?.errorText)
                            log.error("serverError = \(serverError?.errors?.errorText)")
                        }
                        
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            log.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
            }
            
            
        })
    }
    
}

extension SearchRandomVC: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .white
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.fetchData(textForSearch: self.searchText ?? "random", country: "", status: "", verified: "", filterByAge: "", ageFrom: "", ageTo: "")
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
        
        
    }
}

extension SearchRandomVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchRandom_TableCell.identifier) as? SearchRandom_TableCell
        let object = self.userArray[indexPath.row]
        cell?.delegate = self
        cell?.indexPath = indexPath.row
        cell?.userId  = object.userID ?? ""
        cell?.usernameLabel.text =  "\(object.firstName ?? "") \(object.lastName ?? "")"
        cell?.timeLabel.text = "Hi there I am using WoWonder"
        let url = URL.init(string:object.avatar ?? "")
        cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
        if object.isFollowing == 0{
            cell!.followBtn.backgroundColor = UIColor.white
            cell!.followBtn.borderColorV = self.color
            cell!.followBtn.borderWidthV = 1
            cell!.followBtn.setTitleColor(self.color, for: .normal)
            if AppInstance.instance.connectivity_setting == "0"{
                cell!.followBtn.setTitle(NSLocalizedString("follow", comment: "follow"), for: .normal)
            }
            else{
                cell!.followBtn.setTitle(NSLocalizedString("AddFriend", comment: "AddFriend"), for: .normal)
            }
            
        }else{
            cell!.followBtn.backgroundColor = self.color
            cell!.followBtn.setTitleColor(UIColor.white, for: .normal)
            if AppInstance.instance.connectivity_setting == "0"{
                cell!.followBtn.setTitle(NSLocalizedString("following", comment: "following"), for: .normal)
            }
            else{
                cell!.followBtn.setTitle(NSLocalizedString("AddFriend", comment: "AddFriend"), for: .normal)
            }
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppInstance.instance.addCount == ControlSettings.interestialCount {
            if ControlSettings.facebookAds {
                if let ad = interstitial {
                    //fullScreenAd = FBInterstitialAd(placementID: ControlSettings.facebookPlacementID)
                    //fullScreenAd?.delegate = self
                    //fullScreenAd?.load()
                } else {
                    print("Ad wasn't ready")
                }
            }else if ControlSettings.googleAds{
//                interstitial.present(fromRootViewController: self)
//                    interstitial = CreateAd()
//                    AppInstance.instance.addCount = 0
            }
        }
        AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
        let vc = R.storyboard.dashboard.selectRandomPopupVC()
        let userObject = userArray[indexPath.row]
        vc?.searchObject = userObject
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
}
extension SearchRandomVC:FollowUnFollowDelegate{
    
    func followUnfollow(user_id: String, index: Int, cellBtn: UIButton) {
        //        self.showProgressDialog(text: "Loading...")
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            FollowingManager.instance.followUnfollow(user_id: user_id, session_Token: sessionToken, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.followStatus ?? "")")
                            self.view.makeToast(success?.followStatus ?? "")
                            if success?.followStatus  ?? "" == "followed"{
                                cellBtn.backgroundColor = self.color
                                cellBtn.setTitleColor(UIColor.white, for: .normal)
                                if (AppInstance.instance.connectivity_setting == "0"){
                                    self.userArray[index].isFollowing = 1
                                    cellBtn.setTitle(NSLocalizedString("following", comment: "following"), for: .normal)
                                }
                                else{
                                    if (self.userArray[index].isFollowing == 0){
                                        cellBtn.backgroundColor = UIColor.white
                                        cellBtn.borderColorV = self.color
                                        cellBtn.borderWidthV = 2
                                        cellBtn.setTitleColor(self.color, for: .normal)
                                        self.userArray[index].isFollowing = 2
                                        cellBtn.setTitle(NSLocalizedString("Requested", comment: "Requested"), for: .normal)
                                    }
                                    else{
                                        self.userArray[index].isFollowing = 1
                                        cellBtn.setTitle(NSLocalizedString("MyFriend", comment: "MyFriend"), for: .normal)
                                    }
                                }
                                
                            }else{
                                cellBtn.backgroundColor = UIColor.white
                                cellBtn.borderColorV = self.color
                                cellBtn.borderWidthV = 2
                                cellBtn.setTitleColor(self.color, for: .normal)
                                if (AppInstance.instance.connectivity_setting == "0"){
                                    self.userArray[index].isFollowing = 0
                                    cellBtn.setTitle(NSLocalizedString("follow", comment: "follow"), for: .normal)
                                }
                                else{
                                    self.userArray[index].isFollowing = 0
                                    cellBtn.setTitle(NSLocalizedString("AddFriend", comment: "AddFriend"), for: .normal)
                                }
                                //                                self.view.makeToast(success?.followStatus ?? "")
                            }
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText)
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            
                        }
                    })
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(serverError?.errors?.errorText)
                            log.error("serverError = \(serverError?.errors?.errorText)")
                        }
                        
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            log.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
                
            })
            
            
        })
    }
    
    
}
extension SearchRandomVC:SelectRandomDelegate{
    func selectRandom(recipientID: String, searchObject: SearchModel.User) {
        
        let chatColor = UserDefaults.standard.getChatColorHex(Key: Local.CHAT_COLOR_HEX.ChatColorHex)
        let vc = R.storyboard.chat.chatScreenVC()
        vc?.recipientID = recipientID
        vc!.searchUserObject = searchObject
        vc?.chatColorHex = chatColor
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}
extension SearchRandomVC:SearchDelegate{
    func filterSearch(gender: String, countryId: String, ageTo: String, ageFrom: String, verified: String, status: String, profilePic: String) {
        self.userArray.removeAll()
        self.tableView.reloadData()
        self.fetchData(textForSearch: "", country: countryId, status: status, verified: verified, filterByAge: "", ageFrom: ageFrom, ageTo: ageTo)
    }
    func locationSearch(location: String, countryId: String) {
        log.verbose("Locatiom = \(location)")
    }
    
}

//extension SearchRandomVC :FBInterstitialAdDelegate{
//    //Place your placementID here to see the Facebook ads
//    func loadFullViewAdd(){
//        //fullScreenAd = FBInterstitialAd(placementID: ControlSettings.facebookPlacementID)
//        fullScreenAd.delegate = self
//        fullScreenAd.load()
//    }
//    
//    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
//        interstitialAd.show(fromRootViewController: self)
//        print("AddLoaded")
//        
//    }
//    func interstitialAdWillClose(_ interstitialAd: FBInterstitialAd) {
//        
//    }
//}
