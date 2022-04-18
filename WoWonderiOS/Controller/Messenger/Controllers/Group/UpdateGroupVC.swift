

import UIKit

import Async
import WoWonderTimelineSDK


class UpdateGroupVC: BaseVC {
    
    @IBOutlet weak var deleteGroupBtn: UIButton!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var exitGroupBtn: UIButton!
    private var selectedUsersArray = [AddParticipantModel]()
    var partsArray = [FetchGroupModel.UserData]()
    var selectedIsArray = [Int]()
    var groupName:String? = ""
    var groupImageString:String? = ""
    var groupID:String? = ""
    var groupOwner:Bool? = false
    private var idsString:String? = ""
    private var idsArray = [Int]()
    private let imagePickerController = UIImagePickerController()
    private var imageData:Data? = nil

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        log.verbose("group id = \(self.groupID ?? "")")
    }
    
    @IBAction func addParticipantPressed(_ sender: Any) {
        
    }
    @IBAction func exitGroupPressed(_ sender: Any) {
        exitGroup()
    }
    
    @IBAction func deleteGroupPressed(_ sender: Any) {
        self.deleteGroup()
    }
    
    @IBAction func selectImagePressed(_ sender: Any) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .alert)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            self.imagePickerController.delegate = self
            
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: NSLocalizedString("Gallery", comment: "Gallery"), style: .default) { (action) in
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
    private func setupUI(){
        self.exitGroupBtn.setTitle(NSLocalizedString("Exit Group", comment: "Exit Group"), for: .normal)
        self.deleteGroupBtn.setTitle(NSLocalizedString("Delete Group", comment: "Delete Group"), for: .normal)
        
        self.partsArray.forEach { (it) in
            let object = AddParticipantModel(id: Int(it.userID ?? ""), profileImage: it.avatar ?? "", username: it.username ?? "")
            self.selectedUsersArray.append(object)
        }
        self.groupNameTextField.text = self.groupName ?? ""
        let url = URL.init(string:groupImageString ?? "")
    groupImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        var stringArray = self.selectedUsersArray.map { String($0.id ?? 0) }
        self.idsString = stringArray.joined(separator: ",")
        log.verbose("genresString = \(idsString)")
        log.verbose("self.selectedUsersArray = \(self.selectedUsersArray)")
        
        self.imageData = self.groupImage.image?.jpegData(compressionQuality: 0.1)
        
        if groupOwner!{
            self.deleteGroupBtn.isHidden = false
        }else{
            self.deleteGroupBtn.isHidden = false
        }
        
        collectionView.register( R.nib.addParticipantCollectionCell(), forCellWithReuseIdentifier: R.reuseIdentifier.addParticipant_CollectionCell.identifier)
        
        collectionView.register( R.nib.createGroupCollectionCell(), forCellWithReuseIdentifier: R.reuseIdentifier.createGroup_CollectionCell.identifier)
        
        self.title = NSLocalizedString("Update Group", comment: "Update Group")
        let add = UIBarButtonItem(title: NSLocalizedString("Add", comment: "Add"), style: .done, target: self, action: Selector("Add"))
        self.navigationItem.rightBarButtonItem = add
        
    }
    
    @objc func Add(){
        if imageData == nil{
//            let securityAlertVC = R.storyboard.main.securityPopupVC()
//            securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
//            securityAlertVC?.errorText = NSLocalizedString("Please select group avatar.", comment: "Please select group avatar.")
//            self.present(securityAlertVC!, animated: true, completion: nil)
        }else if self.groupNameTextField.text!.isEmpty{
//            let securityAlertVC = R.storyboard.main.securityPopupVC()
//            securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
//            securityAlertVC?.errorText = NSLocalizedString("Please enter group name.", comment: "Please enter group name.")
//            self.present(securityAlertVC!, animated: true, completion: nil)
        }else if self.idsString == ""{
//            let securityAlertVC = R.storyboard.main.securityPopupVC()
//            securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
//            securityAlertVC?.errorText = NSLocalizedString("Please select Atleast one participant.", comment: "Please select Atleast one participant.")
  //          self.present(securityAlertVC!, animated: true, completion: nil)
        }else{
            self.addParticipants()
            
        }
    }
    private func exitGroup(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
       let groupId = self.groupID ?? ""
        Async.background({
            GroupChatManager.instance.leaveGroup(group_Id:groupId , session_Token: sessionToken, type: "leave", completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("success = \(success?.apiStatus ?? 0)")
                            self.navigationController?.popViewControllers(viewsToPop: 2)
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
            })
        })
        
    }
    private func deleteGroup(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let groupId = self.groupID ?? ""
        Async.background({
            GroupChatManager.instance.deleteGroup(group_Id: groupId, session_Token: sessionToken, type: "delete", completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("success = \(success?.apiStatus ?? 0)")
                            self.navigationController?.popViewControllers(viewsToPop: 2)
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
            })
        })
    }
    
    private func updateGroup(){
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let groupName  = self.groupNameTextField.text ?? ""
        let imageData = self.imageData ?? Data()
        let groupId = self.groupID ?? ""
        Async.background({
            GroupChatManager.instance.updateGroup(session_Token: sessionToken, groupName: groupName, groupId: groupId, type: "edit", avatar_data: imageData, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("success = \(success?.apiStatus ?? 0)")
                            self.navigationController?.popViewController(animated: true)
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
            })
        })
        
    }
    private func addParticipants(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let part = self.idsString ?? ""
        let groupId = self.groupID ?? ""
        Async.background({
            GroupChatManager.instance.addParticipants(group_Id: groupId, session_Token: sessionToken, type: "add_user", part: part, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                       
                            log.debug("success = \(success?.apiStatus ?? 0)")
                            self.updateGroup()
                        
                        
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
            })
            
        })
        
    }
}


