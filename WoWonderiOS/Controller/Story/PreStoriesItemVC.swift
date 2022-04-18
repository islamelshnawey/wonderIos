import WoWonderTimelineSDK
import UIKit
import AVFoundation
import SDWebImage
import Alamofire
import Kingfisher
class PreStoriesItemVC: UIViewController {
    
    var pageIndex : Int = 0
    var item: [GetStoriesModel.UserDataStory] = []
    var items: [GetStoriesModel.UserDataElement] = []
    var SPB: SegmentedProgressBar!
    var player: AVPlayer!
    var refreshStories: (() -> Void)?
    let status = Reach().connectionStatus()

    
    @IBOutlet weak var trashBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var reset = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if items[pageIndex].userID != UserData.getUSER_ID() ?? "" {
//            self.trashBtn.isHidden = true
//        }
        self.trashBtn.isHidden = false
        
//        self.trashBtn.setImage(Ionicons.trashA.image(50.0, color: UIColor.hexStringToUIColor(hex: "#FFFFFF")), for: UIControl.State.normal)
        
        userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height / 2;
        
        self.userProfileImage!.sd_setImage(with: URL(string: items[pageIndex].avatar!)) { (image, error, cacheType, url) in
            if error == nil {
                self.userProfileImage.image = image
            }
        }
        
        lblUserName.text = "\(items[pageIndex].username ?? "")"
        item = items[pageIndex].stories!
        
        SPB = SegmentedProgressBar(numberOfSegments: item.count, duration: 5)
        if #available(iOS 11.0, *) {
            SPB.frame = CGRect(x: 18, y: UIApplication.shared.statusBarFrame.height + 5, width: view.frame.width - 35, height: 3)
        } else {
            // Fallback on earlier versions
            SPB.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 3)
        }
        
        SPB.delegate = self
        SPB.topColor = UIColor.white
        SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
        SPB.padding = 2
        SPB.isPaused = true
        SPB.currentAnimationIndex = 0
        SPB.duration = getDuration(at: 0)
        view.addSubview(SPB)
        view.bringSubviewToFront(SPB)
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        imagePreview.addGestureRecognizer(tapGestureImage)
        
        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureVideo.numberOfTapsRequired = 1
        tapGestureVideo.numberOfTouchesRequired = 1
        videoView.addGestureRecognizer(tapGestureVideo)
        
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.8) {
            self.view.transform = .identity
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.SPB.startAnimation()
            self.playVideoOrLoadImage(index: 0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.SPB.currentAnimationIndex = 0
            self.SPB.cancel()
            self.SPB.isPaused = true
            self.resetPlayer()
        }
    }
    
    
    @IBAction func trashPressed(_ sender: Any) {
        self.deleteStory(storyID: Int(self.item[self.SPB.currentAnimationIndex].id!)!)
//        print("trash Pressed")
//        print(UserData.getAccess_Token())
//        print(APIClient.Params.serverKey)
//        print(APIClient.SERVER_KEY.Server_Key)
//        print(self.item[self.SPB.currentAnimationIndex].id!)
      //  self.refreshStories!()
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "HomeVC") as? HomeVC
        controller?.getNewsFeed2(access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token()!)", limit: 20, offset: "0")
        self.dismiss(animated: true, completion: {
            
        })
        resetPlayer()
    }
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        SPB.skip()
    }
    
    private func getDuration(at index: Int) -> TimeInterval {
        var retVal: TimeInterval = 5.0
        if item[index].videos!.isEmpty{
            retVal = 5.0
        } else {
            guard let url = NSURL(string: item[index].thumbnail!) as URL? else { return retVal }
            let asset = AVAsset(url: url)
            let duration = asset.duration
            retVal = CMTimeGetSeconds(duration)
        }
        return retVal
    }
    
    private func resetPlayer() {
        if player != nil {
            player.pause()
            player.replaceCurrentItem(with: nil)
            player = nil
        }
    }
    
    //MARK: - Button actions
    @IBAction func close(_ sender: Any) {
       // self.refreshStories!()
        self.dismiss(animated: true, completion: {
            
        })
        resetPlayer()
    }
    
    func playVideoOrLoadImage(index: Int) {
        
        if item[index].videos!.isEmpty {
            self.SPB.duration = 5
            self.imagePreview.isHidden = false
            self.videoView.isHidden = true
//            self.imagePreview!.sd_setImage(with: URL(string: item[index].thumbnail!)) { (image, error, cacheType, url) in
//
//            }
            self.imagePreview.kf.setImage(with: URL(string: item[index].thumbnail!))
        } else {
            self.imagePreview.isHidden = true
            self.videoView.isHidden = false
            
            resetPlayer()
            guard let url = NSURL(string:  item[index].videos?[0].filename ?? "") as URL? else {return}
            self.player = AVPlayer(url: url)
            
            let videoLayer = AVPlayerLayer(player: self.player)
            videoLayer.frame = view.bounds
            videoLayer.videoGravity = .resizeAspect
            self.videoView.layer.addSublayer(videoLayer)
            
            let asset = AVAsset(url: url)
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            
            self.SPB.duration = durationTime
            self.player.play()
        }
    }
    
    private func deleteStory(storyID: Int) {
        let params = [APIClient.Params.serverKey: APIClient.SERVER_KEY.Server_Key, APIClient.Params.story_id: Int(self.item[self.SPB.currentAnimationIndex].id!)!] as [String : Any]
        let url = APIClient.Stories.deleteStory + "?" + APIClient.Params.accessToken + "=" + UserData.getAccess_Token()!
        
    AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.value != nil {
                
            }
            else {
                print(response.error?.localizedDescription)
            }
        }
        
        print(url)
    }
    
