

import UIKit
import Async
class RequestGroupOne_TableCell: UITableViewCell {
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    var groupID:Int? = 0
    var vc:GroupRequestVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rightBtn.backgroundColor = .ButtonColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func bind(_ object: GroupRequestModel.GroupChatRequest){
        self.groupID = object.groupID ?? 0
        self.groupNameLabel.text = object.groupTab?.groupName ?? ""
        let url = URL.init(string:object.groupTab?.avatar ?? "")
        self.groupImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
    }
    
    @IBAction func rejectPressed(_ sender: Any) {
        self.acceptRejectGroupRequest(type: "reject")
    }
    @IBAction func acceptPressed(_ sender: Any) {
        self.acceptRejectGroupRequest(type: "accept")

    }
    private func acceptRejectGroupRequest(type:String){
        self.vc?.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let groupID = self.groupID ?? 0
        Async.background({
            GroupRequestManager.instance.accceptGroupRequest(session_Token: sessionToken, type: type, groupID: groupID) { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.vc!.dismissProgressDialog {
                            self.vc?.fetchGroupRequest()
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.vc!.dismissProgressDialog {
                            self.vc!.view.makeToast(sessionError?.errors?.errorText)
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                        }
                    })
                }else if serverError != nil{
                    Async.main({
                        self.vc!.dismissProgressDialog {
                            self.vc!.view.makeToast(serverError?.errors?.errorText)
                            log.error("serverError = \(serverError?.errors?.errorText)")
                        }
                        
                    })
                    
                }else {
                    Async.main({
                        self.vc!.dismissProgressDialog {
                            self.vc!.view.makeToast(error?.localizedDescription)
                            log.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
            }
        })
    }
}
