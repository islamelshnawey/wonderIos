//
//  GsmesVC.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 7/15/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import Toast_Swift
import AVFoundation
import WoWonderTimelineSDK
import XLPagerTabStrip
class GsmesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noVideoView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noImage: UIImageView!
    @IBOutlet weak var noGameLbl: UILabel!
    
    var gamesArray = [[String:Any]]()
    let pulltoRefresh = UIRefreshControl()
    let status = Reach().connectionStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.activityIndicator.color = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.noImage.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.noGameLbl.text = NSLocalizedString("No games!!", comment: "No games!!")
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.largeTitleDisplayMode = .never
//        self.navigationController?.navigationItem.title = "My Videos"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        NotificationCenter.default.post(name: Notification.Name(ReachabilityStatusChangedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.LoadSearchData(notification:)), name: NSNotification.Name(rawValue: "LoadSearchData"), object: nil)
        self.pulltoRefresh.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.pulltoRefresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.collectionView.addSubview(pulltoRefresh)
        self.getNearByUsers()
    }
    
    
    
    
    //Pull To Refresh
    
    @objc func refresh(){
        self.gamesArray.removeAll()
        self.collectionView.reloadData()
        self.getNearByUsers()
    }
    
    @IBAction func LoadSearchData(notification: NSNotification){
        self.pulltoRefresh.endRefreshing()
        self.activityIndicator.startAnimating()
        self.gamesArray.removeAll()
        self.collectionView.reloadData()
        if let keyword = notification.userInfo?["text"] as? String{
            self.searchGames(text: keyword)
        }
       
    }
    
    private func getNearByUsers() {
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GamesManager.sharedInstance.getGames(limit: 0, offset: 0, type: "get") { (success, sessionError, error) in
                    if success != nil {
                        self.gamesArray = success?.data ?? []
                        if self.gamesArray.count != 0{
                            self.collectionView.isHidden = false
                            self.noVideoView.isHidden = true
                            
                        }
                        else{
                            self.collectionView.isHidden = true
                            self.noVideoView.isHidden = false
                        }
                        self.pulltoRefresh.endRefreshing()
                        self.activityIndicator.stopAnimating()
                        self.collectionView.reloadData()
                    }
                    else if sessionError != nil {
                        self.view.makeToast(sessionError?.errors?.errorText)
                    }
                    else if error != nil {
                        print(error?.localizedDescription)
                    }
                }
                
            }
        }
    }
    
    private func searchGames(text: String){
        SearchGameManager.sharedInstance.searchGame(text: text) { (success, authError, error) in
            if (success != nil){
                
                for i in success!.data{
                    self.gamesArray.append(i)
                }
                if self.gamesArray.count != 0{
                    self.collectionView.isHidden = false
                    self.noVideoView.isHidden = true
                    
                }
                else{
                    self.collectionView.isHidden = true
                    self.noVideoView.isHidden = false
                }
                self.pulltoRefresh.endRefreshing()
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
                
            }
            else if (authError != nil){
                self.view.makeToast(authError?.errors?.errorText)
            }
            else if (error != nil){
                self.view.makeToast(error?.localizedDescription)
            }
        }
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension GsmesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gamesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamesCollectionCell", for: indexPath) as! GamesCollectionCell
        let object = self.gamesArray[indexPath.row]
         cell.gamesVc = self
        cell.bind(object: object)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width - 10
        return CGSize(width: collectionViewSize/2, height: 255.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
extension GsmesVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("GAMES", comment: "GAMES"))
    }
}