//    private func deleteStory(storyID:Int){
//        if Connectivity.isConnectedToNetwork(){
//            self.showProgressDialog(text: "Loading...")
//
//            let accessToken = AppInstance.instance.accessToken ?? ""
//            Async.background({
//                StoryManager.instance.deleteStory(accessToken: accessToken, storyId: storyID, completionBlock: { (success, sessionError, error) in
//                    if success != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//
//                                log.debug("userList = \(success?.message)")
//                                var temp = self.item
//                                temp.remove(at: self.SPB.currentAnimationIndex)
//                                self.item = temp
//
//                                if self.item.count == 0 {
//                                    if  self.pageIndex == (self.items.count - 1) {
//                                        self.refreshStories!()
//                                        self.dismiss(animated: true, completion: {
//
//                                        })
//                                    } else {
//                                        PPStoriesItemsViewControllerVC.goNextPage(fowardTo: self.pageIndex + 1)
//                                    }
//                                }else{
//                                    self.reset = true
//                                    self.SPB.removeFromSuperview()
//
//                                    self.SPB = SegmentedProgressBar(numberOfSegments: self.item.count, duration: 5)
//                                    self.SPB.delegate = self
//                                    self.SPB.topColor = UIColor.white
//                                    self.SPB.bottomColor = UIColor.white.withAlphaComponent(0.25)
//                                    self.SPB.padding = 2
//                                    self.SPB.isPaused = true
//                                    self.SPB.currentAnimationIndex = 0
//                                    self.view.addSubview(self.SPB)
//                                    self.view.bringSubviewToFront(self.SPB)
//                                    self.playVideoOrLoadImage(index: 0)
//                                }
//                            }
//                        })
//                    }else if sessionError != nil{
//                        Async.main({
//                            self.dismissProgressDialog {
//
//                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
//                                log.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
//                            }
//                        })
//                    }else {
//                        Async.main({
//                            self.dismissProgressDialog {
//                                self.view.makeToast(error?.localizedDescription ?? "")
//                                log.error("error = \(error?.localizedDescription ?? "")")
//                            }
//                        })
//                    }
//                })
//            })
//
//        }else{
//            log.error("internetError = \(InterNetError)")
//            self.view.makeToast(InterNetError)
//        }
//    }
    
}

extension PreStoriesItemVC : SegmentedProgressBarDelegate {
    
    func segmentedProgressBarChangedIndex(index: Int) {
        playVideoOrLoadImage(index: index)
    }
    
    func segmentedProgressBarFinished() {
        print("segmentedProgressBarFinished")
        print(self.pageIndex)
        print(self.items.count)
        
        if  pageIndex == (self.items.count - 1) {
            
            self.dismiss(animated: true, completion: {
                let story = UIStoryboard(name: "Main", bundle: nil)
                let controller = story.instantiateViewController(identifier: "HomeVC") as? HomeVC
                controller?.loadStories()
             //   self.refreshStories!()
            })
        } else {
            PPStoriesItemsViewControllerVC.goNextPage(fowardTo: pageIndex + 1)
        }
    }
    
}
