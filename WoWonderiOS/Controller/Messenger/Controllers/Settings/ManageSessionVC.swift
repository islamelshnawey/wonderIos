

import UIKit
import Async
import SwiftEventBus
import WoWonderTimelineSDK
import GoogleMobileAds

class ManageSessionVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    private  var refreshControl = UIRefreshControl()
    var sessionArray = [SessionModel.Datum]()
    var interstitial: GADInterstitialAd!
    private var fetchSatus:Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchData()
//        if ControlSettings.shouldShowAddMobBanner{
//            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//            let request = GADRequest()
//            interstitial.load(request)
//        }
    }
    
    func setupUI(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.title = NSLocalizedString("Manage Sessions", comment: "Manage Sessions")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.manageSessionTableItem(), forCellReuseIdentifier: R.reuseIdentifier.manageSessionTableItem.identifier)
////
//        if ControlSettings.shouldShowAddMobBanner{
//
//            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//            let request = GADRequest()
//            interstitial.load(request)
//
//        }
    }
    @objc func refresh(sender:AnyObject) {
        fetchSatus = true
        self.sessionArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
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
    private func fetchData(){
        if fetchSatus!{
            fetchSatus = false
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        }else{
            log.verbose("will not show Hud more...")
        }
        
        self.sessionArray.removeAll()
        self.tableView.reloadData()
        let sessionToken = AppInstance.instance.sessionId ?? ""
        
        Async.background({
            SessionManager.instance.getSession(session_Token: sessionToken, type: "get") { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            if (success?.data?.isEmpty)!{
                                self.refreshControl.endRefreshing()
                            }else {
                                
                                self.sessionArray = (success?.data) ?? []
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                            
                        }
                    })
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(serverError?.errors?.errorText ?? "")
                            log.error("serverError = \(serverError?.errors?.errorText ?? "")")
                        }
                        
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription ?? "")
                            log.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
            
        })
        
    }
    
}
extension ManageSessionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}


extension ManageSessionVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sessionArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:R.reuseIdentifier.manageSessionTableItem.identifier) as! ManageSessionTableItem
        cell.vc = self
        let object = self.sessionArray[indexPath.row]
        cell.bind(object, index: indexPath.row)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppInstance.instance.addCount == ControlSettings.interestialCount {
             if ControlSettings.googleAds{
                interstitial.present(fromRootViewController: self)
                    interstitial = CreateAd()
                    AppInstance.instance.addCount = 0
            }
        }
        AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
    }
}