extension UpdateGroupVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return self.selectedUsersArray.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.addParticipant_CollectionCell.identifier, for: indexPath) as? AddParticipant_CollectionCell
            return cell!
        }else{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.createGroup_CollectionCell.identifier, for: indexPath) as? CreateGroup_CollectionCell
            cell?.delegate = self
            cell?.selectedParticipantArray = self.selectedUsersArray
            cell?.indexPath = indexPath.row
            let object = self.selectedUsersArray[indexPath.row]
            cell?.usernameLabel.text = object.username
            let url = URL.init(string:object.profileImage ?? "")
            cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
            return cell!
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = R.storyboard.group.addParticipantsVC()
        vc!.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension  UpdateGroupVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.groupImage.image = image
        self.imageData = image.jpegData(compressionQuality: 0.1)
        self.dismiss(animated: true, completion: nil)
        
        
    }
}

extension UpdateGroupVC:participantsCollectionDelegate{
    func selectParticipantsCollection(idsString: String, participantsArray: [AddParticipantModel]) {
        participantsArray.forEach { (it) in
            self.selectedUsersArray.forEach({ (it1) in
                if it1.id == it.id {
                    return
                }
            })
            let object = AddParticipantModel(id: it.id ?? 0, profileImage: it.profileImage ?? "", username: it.username ?? "")
            
            self.selectedUsersArray.append(object)
        }
        self.selectedUsersArray.forEach { (it) in
            self.selectedIsArray.append(it.id ?? 0)
        }
        var stringArray = self.selectedIsArray.map { String($0) }
        self.idsString = stringArray.joined(separator: ",")
        log.verbose("genresString = \(idsString)")
        log.verbose("self.selectedUsersArray = \(self.selectedUsersArray)")
        self.collectionView.reloadData()
        
    }
}
extension UpdateGroupVC:deleteParticipantDelegate{
    func deleteParticipant(index: Int, status: Bool, selectedUseArray: [AddParticipantModel]) {
        self.idsString = ""
        self.selectedUsersArray.removeAll()
        self.idsArray.removeAll()
        self.selectedUsersArray = selectedUseArray
        selectedUsersArray.forEach { (it) in
            self.idsArray.append(it.id ?? 0)
        }
        
        log.verbose("idsArray = \(self.idsArray)")
        var stringArray = self.idsArray.map { String($0) }
        self.idsString = stringArray.joined(separator: ",")
        log.verbose("genresString = \(idsString)")
        
        self.collectionView.reloadData()
    }
}
