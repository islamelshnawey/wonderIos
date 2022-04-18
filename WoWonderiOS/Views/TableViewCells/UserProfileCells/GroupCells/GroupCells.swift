//
//  GroupCells.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 12/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class GroupCells: UITableViewCell {
    
    var vc:UserProfileVC?
    var groupArray = [[String:Any]]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GroupCollectionViewCells", bundle: nil), forCellWithReuseIdentifier: "GroupCollectionViewCells")
    }
    
    func bind(groups: [[String:Any]]){
        self.groupArray = groups
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension GroupCells: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCollectionViewCells", for: indexPath) as! GroupCollectionViewCells
        let index = groupArray[indexPath.row]
        var name:String?
        if let groupName = index["group_name"] as? String {
            name = groupName
        }else if let pageName = index["name"] as? String{
            name = pageName
        }
        if let cover = index["cover"] as? String {
            let formattedString = cover.replacingOccurrences(of: " ", with: "")
            let url = URL(string: formattedString)
            cell.setupCell(image: url, name: name ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 130, height: (collectionView.frame.height - 20))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 20, right: 15)
    }
    
    
}

