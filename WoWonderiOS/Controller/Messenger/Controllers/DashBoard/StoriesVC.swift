
import UIKit
import XLPagerTabStrip
import Floaty
import Async
import WoWonderTimelineSDK
import GoogleMobileAds
import ActionSheetPicker_3_0
//import FBAudienceNetwork
import SwiftEventBus

class StoriesVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var floaty = Floaty()
    var shouldRefreshStories = false
    private var storiesArray = [GetStoriesModel.UserDataElement]()
    private  var refreshControl = UIRefreshControl()
    private let imagePickerController = UIImagePickerController()
    var delegate:ImagePickerDelegate?

    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd!

    //Facebook Ads
    //var fullScreenAd: FBInterstitialAd!
    //var bannerAdView: FBAdView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
//        if ControlSettings.shouldShowAddMobBanner{
//
//            if ControlSettings.googleAds {
//                interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//                let request = GADRequest()
//                interstitial.load(request)
//                interstitial.delegate = self
//            }else if ControlSettings.facebookAds{
//                loadFullViewAdd()
//            }
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
        SwiftEventBus.postToMainThread("settings", sender: 1)
    }
  
    func setupUI(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.storiesTableCell(), forCellReuseIdentifier: R.reuseIdentifier.stories_TableCell.identifier)
        tableView.register( R.nib.storySectionOneTableItem(), forCellReuseIdentifier: R.reuseIdentifier.storySectionOneTableItem.identifier)
        tableView.register( R.nib.storySectionThreeTableItem(), forCellReuseIdentifier: R.reuseIdentifier.storySectionThreeTableItem.identifier)
        floaty.buttonColor = UIColor.hexStringToUIColor(hex: "B46363")
        floaty.itemImageColor = .white
        let videoItem = FloatyItem()
        videoItem.hasShadow = true
        videoItem.buttonColor = UIColor.hexStringToUIColor(hex: "B46363")
        videoItem.circleShadowColor = UIColor.black
        videoItem.titleShadowColor = UIColor.black
        videoItem.titleLabelPosition = .left
        videoItem.title = NSLocalizedString("Video", comment: "Video")
        videoItem.iconImageView.image = R.image.ic_video()
        videoItem.handler = { item in
            let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .actionSheet)
            let gallery = UIAlertAction(title: NSLocalizedString("Gallery", comment: "Gallery"), style: .default) { (action) in
                self.openVideoGallery()
            }
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
            
            alert.addAction(gallery)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        let cameraItem = FloatyItem()
        cameraItem.hasShadow = true
        cameraItem.buttonColor = UIColor.hexStringToUIColor(hex: "B46363")
        cameraItem.circleShadowColor = UIColor.black
        cameraItem.titleShadowColor = UIColor.black
        cameraItem.titleLabelPosition = .left
        cameraItem.title = NSLocalizedString("Camera", comment: "Camera")
        cameraItem.iconImageView.image = R.image.ic_camera()
        cameraItem.handler = { item in
            
            let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
                self.delegate = self
                self.imagePickerController.delegate = self
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
            let gallery = UIAlertAction(title: NSLocalizedString("Gallery", comment: "Gallery"), style: .default) { (action) in
                self.delegate = self
                self.imagePickerController.delegate = self
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
            alert.addAction(camera)
            alert.addAction(gallery)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
        }
        
//        floaty.addItem(item: videoItem)
//        floaty.addItem(item: cameraItem)
//        self.view.addSubview(floaty)
        
//        if ControlSettings.shouldShowAddMobBanner{
//
//            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//            let request = GADRequest()
//            interstitial.load(request)
//        }
        
        
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
    @objc func refresh(sender:AnyObject) {
        self.storiesArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
    }
    
    private func fetchData(){
        
        Async.background({
            StoriesManager.instance.getStories(session_Token: AppInstance.instance.sessionId ?? "", limit: 0, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.stories ?? nil)")
                            self.storiesArray = (success?.stories) ?? []
                            
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                            
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
    private func selectSourceType(){
        let alert = UIAlertController(title: "Source", message: "", preferredStyle: .actionSheet)
        let text = UIAlertAction(title: "Text", style: .default) { action in
            log.verbose("worked")
            self.shouldRefreshStories = true
            
            let vc = R.storyboard.story.createStoryTextVC()
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        let image = UIAlertAction(title: "Image", style: .default) { action in
            self.cameraGallery()
        }
        let video = UIAlertAction(title: "Video", style: .default) { action in
            self.openVideoGallery()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(text)
        alert.addAction(image)
        alert.addAction(video)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
//        ActionSheetMultipleStringPicker.show(withTitle: NSLocalizedString("Source", comment: "Source"), rows: [
//            [NSLocalizedString("Image", comment: "Image"),NSLocalizedString("Video", comment: "Video")]
//
//            ], initialSelection: [0], doneBlock: {
//
//                picker, indexes, values in
//                let index =  (indexes![0] as? Int)!
//                if index == 0{
//
//                }else if  index == 1{
//
//
//
//                }
//
//                return
//        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
    }
    func openVideoGallery()
    {
        let picker = UIImagePickerController()
        self.delegate = self
        picker.delegate = self
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        picker.mediaTypes = ["public.movie"]
        
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    private func cameraGallery(){
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            self.delegate = self
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: NSLocalizedString("Gallery", comment: "Gallery"), style: .default) { (action) in
            self.delegate = self
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
extension StoriesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           
           let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10))
           view.backgroundColor = UIColor.clear
           
           let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 8))
           separatorView.backgroundColor = UIColor.systemGray
           
           let label = UILabel(frame: CGRect(x: 16, y: 8, width: view.frame.size.width, height: 48))
        label.textColor = UIColor.label
           label.font = UIFont(name: "Arial", size: 17)
           if section == 0{
              label.text = NSLocalizedString("Your Story", comment: "Your Story")

               
           }else if section == 1 {
             label.text = NSLocalizedString("Friends", comment: "Friends")
           }
           view.addSubview(label)
           return view
           
       }
       
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40
       }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            if self.storiesArray.isEmpty{
                return 1
            }else{
                return self.storiesArray.count ?? 0
            }
            
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.storySectionOneTableItem.identifier) as? StorySectionOneTableItem
                cell?.selectionStyle = .none
                
                cell?.bind(AppInstance.instance.userProfile?.avatar ?? "")
                return cell!
                
            default:
                return UITableViewCell()
            }
        case 1:
            if self.storiesArray.isEmpty{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.storySectionThreeTableItem.identifier) as? StorySectionThreeTableItem
                cell?.selectionStyle = .none
                
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.stories_TableCell.identifier) as? Stories_TableCell
                cell?.selectionStyle = .none
                
                let object = storiesArray[indexPath.row]
                cell?.usernameLabel.text = object.username ?? ""
                cell?.storyTextLabel.text = object.stories!.last?.storyDescription ?? ""
                let url = URL.init(string:object.avatar ?? "")
                cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
                cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
                cell?.selectionStyle = .none
                return cell!
                
            }
            
            
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return 80.0
            default: return 0
            }
        case 1:
            if self.storiesArray.isEmpty{
                return 400.0
            }else{
                return 80.0
            }
            
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.selectSourceType()
            default: break
            }
        case 1:
            if self.storiesArray.isEmpty{
                
            }else{
                DispatchQueue.main.async { [self] in
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
//                            interstitial.present(fromRootViewController: self)
//                                interstitial = CreateAd()
//                                AppInstance.instance.addCount = 0
                        }
                    }
                    AppInstance.instance.addCount = AppInstance.instance.addCount! + 1
                    self.shouldRefreshStories = true
                      
                       let vc = R.storyboard.story.contentVC()
                    vc!.refreshStories = {
                           //                self.viewModel?.refreshStories.accept(true)
                       }
                    vc!.modalPresentationStyle = .overFullScreen
                    vc!.pages = (self.storiesArray)
                    vc!.currentIndex = indexPath.row
                    self.present(vc!, animated: true, completion: nil)
                    
