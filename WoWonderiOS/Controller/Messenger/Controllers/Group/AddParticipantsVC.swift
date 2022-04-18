
import UIKit
import Async

protocol didSelectParticipantDelegate {
    func selectParticipant(Image:UIButton,status:Bool,idsArray:[AddParticipantModel],Index:Int)
}
class AddParticipantsVC: BaseVC {
    
    @IBOutlet weak var downTextLabel: UILabel!
    @IBOutlet weak var noFollowersLabel: UILabel!
    @IBOutlet weak var showStack: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchRandomBtn: UIButton!
    @IBOutlet weak var showStackImage: UIImageView!
    
    
    private var followingsArray = [FollowingModel.Following]()
    private  var refreshControl = UIRefreshControl()
    private lazy var searchBar = UISearchBar(frame: .zero)
    private var userArray = [SearchModel.User]()
    private var searchText:String? = "random"
    private var done = UIBarButtonItem()
    private var search = UIBarButtonItem()
    private var searchActive:Bool? = false
    private var idsArray = [Int]()
    private var idsString:String? = ""
    private var participantsArray = [AddParticipantModel]()
    var delegate:participantsCollectionDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = NSLocalizedString("Add participants", comment: "Add participants")
        self.navigationController?.navigationItem.title = "Add participants"
        self.setupUI()
        self.fetchData()
        
    }
    
    private func setupUI(){
        self.noFollowersLabel.text = NSLocalizedString("There are no Contacts", comment: "")
        self.downTextLabel.text = NSLocalizedString("Start adding new contact !!", comment: "")
        self.searchRandomBtn.setTitle(NSLocalizedString("Search Random", comment: ""), for: .normal)
        self.searchRandomBtn.backgroundColor = .ButtonColor
        self.showStackImage.isHidden = true
        self.showStack.isHidden = true
        searchRandomBtn.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register( R.nib.addParticipantsTableCell(), forCellReuseIdentifier: R.reuseIdentifier.addParticipants_TableCell.identifier)
        self.done = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done"), style: .done, target: self, action: Selector("Done"))
       // ic_search
        //R.image.ic_search1()
        self.search = UIBarButtonItem(image: UIImage(named: "searches"), landscapeImagePhone: nil, style: .plain, target: self, action: Selector("Search"))
        self.navigationItem.rightBarButtonItems = [search,done]
    }
    
    @objc func refresh(sender:AnyObject) {
        if !searchActive!{
            self.followingsArray.removeAll()
            self.tableView.reloadData()
            self.fetchData()
        }else{
            self.userArray.removeAll()
            self.tableView.reloadData()
            self.fetchData(textForSearch: self.searchText ?? "random")
        }
    }
    
    @objc func Done(){
        self.navigationController?.popViewController(animated: true)
          self.delegate?.selectParticipantsCollection(idsString: self.idsString ?? "", participantsArray: participantsArray)
//        self.navigationItem.titleView = nil
//        self.navigationItem.rightBarButtonItems = [search,done]
    }
    @objc func Search(){
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItems?.remove(at: 0)
        
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
                            if (success?.following?.isEmpty)!{
                                self.showStackImage.isHidden = false
                                self.showStack.isHidden = false
                                self.searchRandomBtn.isHidden = false
                                self.tableView.isHidden = true
                                self.refreshControl.endRefreshing()
                            }else {
                                self.tableView.isHidden = false
                                self.showStackImage.isHidden = true
                                self.showStack.isHidden = true
                                self.searchRandomBtn.isHidden = true
                                self.followingsArray = success?.following ?? []
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
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
            }
            
        })
        
    }
    private func fetchData(textForSearch:String){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        self.userArray.removeAll()
        self.tableView.reloadData()
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let gender = AppInstance.instance.genderText ?? "All"
        Async.background({
            SearchManager.instance.searchUser(session_Token: sessionToken, country: "", status: "", verified: "", filterByAge: "", ageFrom: "", ageTo: "", search_Key: textForSearch, gender: gender) { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.users ?? [])")
                            if (success?.users?.isEmpty)!{
                                self.showStack.isHidden = false
                                self.searchRandomBtn.isHidden = false
                                self.tableView.isHidden = true
                                self.refreshControl.endRefreshing()
                            }else {
                                self.tableView.isHidden = false
                                self.showStack.isHidden = true
                                self.searchRandomBtn.isHidden = true
                                self.userArray = success?.users ?? []
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
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
            }
           
            
        })
        
    }
}
extension AddParticipantsVC: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .white
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.searchActive = true
        self.fetchData(textForSearch: self.searchText ?? "random")
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
        
        
    }
}
extension AddParticipantsVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.searchActive!{
            return self.followingsArray.count ?? 0
        }else{
            return self.userArray.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.addParticipants_TableCell.identifier) as? AddParticipants_TableCell
        cell?.selectionStyle = .none
        if !self.searchActive!{
            cell?.indexPath = indexPath.row
            cell?.delegate = self
            cell?.searchStatus = self.searchActive!
            cell?.userArray = self.followingsArray
            cell?.checkBtn.tintColor = .ButtonColor
            cell?.checkBtn.setImage(R.image.ic_uncheck_red()?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            let object = followingsArray[indexPath.row]
            cell?.usernameLabel.text = object.name ?? ""
            cell?.timeLabel.text = ControlSettings.WoWonderText
            let url = URL.init(string:object.avatar ?? "")
            cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
            cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
        }else{
            let object = self.userArray[indexPath.row]
            cell?.indexPath = indexPath.row
            cell?.delegate = self
            cell?.searchStatus = self.searchActive!
            cell?.searchArray = self.userArray
            cell?.checkBtn.tintColor = .ButtonColor
            cell?.checkBtn.setImage(R.image.ic_uncheck_red()?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell?.usernameLabel.text = object.name ?? ""
            cell?.timeLabel.text = ControlSettings.WoWonderText
            let url = URL.init(string:object.avatar ?? "")
            cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
            cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
            
        }
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72;
    }
    
    
}
extension AddParticipantsVC:didSelectParticipantDelegate{
    func selectParticipant(Image: UIButton, status: Bool, idsArray: [AddParticipantModel], Index: Int) {
        if status{
            Image.setImage(R.image.ic_checkRed()?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.idsArray.append(idsArray[Index].id ?? 0)
            log.verbose("genresIdArray = \(self.idsArray)")
            self.participantsArray.append(idsArray[Index])
            
            var stringArray = self.idsArray.map { String($0) }
            self.idsString = stringArray.joined(separator: ",")
            log.verbose("genresString = \(self.idsString)")
            log.verbose("genresIdArray = \(self.idsArray)")
        }else{
            Image.setImage(R.image.ic_uncheckRed()?.withRenderingMode(.alwaysTemplate), for: .normal)
            for (index,values) in self.idsArray.enumerated(){
                if values == idsArray[Index].id{
                    self.idsArray.remove(at: index)
                    self.participantsArray.remove(at: Index)
                    break
                }
                var stringArray = self.idsArray.map { String($0) }
                self.idsString = stringArray.joined(separator: ",")
                log.verbose("genresString = \(idsString)")
                log.verbose("genresIdArray = \(self.idsArray)")
            }
           
        }
    }
}
