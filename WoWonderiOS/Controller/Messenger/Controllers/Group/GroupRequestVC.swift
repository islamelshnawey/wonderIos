

import UIKit
import XLPagerTabStrip
import SwiftEventBus
import WoWonderTimelineSDK
import Async
class GroupRequestVC: BaseVC {
    
    @IBOutlet weak var noGrouplabel: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRequestImage: UIImageView!
    private  var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var noRequestLabel: UILabel!
    var groupsArray = [GroupRequestModel.GroupChatRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchGroupRequest()
    }
    
    func setupUI(){
        self.title = NSLocalizedString("Group Request", comment: "Group Request")
        self.noRequestLabel.text = NSLocalizedString("", comment: "")
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.requestGroupOneTableCell(), forCellReuseIdentifier: R.reuseIdentifier.requestGroupOne_TableCell.identifier)
        self.tableView.separatorStyle = .none
        
    }
     func fetchGroupRequest(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        Async.background({
            GroupRequestManager.instance.fetchGroupRequest(session_Token: sessionToken, fetchType: "group_chat_requests", offset: 1, setOnline: 1) { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.groupChatRequests ?? nil)")
                            self.groupsArray = success?.groupChatRequests ?? []
                            if self.groupsArray.isEmpty{
                                self.tableView.isHidden = true
                                self.noGrouplabel.isHidden = false
                                self.noRequestImage.isHidden = false
                            }else{
                                self.tableView.isHidden = false
                                self.noGrouplabel.isHidden = true
                                self.noRequestImage.isHidden = true
                            }
                            self.tableView.reloadData()
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
    @objc func refresh(sender:AnyObject) {
        self.groupsArray.removeAll()
        self.tableView.reloadData()
        self.fetchGroupRequest()
        refreshControl.endRefreshing()
        
    }
}
extension GroupRequestVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.requestGroupOne_TableCell.identifier) as? RequestGroupOne_TableCell
        cell?.vc = self
        let object = self.groupsArray[indexPath.row]
        cell?.bind(object)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