//                    let vc = R.storyboard.story.contentVC()
//                    vc!.modalPresentationStyle = .overFullScreen
//                    vc!.pages = self.storiesArray
//                    vc!.currentIndex = indexPath.row
//                    self.present(vc!, animated: true, completion: nil)
                }
            }
            
        default: break
        }
    }
}
extension StoriesVC:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("STORIES", comment: "STORIES"))
    }
    
}
extension  StoriesVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if  let image:UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            log.verbose("image = \(image ?? nil)")
            let imageData = image?.jpegData(compressionQuality: 0.1)
            self.delegate?.pickImage(image: image, videoData: nil, videoURL: nil, Status: true)
        }
        
        if let fileURL:URL? = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            if let url = fileURL {
                let videoData = try? Data(contentsOf: url)
                print(videoData)
                self.delegate?.pickImage(image: nil, videoData: videoData, videoURL: url, Status: false)
            }
            self.dismiss(animated: true, completion: nil)
            
        }
    }
}
extension StoriesVC:ImagePickerDelegate{
    
    
    func pickImage(image: UIImage?, videoData: Data?, videoURL: URL?,Status: Bool?) {
        if Status!{
            log.verbose("ImagePickerDelegate image = \(image)")
            let vc = R.storyboard.story.createStoryVC()
            vc?.status = Status ?? false
            vc!.pickedImage = image ?? nil
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            log.verbose("ImagePickerDelegate video = \(videoData)")
            let vc = R.storyboard.story.createStoryVC()
            vc?.status = Status ?? false
            vc?.videoUrl = videoURL
            vc?.videoData = videoData
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}

//extension StoriesVC:FBInterstitialAdDelegate{
//    
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
