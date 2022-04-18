//
//  FriendsCells.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 12/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class FriendsCells: UITableViewCell {

    var vc:UserProfileVC?
    var friends:[[String : Any]]?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FeatureCells", bundle: nil), forCellWithReuseIdentifier: "FeatureCells")
    }
    
    func bind(data: [[String : Any]]){
        friends = data
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension FriendsCells: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCells", for: indexPath) as! FeatureCells
        cell.postImageView.layer.cornerRadius = 25
        cell.postImageView.clipsToBounds = true
        if let index = self.friends?[indexPath.row] {
            if let avater = index["avatar"] as? String {
                let formattedString = avater.replacingOccurrences(of: " ", with: "")
                let url = URL(string: formattedString)
                cell.postImageView.kf.setImage(with: url)

            }
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 20, right: 15)
    }
}
