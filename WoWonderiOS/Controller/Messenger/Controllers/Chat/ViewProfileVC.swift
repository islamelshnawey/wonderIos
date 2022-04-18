
import UIKit
import Async
import WoWonderTimelineSDK
class ViewProfileVC: BaseVC {
    
    @IBOutlet weak var flLabel: UILabel!
    @IBOutlet weak var fLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var profileId:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showUserData()
        self.setupUI()
      
    }
    
    
    @IBAction func followingPressed(_ sender: Any) {
        followUnfollow()
    }
    
    private func setupUI(){
        self.fLabel.text = NSLocalizedString("Followers", comment: "")
        self.flLabel.text = NSLocalizedString("Following", comment: "")
        self.followingBtn.cornerRadiusV = self.followingBtn.frame.height / 2
        self.profileImage.cornerRadiusV = self.profileImage.frame.height / 2
    }
    private func showUserData(){
//        if appDelegate.isInternetConnected{
//          
//                let sessionId = AppInstance.instance.sessionId
//                Async.background({
//                    GetUserDataManager.instance.getUserData(user_id: self.profileId ?? "" , session_Token: sessionId ?? "", fetch_type: API.Params.User_data) { (success, sessionError, serverError, error) in
//                        if success != nil{
//                            Async.main({
//                                log.debug("success = \(success?.userData?.school)")
//                                
//                                if (success?.userData?.username!.isEmpty)!{
//                                     self.fullnameLabel.text = "Empty"
//                                   
//                                    
//                                }else{
//                                    self.fullnameLabel.text = success?.userData?.username ?? "Empty"
//                                  
//                                }
//                                if (success?.userData?.name!.isEmpty)!{
//                                    self.nameLabel.text = "Empty"
//                                    
//                                }else{
//                                     self.nameLabel.text = success?.userData?.name ?? "Empty"
//                                }
//                                if (success?.userData?.username!.isEmpty)!{
//                                    self.usernameLabel.text = "Empty"
//                                   
//                                }else{
//                                     self.usernameLabel.text = "@\(success?.userData?.username ?? "Empty")"
//                                   
//                                }
//                                if (success?.userData?.gender!.isEmpty)!{
//                                    
//                                    self.genderLabel.text = "Empty"
//                                    
//                                }else{
//                                    self.genderLabel.text =  success?.userData?.gender ?? "Empty"
//                                }
//                                if (success?.userData?.school!.isEmpty)!{
//                                     self.addressLabel.text = "Empty"
//                                    
//                                   
//                                    
//                                }else{
//                                   self.addressLabel.text = success?.userData?.school ?? "Empty"
//                                }
//                                if (success?.userData?.website!.isEmpty)!{
//                                   
//                                   
//                                     self.websiteLabel.text = "Empty"
//                                }else{
//                                    self.websiteLabel.text = success?.userData?.website ?? "Empty"
//                                }
//                                if (success?.userData?.phoneNumber!.isEmpty)!{
//                                   
//                                    
//                                      self.phoneLabel.text = "Empty"
//                                }else{
//                                    self.phoneLabel.text = success?.userData?.phoneNumber ?? "Empty"
//                                }
//                                if (success?.userData?.details?.followersCount!.isEmpty)!{
//                                      self.followersCountLabel.text = "N/A"
//                                   
//                                }else{
//                                     self.followersCountLabel.text = success?.userData?.details?.followersCount ?? "N/A"
//                                 
//                                }
//                                if (success?.userData?.details?.followingCount!.isEmpty)!{
//                                     self.followingCountLabel.text = "N/A"
//                                }else{
//                                   self.followingCountLabel.text = success?.userData?.details?.followingCount ?? "N/A"
//                                }
//                               
//                                
//                                let profileImageURL = URL.init(string:success?.userData?.avatar ?? "")
//                                let coverImageURL = URL.init(string:success?.userData?.cover ?? "")
//                                self.profileImage.sd_setImage(with: profileImageURL ?? nil , placeholderImage:R.image.ic_profileimage())
//                                self.coverImage.sd_setImage(with: coverImageURL ?? nil)
//                                if success?.userData?.isFollowingMe == 0 {
//                                    self.followingBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "#444444")
//                                    self.followingBtn.setImage(R.image.ic_add(), for: .normal)
//                                    
//                                }else{
//                                    self.followingBtn.backgroundColor = .white
//                                    self.followingBtn.setImage(R.image.ic_checkblack(), for: .normal)
//                                    
//                                }
//                                
//                            })
//                        }else if sessionError != nil{
//                            Async.main({
//                            
//                                log.error("sessionError = \(sessionError?.errors?.errorText)")
//                                self.view.makeToast(sessionError?.errors?.errorText)
//                            })
//                            
//                        }else if serverError != nil{
//                            Async.main({
//                              
//                                log.error("serverError = \(serverError?.errors?.errorText)")
//                                self.view.makeToast(serverError?.errors?.errorText)
//                                
//                            })
//                            
//                        }else {
//                            Async.main({
//                                
//                                log.error("error = \(error?.localizedDescription)")
//                                self.view.makeToast(error?.localizedDescription)
//                                
//                            })
//                        }
//                    }
//                })
//            
//           
//        }else {
//            self.view.makeToast(InterNetError)
//            
//        }

}
    private func followUnfollow(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let userId = AppInstance.instance.userId ?? ""
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            FollowingManager.instance.followUnfollow(user_id: self.profileId ?? "", session_Token: sessionToken, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.followStatus ?? "")")
                            self.view.makeToast(success?.followStatus ?? "")
                            if success?.followStatus  ?? "" == "followed"{
                                self.view.makeToast(NSLocalizedString("You have followed the user successfully", comment: "You have followed the user successfully"))
                                self.followingBtn.backgroundColor = .white
                                self.followingBtn.setImage(R.image.ic_checkblack(), for: .normal)
                                
                            }else{
                                self.followingBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "#444444")
                                self.followingBtn.setImage(R.image.ic_add(), for: .normal)
                                self.view.makeToast(NSLocalizedString("The user has been unfollowed", comment: "The user has been unfollowed"))
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
