
import UIKit
import Async
import WoWonderTimelineSDK

class BlockedUsersPopupVC: BaseVC {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var unblockedBtn: UIButton!
    var blockedUserObject:GetBlockedUsersModel.BlockedUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.unblockedBtn.setTitleColor(.mainColor, for: .normal)
        self.unblockedBtn.setTitle(NSLocalizedString("Unblocked", comment: "Unblocked"), for: .normal)
       
    }
    
    
    @IBAction func unBlockPressed(_ sender: Any) {
        self.unBLockUser()
    }
    
    private func setupUI(){
        let name = blockedUserObject?.name ?? ""
        let usermame = blockedUserObject?.username ?? ""
        self.nameLabel.text = name
        self.usernameLabel.text = usermame
        let url = URL.init(string:blockedUserObject!.avatar ?? "")
        profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        self.profileImage.cornerRadiusV = self.profileImage.frame.height / 2
        
        let dismissView = UITapGestureRecognizer(target: self, action: #selector(dismissView(sender:)))
        self.view.addGestureRecognizer(dismissView)
        log.verbose("userId = \(blockedUserObject?.userID ?? "")")
    }
    @objc func dismissView(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
        
        
    }
   
    private func unBLockUser(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let blockToUserId = blockedUserObject?.userID ?? ""
        
        Async.background({
            BlockUsersManager1.instanc.blockUnblockUser(session_Token: sessionToken, blockTo_userId: blockToUserId, block_Action: "un-block", completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.blockStatus ?? "")")
                            self.view.makeToast("\(self.blockedUserObject?.username ?? "") has been unblocked!!")
                            self.dismiss(animated: true, completion: nil)
                            
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
