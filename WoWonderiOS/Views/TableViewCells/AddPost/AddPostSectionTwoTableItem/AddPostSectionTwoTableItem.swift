import WoWonderTimelineSDK
import UIKit

class AddPostSectionTwoTableItem: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var addressBtn: UIButton!
    var vc:AddPostVC?
    var imageString = [String]()
    var idString = [String]()
    var filter = [String]()
    var filterIDs = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.textView.delegate = self
        self.addressBtn.isUserInteractionEnabled = false
        let siteSetting = AppInstance.instance.siteSettings
        if let postColor = siteSetting["post_colors"] as? [String:[String:Any]]{
            for (key,value) in postColor{
                print("Key = \(key) , value = \(value)")
                if let values = value as? [String:Any] {
                    if let image = values["image"] as? String{
                        if image == ""{
                             
                         }else{
                             self.imageString.append(image)
                             self.idString.append(key)
                         }
                         print("Image String = \(imageString.count)")
                         idString.forEach { (it) in
                             print("images Link = \(it)")
                         }
                    }
                }
            }
        }
        self.textView.text = NSLocalizedString("What's going on?#Hashtag..@Mention", comment: "What's going on?#Hashtag..@Mention")
        self.filter.append("12")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AddPostSectionTwoCollectionItem", bundle: nil), forCellWithReuseIdentifier: "AddPostSectionTwoCollectionItem")
        
       
    }
    
    
    func showLogs(){
        let alert = UIAlertController(title: "", message: NSLocalizedString("Location", comment: ""), preferredStyle: .actionSheet)
        
        alert.setValue(NSAttributedString(string: alert.message ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: NSLocalizedString("Remove Location", comment: "Remove Location"), style: .default, handler: { (_) in
            self.addressLabel.text = nil
            self.addressBtn.isUserInteractionEnabled = false
        }))

        alert.addAction(UIAlertAction(title: NSLocalizedString("Change Location", comment: "Change Location"), style: .default, handler: { (_) in
            let Stroyboard =  UIStoryboard(name: "MoreSection2", bundle: nil)
            let vc = Stroyboard.instantiateViewController(withIdentifier: "MapController") as! MapController
            vc.delegate = self.vc
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.vc?.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.vc?.view
            popoverController.sourceRect = CGRect(x: self.vc!.view.bounds.midX, y: self.vc!.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.vc?.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    @IBAction func Address(_ sender: Any) {
        self.showLogs()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (self.textView.text == NSLocalizedString("What's going on?#Hashtag..@Mention", comment: "What's going on?#Hashtag..@Mention")){
            self.textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (self.textView.text.isEmpty == true) || (self.textView.text == "") || (self.textView.text == " "){
            self.textView.text = NSLocalizedString("What's going on?#Hashtag..@Mention", comment: "What's going on?#Hashtag..@Mention")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func bind(text:String){
        if (text == "") || (text == nil) || (text == " "){
            self.textView.text = NSLocalizedString("What's going on?#Hashtag..@Mention", comment: "What's going on?#Hashtag..@Mention")
            self.collectionView.isHidden = true
        }
        else{
        self.textView.text = text
        self.collectionView.isHidden = true
        }
//        self.collectionView.reloadData()
    }
}
extension AddPostSectionTwoTableItem:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageString.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostSectionTwoCollectionItem", for: indexPath) as? AddPostSectionTwoCollectionItem
        let object =   self.imageString[indexPath.row]
                         cell?.bind(object ?? "")
//        if indexPath.row == (imageString.count - 1)
//        {
//            self.backGroundImage.image = nil
//            cell?.profileImage.backgroundColor = .white
//        }else{
//            let object =   self.imageString[indexPath.row]
//                  cell?.bind(object ?? "")
//        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.row == (imageString.count - 1){
        self.vc?.PostColor = "0"
            
            AppInstance.instance.isBackGroundSelected = false
            if AppInstance.instance.isBackGroundSelected{
                       self.textView.textColor = .white
                       
                   }else{
                        self.textView.textColor = .black
                   }
     
        }else{
            let url = URL(string: self.imageString[indexPath.row]  ?? "")
            self.vc?.PostColor = self.idString[indexPath.row] ?? ""
                     self.backGroundImage.kf.setImage(with: url)
                   AppInstance.instance.isBackGroundSelected = true
            if AppInstance.instance.isBackGroundSelected{
                       self.textView.textColor = .white
                       
                   }else{
                        self.textView.textColor = .black
                   }
        }
        self.vc?.tableView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: collectionView.frame.width , height: collectionView.frame.height )
       }
       
       func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       }
       
       func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
       
       func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0
       }
    

}
