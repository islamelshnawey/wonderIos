

import UIKit
import Async
import WoWonderTimelineSDK

class getFriendVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var followingsArray = [FollowingModel.Following]()
    private  var refreshControl = UIRefreshControl()
    var messageString:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchData()
        
    }
    func setupUI(){
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register( R.nib.friendsTableItem(), forCellReuseIdentifier: R.reuseIdentifier.friendsTableItem.identifier)
        
        
    }
    @objc func refresh(sender:AnyObject) {
        self.followingsArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
    }
    
    private func fetchData(){
        self.followingsArray.removeAll()
        self.tableView.reloadData()
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        Async.background({
            FollowingManager.instance.getFollowings(user_id: AppInstance.instance.userId ?? "", session_Token: AppInstance.instance.sessionId ?? "", fetch_type: "following") { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.following ?? nil)")
                            self.followingsArray = success?.following ?? []
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
            }
            
        })
        
    }
    
    private func sendMessage(userID:String){
           let messageHashId = Int(arc4random_uniform(UInt32(100000)))
           let messageText = messageString ?? ""
           let recipientId = userID ?? ""
           let sessionID = AppInstance.instance.sessionId ?? ""
           
           Async.background({
            ChatManager.instance.sendMessage(message_hash_id: messageHashId, receipent_id: recipientId, text: messageText, session_Token: sessionID, lat: 0, long: 0, replyMessageID: "0", completionBlock: { (success, sessionError, serverError, error) in
                   if success != nil{
                       Async.main({
                           self.dismissProgressDialog {
                            self.navigationController?.popViewController(animated: true)
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
extension getFriendVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followingsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.friendsTableItem.identifier) as? FriendsTableItem
        let object = followingsArray[indexPath.row]
        cell?.selectionStyle = .none
        cell?.usernameLabel.text = object.username ?? ""
        cell?.timeLabel.text = ControlSettings.WoWonderText
        let url = URL.init(string:object.avatar ?? "")
        cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendMessage(userID: followingsArray[indexPath.row].userID ?? "")
    }
}
