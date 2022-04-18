//
//  SuggestedGroupsCell.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 14/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class SuggestedGroupsCell: UITableViewCell {

    var vc:HomeVC?
    var isUser = false
    var groupArray:[[String:Any]]?
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var suggestedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupCollectionView()
        seeAllButton.isHidden = true
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SuggestedCollectionViewCells", bundle: nil), forCellWithReuseIdentifier: "SuggestedCollectionViewCells")
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }
    
    @IBAction func seeAllClicked(_ sender: Any) {
        //..
    }
}

extension SuggestedGroupsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedCollectionViewCells", for: indexPath) as! SuggestedCollectionViewCells
        cell.joinGroupButton.setTitle(isUser ? "Follow" : "Join Group", for: .normal)
        cell.isjoin = isUser
        if isUser {
            if let index = self.groupArray?[indexPath.row] {
                let name = index["name"] as? String
                let username = index["username"] as? String
                let userURL = index["avatar"] as? String
                let avatarURL = URL(string: userURL?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                cell.groupNameLabel.text = name ?? ""
                cell.groupMemberLabel.text = "@\(username ?? "")"
                cell.groupImageView.kf.setImage(with: avatarURL)
                cell.vc = self.vc
            }
            cell.profileLeading.constant = 10
            cell.profileWidth.constant = 0
        }else {
            if let index = self.groupArray?[indexPath.row] {
                let title = index["group_title"] as? String
                let members = index["members_count"] as? String
                let groupCoverURL = index["cover"] as? String
                let avatarURL = index["avatar"] as? String
                let url = URL(string: avatarURL?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                let groupURL = URL(string: groupCoverURL?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                cell.vc = self.vc
                cell.userprofileImageView.kf.setImage(with: url)
                cell.groupImageView.kf.setImage(with: groupURL)
                cell.profileWidth.constant = 45
                cell.profileLeading.constant = 15
                cell.groupNameLabel.text = title ?? ""
                cell.groupMemberLabel.text = "\(members ?? "") members"
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isUser{
            let index = self.groupArray?[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
            if let groupid = index?["user_id"] as? String{
                vc.user_id = groupid
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        }else{
            let index = self.groupArray?[indexPath.row]
            let storyboard = UIStoryboard(name: "GroupsAndPages", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GroupVC") as! GroupController
            if let groupid = index?["group_id"] as? String{
                vc.id = groupid
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 280, height: collectionView.frame.height - 20)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 20, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
