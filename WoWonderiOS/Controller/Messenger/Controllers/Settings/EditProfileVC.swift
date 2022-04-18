
import UIKit
import SkyFloatingLabelTextField
import SDWebImage
import Async
import DropDown
import WoWonderTimelineSDK
class EditProfileVC: BaseVC {
    
    
    
    @IBOutlet weak var socialLinkLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var vkTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var youtubeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var instagramTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var twitterTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var googleTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var facebookTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var workspaceTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var websiteTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var locationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var genderTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var followingCount: UILabel!
    
    private let imagePickerController = UIImagePickerController()
    private var imageStatus:Bool? = false
    private var avatarImage:UIImage? = nil
    private var coverImageVar:UIImage? = nil
    private let moreDropdown = DropDown()
    
    var moreBtn:UIBarButtonItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.showUserData()
        self.customizeDropdown()
        
        
    }
    private func setupUI(){
        
        let profileImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(profileImageTapGestureRecognizer)
        
        let coverImageRapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coverImageTapped(tapGestureRecognizer:)))
        coverImage.isUserInteractionEnabled = true
        coverImage.addGestureRecognizer(coverImageRapGestureRecognizer)
        
        self.profileImage.cornerRadiusV = self.profileImage.frame.height / 2
        self.title = NSLocalizedString("Edit Profile", comment: "Edit Profile")
        self.navigationController?.navigationItem.title = NSLocalizedString("Edit Profile", comment: "Edit Profile")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.infoLabel.text = NSLocalizedString("User Info", comment: "User Info")
        self.socialLinkLabel.text = NSLocalizedString("Social Link", comment: "Social Link")
        self.followersLabel.text =  NSLocalizedString("Followers", comment: "Followers")
        self.followingLabel.text = NSLocalizedString("Following", comment: "Following")
        self.firstNameTextField.placeholder = NSLocalizedString("First Name", comment: "First Name")
        self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "Last Name")
        self.genderTextField.placeholder = NSLocalizedString("Gender", comment: "Gender")
        self.locationTextField.placeholder = NSLocalizedString("Location", comment: "Location")
        self.mobileTextField.placeholder = NSLocalizedString("Mobile", comment: "Mobile")
        self.websiteTextField.placeholder = NSLocalizedString("Website", comment: "Website")
        self.workspaceTextField.placeholder = NSLocalizedString("Workspace", comment: "Workspace")
        self.facebookTextField.placeholder = NSLocalizedString("Facebook", comment: "Facebook")
        self.googleTextField.placeholder = NSLocalizedString("Google", comment: "Google")
        self.twitterTextField.placeholder = NSLocalizedString("Twitter", comment: "Twitter")
        self.firstNameTextField.selectedTitle = NSLocalizedString("First Name", comment: "First Name")
        self.lastNameTextField.selectedTitle = NSLocalizedString("Last Name", comment: "Last Name")
        self.genderTextField.selectedTitle = NSLocalizedString("Gender", comment: "Gender")
        self.locationTextField.selectedTitle = NSLocalizedString("Location", comment: "Location")
        self.mobileTextField.selectedTitle = NSLocalizedString("Mobile", comment: "Mobile")
        self.websiteTextField.selectedTitle = NSLocalizedString("Website", comment: "Website")
        self.workspaceTextField.selectedTitle = NSLocalizedString("Workspace", comment: "Workspace")
        self.facebookTextField.selectedTitle = NSLocalizedString("Facebook", comment: "Facebook")
        self.googleTextField.selectedTitle = NSLocalizedString("Google", comment: "Google")
        self.twitterTextField.selectedTitle = NSLocalizedString("Twitter", comment: "Twitter")
        self.vkTextField.selectedTitle = NSLocalizedString("vk", comment: "vk")
        self.instagramTextField.selectedTitle = NSLocalizedString("instagram", comment: "instagram")
        self.youtubeTextField.selectedTitle = NSLocalizedString("Youtube", comment: "Youtube")
        let Save = UIBarButtonItem(title: NSLocalizedString("Save", comment: "Save"), style: .done, target: self, action: Selector("Save"))
        moreBtn = UIBarButtonItem(image: UIImage(named: "moreOption"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(MoreClicked))
        
        self.navigationItem.rightBarButtonItems = [moreBtn!,Save]
    }
    
    @objc func MoreClicked(){
        self.moreDropdown.show()
    }
    func customizeDropdown(){
        moreDropdown.dataSource = [NSLocalizedString("Copy link to profile", comment: "Copy link to profile"),NSLocalizedString("Share", comment: "Share")]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        moreDropdown.anchorView = self.moreBtn
        //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                UIPasteboard.general.string = "\(API.baseURL)/\(AppInstance.instance.userProfile?.username ?? "")"
                self.view.makeToast(NSLocalizedString("Copied to clipboard", comment: "Copied to clipboard"))
                
            }else{
                self.shareAcitvity(ShareLink: "\(API.baseURL)/\(AppInstance.instance.userProfile?.username ?? "")")
                
            }
            print("Index = \(index)")
        }
        
    }
    func shareAcitvity(ShareLink:String){
        let myWebsite = NSURL(string:ShareLink)
        let shareAll = [ myWebsite]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .alert)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            self.imageStatus = false
            self.imagePickerController.delegate = self
            
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: NSLocalizedString("Gallery", comment: "Gallery"), style: .default) { (action) in
            self.imageStatus = false
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
    @objc func coverImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .alert)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            self.imageStatus = true
            self.imagePickerController.delegate = self
            
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: NSLocalizedString("Gallery", comment: "Gallery"), style: .default) { (action) in
            self.imageStatus = true
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
    private func updateUserProfile(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let firstname = self.firstNameTextField.text ?? ""
        let lastname = self.lastNameTextField.text ?? ""
        let gender = self.genderTextField.text  ?? ""
        let location = self.locationTextField.text ?? ""
        let mobile = self.mobileTextField.text ?? ""
        let website = self.websiteTextField.text ?? ""
        let workspace = self.workspaceTextField.text ?? ""
        let facebook = self.facebookTextField.text ?? ""
        let google = self.googleTextField.text ?? ""
        let instagram = self.instagramTextField.text ?? ""
        let VK = self.vkTextField.text ?? ""
        let twitter = self.twitterTextField.text ?? ""
        let youtube = self.youtubeTextField.text ?? ""
        Async.background({
            if self.avatarImage == nil && self.coverImageVar == nil{
                SettingsManager.instance.updateUserProfile(session_Token:sessionToken , firstname: firstname, lastname: lastname, gender: gender, location: location, phone: mobile, website: website, school: workspace, facebook: facebook, google: google, twitter: twitter, youtube: youtube, VK: VK, instagram: instagram) { (success, sessionError, serverError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                AppInstance.instance.fetchUserProfile(pass: nil)
                            }
                            
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("sessionError = \(sessionError?.errors?.errorText)")
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            }
                            
                        })
                        
                        
                    }else if serverError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("serverError = \(serverError?.errors?.errorText ?? "")")
                                self.view.makeToast(serverError?.errors?.errorText ?? "")
                            }
                            
                        })
                        
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.error("error = \(error?.localizedDescription)")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                            
                        })
                        
                    }
                    
                }
                
            }else{
                
                if self.avatarImage != nil && self.coverImageVar == nil{
                    let avatarData = self.avatarImage?.jpegData(compressionQuality: 0.2)
                    SettingsManager.instance.updateUserDataWithCandA(session_Token:sessionToken , firstname: firstname, lastname: lastname, gender: gender, location: location, phone: mobile, website: website, school: workspace, facebook: facebook, google: google, twitter: twitter, youtube: youtube, VK: VK, instagram: instagram, type: "avatar", avatar_data: avatarData, cover_data: nil) { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("success = \(success?.message ?? "")")
                                    self.view.makeToast(success?.message ?? "")
                                    AppInstance.instance.fetchUserProfile(pass: nil)
                                }
                                
                            })
                        }else if sessionError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("sessionError = \(sessionError?.errors?.errorText)")
                                    self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                }
                                
                            })
                            
                            
                        }else if serverError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("serverError = \(serverError?.errors?.errorText ?? "")")
                                    self.view.makeToast(serverError?.errors?.errorText ?? "")
                                }
                                
                            })
                            
                        }else {
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("error = \(error?.localizedDescription)")
                                    self.view.makeToast(error?.localizedDescription ?? "")
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }else if self.avatarImage == nil && self.coverImageVar != nil{
                    let coverImageData = self.coverImageVar?.jpegData(compressionQuality: 0.2)
                    SettingsManager.instance.updateUserDataWithCandA(session_Token:sessionToken , firstname: firstname, lastname: lastname, gender: gender, location: location, phone: mobile, website: website, school: workspace, facebook: facebook, google: google, twitter: twitter, youtube: youtube, VK: VK, instagram: instagram, type: "cover", avatar_data: nil, cover_data: coverImageData) { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("success = \(success?.message ?? "")")
                                    self.view.makeToast(success?.message ?? "")
                                   AppInstance.instance.fetchUserProfile(pass: nil)
                                }
                                
                            })
                        }else if sessionError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("sessionError = \(sessionError?.errors?.errorText)")
                                    self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                }
                                
                            })
                            
                            
                        }else if serverError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("serverError = \(serverError?.errors?.errorText ?? "")")
                                    self.view.makeToast(serverError?.errors?.errorText ?? "")
                                }
                                
                            })
                            
                        }else {
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("error = \(error?.localizedDescription)")
                                    self.view.makeToast(error?.localizedDescription ?? "")
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }else{
                    let avatarData = self.avatarImage?.jpegData(compressionQuality: 0.2)
                    let coverData = self.coverImageVar?.jpegData(compressionQuality: 0.2)
                    
                    SettingsManager.instance.updateUserDataWithCandA(session_Token:sessionToken , firstname: firstname, lastname: lastname, gender: gender, location: location, phone: mobile, website: website, school: workspace, facebook: facebook, google: google, twitter: twitter, youtube: youtube, VK: VK, instagram: instagram, type: "all", avatar_data: avatarData, cover_data: coverData) { (success, sessionError, serverError, error) in
                        if success != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.debug("success = \(success?.message ?? "")")
                                    self.view.makeToast(success?.message ?? "")
                                    AppInstance.instance.fetchUserProfile(pass: nil)
                                }
                                
                            })
                        }else if sessionError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("sessionError = \(sessionError?.errors?.errorText)")
                                    self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                }
                                
                            })
                            
                            
                        }else if serverError != nil{
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("serverError = \(serverError?.errors?.errorText ?? "")")
                                    self.view.makeToast(serverError?.errors?.errorText ?? "")
                                }
                                
                            })
                            
                        }else {
                            Async.main({
                                self.dismissProgressDialog {
                                    log.error("error = \(error?.localizedDescription)")
                                    self.view.makeToast(error?.localizedDescription ?? "")
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
    }
    
    private func getUserData(user_ID: String){
        if Connectivity.isConnectedToNetwork(){
            GetUserDataManager.instance.getUserData(user_id: user_ID, session_Token: AppInstance.instance.sessionId ?? "", fetch_type: API.Params.User_data) { (success, sessionError, serverError, error) in
                if success != nil {
                    Async.main({
                        self.dismissProgressDialog {
                            self.followersCount.text = success?.userData?.details?.followersCount
                            self.followingCount.text = success?.userData?.details?.followingCount
                            
                        }
                    })
                }
                else if sessionError != nil{
                    Async.main({
                        
                        self.dismissProgressDialog {
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            self.view.makeToast(sessionError?.errors?.errorText)
                        }
                    })
                }
                else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.error("serverError = \(serverError?.errors?.errorText)")
                            self.view.makeToast(serverError?.errors?.errorText)
                        }
                    })
                }
                else {
                    Async.main({
                        self.dismissProgressDialog {
                            log.error("error = \(error?.localizedDescription)")
                            self.view.makeToast(error?.localizedDescription)
                        }
                    })
                }
            }
        }
        else{
            self.dismissProgressDialog {
                //                let securityAlertVC = R.storyboard.main.securityPopupVC()
                //                securityAlertVC?.titleText  = NSLocalizedString("Internet Error", comment: "Internet Error")
                //                securityAlertVC?.errorText = InterNetError ?? ""
                //                self.present(securityAlertVC!, animated: true, completion: nil)
                //                log.error("internetError - \(InterNetError)")
                self.view.makeToast(NSLocalizedString("Internet Error", comment: "Internet Error"))
            }
        }
    }
    
    
    private func showUserData(){
        self.fullNameLabel.text = AppInstance.instance.userProfile?.name ?? ""
        self.usernameLabel.text = "@\(AppInstance.instance.userProfile?.username ?? "")"
        self.firstNameTextField.text = AppInstance.instance.userProfile?.firstName ?? ""
        self.lastNameTextField.text = AppInstance.instance.userProfile?.lastName ?? ""
        self.genderTextField.text =  AppInstance.instance.userProfile?.gender ?? ""
        self.workspaceTextField.text = AppInstance.instance.userProfile?.school ?? ""
        self.websiteTextField.text = AppInstance.instance.userProfile?.website ?? ""
        self.mobileTextField.text = AppInstance.instance.userProfile?.phoneNumber ?? ""
        self.facebookTextField.text = AppInstance.instance.userProfile?.facebook ?? ""
        self.googleTextField.text = AppInstance.instance.userProfile?.google ?? ""
        self.twitterTextField.text = AppInstance.instance.userProfile?.twitter ?? ""
        self.vkTextField.text = AppInstance.instance.userProfile?.vk ?? ""
        self.twitterTextField.text = AppInstance.instance.userProfile?.twitter ?? ""
        self.youtubeTextField.text  = AppInstance.instance.userProfile?.youtube ?? ""
        self.locationTextField.text = AppInstance.instance.userProfile?.address ?? ""
        self.followersCount.text = AppInstance.instance.userProfile?.details?.followersCount
        self.followingCount.text = AppInstance.instance.userProfile?.details?.followingCount
        
        let profileImageURL = URL.init(string:AppInstance.instance.userProfile?.avatar ?? "")
        let coverImageURL = URL.init(string:AppInstance.instance.userProfile?.cover ?? "")
        profileImage.sd_setImage(with: profileImageURL ?? nil , placeholderImage:R.image.ic_profileimage())
        coverImage.sd_setImage(with: coverImageURL ?? nil , placeholderImage:R.image.ic_profileimage())
        
        
    }
    @objc func Save(){
        log.verbose("savePressed!!")
        self.updateUserProfile()
    }
    
}
extension  EditProfileVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if imageStatus!{
            self.coverImage.image = image
            self.coverImageVar = image ?? nil
            
        }else{
            self.profileImage.image = image
            self.avatarImage  = image ?? nil
        }
        self.dismiss(animated: true, completion: nil)
    }
}
