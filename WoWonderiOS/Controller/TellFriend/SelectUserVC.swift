

import UIKit
import WoWonderTimelineSDK
import AlamofireImage
import Kingfisher
import SDWebImage
import PaginatedTableView
import Toast_Swift
import ZKProgressHUD
protocol didSelectUserDelegate {
    func didSelectUser(userID:String,username:String,index:Int)
}

class SelectUserVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let spinner = UIActivityIndicatorView(style: .gray)
    let pulltoRefresh = UIRefreshControl()
    var userArray  :UserListModel.DataClass?
    var filteredData: [UserListModel.Follow]!
    let status = Reach().connectionStatus()
    var delegate:didSelectUserDelegate?
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 40))
     let placeholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.white])
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    private func setupUI(){
        if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
                  textfield.clearButtonMode = .never
                  textfield.backgroundColor = UIColor.clear
                  textfield.attributedPlaceholder = NSAttributedString(string:" Search...", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
                  textfield.textColor = .white
                  if let leftView = textfield.leftView as? UIImageView {
                      leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                      leftView.tintColor = UIColor.white
                  }
              }
              self.searchBar.delegate = self
              self.searchBar.tintColor = .white
              let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
              self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        self.tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SelectUserTableItem", bundle: nil), forCellReuseIdentifier: "SelectUserTableItem")
        
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .white
        self.pulltoRefresh.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
//            UIColor.hexStringToUIColor(hex: "#984243")
        self.pulltoRefresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableView.addSubview(pulltoRefresh)
        ZKProgressHUD.show()
        self.userArray?.following?.removeAll()
        self.tableView.reloadData()
        self.loadBlockedUsers()
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
            
        }
    }
   @objc func done(){
    
    self.navigationController?.popViewController(animated: true)
    
   }
    @objc func refresh(){
        self.userArray?.following?.removeAll()
        self.tableView.reloadData()
        loadBlockedUsers()
        pulltoRefresh.endRefreshing()
        
    }
    private func loadBlockedUsers(){
        switch status {
        case .unknown, .offline:
            ZKProgressHUD.dismiss()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                GetUserManager.instance.getUsers(limit: 20, type: "following") { (success, authError, error) in
                    if success != nil {
                        self.userArray = success?.data!
                        self.filteredData = success?.data?.following ?? []
                        self.tableView.reloadData()
                        ZKProgressHUD.dismiss()
                        
                    }
                    else if authError != nil {
                        ZKProgressHUD.dismiss()
                        self.view.makeToast(authError?.errors?.errorText)
                        self.showAlert(title: "", message: (authError?.errors?.errorText)!)
                    }
                    else if error  != nil {
                        ZKProgressHUD.dismiss()
                        print(error?.localizedDescription)
                        
                    }
                }
            }
        }
    }
    
}
extension SelectUserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
        
    }
}


extension SelectUserVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectUserTableItem") as! SelectUserTableItem
        let object = self.filteredData[indexPath.row]
        cell.bind(object)
        
     
        return cell
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    self.delegate?.didSelectUser(userID: self.filteredData[indexPath.row].userID ?? "", username: self.filteredData[indexPath.row].username ?? "", index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let storyboard = UIStoryboard(name: "General", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateBlockUnBlockVC") as! UpdateBlockUnBlockVC
//        vc.object = self.blockedUserArray[indexPath.row]
//        self.present(vc, animated: true, completion: nil)
//    }
}

extension SelectUserVC:UISearchBarDelegate{
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.searchBar.resignFirstResponder()
//        let Storyboard = UIStoryboard(name: "Search", bundle: nil)
//        let vc = Storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchController
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .coverVertical
//        self.present(vc, animated: true, completion: nil)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
       filteredData =  self.userArray?.following!.filter({(dataString: UserListModel.Follow) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.username!.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
}
