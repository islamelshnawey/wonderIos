//
//  SearchPostController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 2/8/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class SearchPostController: UIViewController,UISearchBarDelegate{
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var sadLabel: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var noView: UIView!
    
    let status = Reach().connectionStatus()
    var posts = [[String:Any]]()
    
    var type = ""
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.activityIndicator.color = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = NSLocalizedString("Post", comment: "Post")
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        self.activityIndicator.stopAnimating()
        self.searchBar.delegate = self
        self.tableView.register(UINib(nibName: "PostLiveCell", bundle: nil), forCellReuseIdentifier: "LiveCell")
        SetUpcells.setupCells(tableView: self.tableView)
        self.tableView.separatorStyle = .none
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.navView.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.SetUpSearchField()
        self.searchBar.tintColor = .white
        self.searchBar.backgroundColor = .clear
        self.searchBar.layer.borderColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor).cgColor
        self.searchBar.backgroundImage = UIImage()
        self.tableView.tableFooterView = UIView()
        self.searchImage.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.sadLabel.text = NSLocalizedString("Sad no result!", comment: "Sad no result!")
        self.textLbl.text = NSLocalizedString("We cannot find the keyword  you are searching from maybe a little spelling mistake ?", comment: "We cannot find the keyword  you are searching from maybe a little spelling mistake ?")
        self.noView.isHidden = false
        self.tableView.isHidden = true
    }
    ///Network Connectivity.
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (self.searchBar.text?.isEmpty == true) || (self.searchBar.text == " "){
            self.view.makeToast("Please, enter search text")
        }
        else{
        self.activityIndicator.startAnimating()
        self.noView.isHidden = true
        self.tableView.isHidden = false
        self.searchBar.resignFirstResponder()
        self.searchPost(text: self.searchBar.text!)
        }
    }
    
    
    private func searchPost(text:String){
        switch status {
        case .unknown, .offline:
            self.activityIndicator.stopAnimating()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
            SearchPostManager.sharedInstance.searchPost(type: self.type, id: self.id, text: self.searchBar.searchTextField.text!) { (success, authError, error) in
                if (success != nil){
                    for i in success!.data{
                        self.posts.append(i)
                    }
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                else if (authError != nil){
                    self.activityIndicator.stopAnimating()
                    self.view.makeToast(authError?.errors?.errorText ?? "")
                }
                else if (error != nil) {
                    self.activityIndicator.stopAnimating()
                    self.view.makeToast(error?.localizedDescription)
                }
            }
            }
        }
        
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchPostController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1{
            return 1
        }
        else if section == 2{
            return 1
        }
        else if section == 3{
            return 1
        }
        else if section == 4{
            return 1
        }
        else if section == 5{
            return 1
        }
        else {
            return self.posts.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = UITableViewCell()
             self.tableView.rowHeight = 0
             return cell
        }
        else if (indexPath.section == 1){
            let cell = UITableViewCell()
             self.tableView.rowHeight = 0
             return cell
        }
        else if (indexPath.section == 2){
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
            return cell
        }
        else if (indexPath.section == 3){
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
            return cell
        }
        else if (indexPath.section == 4){
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
            return cell
        }
        else if (indexPath.section == 5){
            let cell = UITableViewCell()
            self.tableView.rowHeight = 0
            return cell
        }
        else {
            let index = self.posts[indexPath.row]
        var cell = UITableViewCell()
        var shared_info : [String:Any]? = nil
        var fundDonation: [String:Any]? = nil
        let postfile = index["postFile"] as? String ?? ""
              let postFile_full = index["postFile_full"] as? String ?? ""
            
        let postLink = index["postLink"] as? String ?? ""
        let postYoutube = index["postYoutube"] as? String ?? ""
        let blog = index["blog_id"] as? String ?? "0"
        let group = index["group_recipient_exists"] as? Bool ??  false
        let product = index["product_id"] as? String ?? "0"
        let event = index["page_event_id"] as? String ?? "0"
        let postSticker = index["postSticker"] as? String ?? ""
        let colorId = index["color_id"] as? String ?? "0"
        let multi_image = index["multi_image"] as? String ?? "0"
        let photoAlbum = index["album_name"] as? String ?? ""
        let postOptions = index["poll_id"] as? String ?? "0"
        let postRecord = index["postRecord"] as? String ?? "0"
        if let sharedInfo = index["shared_info"] as? [String:Any] {
            shared_info = sharedInfo
        }
        if let fund = index["fund_data"] as? [String:Any]{
            fundDonation = fund
        }
        if (shared_info != nil){
            cell = GetPostShare.sharedInstance.getsharePost(targetController: self, tableView: self.tableView, indexpath: indexPath, postFile: postfile, array: self.posts)
        }
        
       else if (postfile != "")  {
            let url = URL(string: postfile)
            let urlExtension: String? = url?.pathExtension
            if (urlExtension == "jpg" || urlExtension == "png" || urlExtension == "jpeg" || urlExtension == "JPG" || urlExtension == "PNG"){
                cell = GetPostWithImage.sharedInstance.getPostImage(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.posts, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
                
            else if(urlExtension == "wav" ||  urlExtension == "mp3" || urlExtension == "MP3"){
                cell = GetPostMp3.sharedInstance.getMP3(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array: self.posts,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
            else if (urlExtension == "pdf") {
                cell = GetPostPDF.sharedInstance.getPostPDF(targetControler: self, tableView: tableView, indexpath: indexPath, postfile: postfile, array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
                
            }
                
            else {
                cell = GetPostVideo.sharedInstance.getVideo(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postFile_full, array: self.posts, url: url!, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            }
        }
        else if (postLink != "") {
            cell = GetPostWithLink.sharedInstance.getPostLink(targetController: self, tableView: tableView, indexpath: indexPath, postLink: postLink, array: self.posts,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
            
        else if (postYoutube != "") {
            cell = GetPostYoutube.sharedInstance.getPostYoutub(targetController: self, tableView: tableView, indexpath: indexPath, postLink: postYoutube, array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            
        }
        else if (blog != "0") {
            cell = GetPostBlog.sharedInstance.GetBlog(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
            
        else if (group != false){
            cell = GetPostGroup.sharedInstance.GetGroupRecipient(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
            
        else if (product != "0") {
            cell = GetPostProduct.sharedInstance.GetProduct(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.posts,stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
        else if (event != "0") {
            cell = GetPostEvent.sharedInstance.getEvent(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array:  self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            
        }
        else if (postSticker != "") {
            cell = GetPostSticker.sharedInstance.getPostSticker(targetController: self, tableView: tableView, indexpath: indexPath, postFile: postfile, array:self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            
        }
            
        else if (colorId != "0"){
            cell = GetPostWithBg_Image.sharedInstance.postWithBg_Image(targetController: self, tableView: tableView, indexpath: indexPath, array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
            
        else if (multi_image != "0") {
            cell = GetPostMultiImage.sharedInstance.getMultiImage(targetController: self, tableView: tableView, indexpath: indexPath, array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
            
        }
            
        else if photoAlbum != "" {
            cell = getPhotoAlbum.sharedInstance.getPhoto_Album(targetController: self, tableView: tableView, indexpath: indexPath, array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
            
        else if postOptions != "0" {
            cell = GetPostOptions.sharedInstance.getPostOptions(targertController: self, tableView: tableView, indexpath: indexPath, array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
            
        else if postRecord != ""{
            cell = GetPostRecord.sharedInstance.getPostRecord(targetController: self, tableView: tableView, indexpath: indexPath, array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
            
        else if fundDonation != nil{
            cell = GetDonationPost.sharedInstance.getDonationpost(targetController: self, tableView: tableView, indexpath: indexPath, array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
        else {
            cell = GetNormalPost.sharedInstance.getPostText(targetController: self, tableView: tableView, indexpath: indexPath, postFile: "", array: self.posts, stackViewHeight: 50.0, viewHeight: 22.0, isHidden: false, viewColor: .lightGray)
        }
        return cell
        }
    }
    
    
}
