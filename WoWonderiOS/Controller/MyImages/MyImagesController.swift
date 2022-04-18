

import UIKit
import Kingfisher
import WoWonderTimelineSDK


class MyImagesController: UIViewController,deleteImageDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noPhotoView: UIView!
    @IBOutlet weak var noImage: UIImageView!
    @IBOutlet weak var noImageLbl: UILabel!
    @IBOutlet weak var textLabl: UILabel!
    var selectedIndex = 0
    
    var imagesArray = [[String:Any]]()
    let status = Reach().connectionStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.activityIndicator.color = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.noImage.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.noImageLbl.text = NSLocalizedString("No Photos !!", comment: "No Photos !!")
        self.textLabl.text = NSLocalizedString("Start uploding your own photos", comment: "Start uploding your own photos")
        
self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.largeTitleDisplayMode = .never
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
              navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = NSLocalizedString("My Images", comment: "My Images")
        self.activityIndicator.startAnimating()
        self.getImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// Network Connectivity
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print("Status",status)
        }
    }

    func deleteImage() {
        self.imagesArray.remove(at: self.selectedIndex)
        self.collectionView.reloadData()
    }
    
    
    private func getImages() {
        switch status {
        case .unknown, .offline:
            showAlert(title: "", message: "Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                Get_User_ImageManager.sharedInstance.getUserImages(user_id: UserData.getUSER_ID()!, param: "photos") { (success, authError, error) in
                    if success != nil {
                        for i in success!.data{
                            if i["postFile"] as? String != "" {
                                self.imagesArray.append(i)
                            }
                        }
                        if self.imagesArray.count != 0{
                            self.collectionView.isHidden = false
                        }
                        else{
                            self.collectionView.isHidden = true
                        }
                        print(self.imagesArray)
                        self.activityIndicator.stopAnimating()
                        self.collectionView.reloadData()
                    }
                    else if authError != nil {
                        self.showAlert(title: "", message: (authError?.errors.errorText)!)
                    }
                   else if error != nil {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
}

extension MyImagesController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! MyImagesCell
        let index = self.imagesArray[indexPath.row]
        if let image = index["postFile_full"] as? String{
//            let baseUrl = APIClient.baseURl
//           let Url = "\("https://wowonder.fra1.digitaloceanspaces.com/")\(image)"
//            let Url = "\(baseUrl)\(image)"

           let url = URL(string: image)
            cell.myImage.kf.indicatorType = .activity
           cell.myImage.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.imagesArray[indexPath.row]
        self.selectedIndex = indexPath.row
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowImageVC") as! ShowImageController1
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        if let imageUrl = index["postFile"] as? String{
            let Url = "\("https://wowonder.fra1.digitaloceanspaces.com/")\(imageUrl)"
            vc.imageUrl = Url
        }
        vc.myImages = "1"
        vc.delegate = self
        vc.posts.append(index)
        self.present(vc, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.size.width
        let widht = (collectionWidth / 2) - 10
        let height = (self.view.frame.size.height / 4) - 10
        return CGSize(width: widht , height: widht)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
