//
//  SuggestedUserTableCell.swift
//  WoWonderiOS
//
//  Created by sinpanda on 3/2/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

protocol UserDelegate: class {
    func didSelectItem(record: [String: Any])
}

class SuggestedUserTableCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    

    weak var userDelegate: UserDelegate?
    
    var suggestedUsers = [[String:Any]]()
    var selectedIndex = 0
    var vc:FindFriendVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "SuggestedUserCollectionCell", bundle: nil), forCellWithReuseIdentifier: "suggestedUserCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.suggestedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestedUserCollectionCell", for: indexPath) as! SuggestedUserCollectionCell
        let object = self.suggestedUsers[indexPath.row]
//        cell.vc = FindFriendVC()
        cell.bind(object: object)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190.0, height: 245.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.suggestedUsers[indexPath.item]
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfile") as! GetUserDataController
//        vc.userData = index
//        self.vc?.navigationController?.pushViewController(vc, animated: true)
        let record = self.suggestedUsers[indexPath.row]
        self.userDelegate?.didSelectItem(record: record)
    }

}

extension SuggestedUserTableCell: UserDelegate {
    func didSelectItem(record: [String : Any]) {
        self.userDelegate?.didSelectItem(record: record)
    }
}
