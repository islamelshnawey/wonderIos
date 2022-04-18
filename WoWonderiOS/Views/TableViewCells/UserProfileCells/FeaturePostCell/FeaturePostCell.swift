//
//  FeaturePostCell.swift
//  WoWonderiOS
//
//  Created by Abdul Moid on 12/06/2021.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit

class FeaturePostCell: UITableViewCell {
    
    var vc:UserProfileVC?
    var postImages: [[String:Any]]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "FeatureCells", bundle: nil), forCellWithReuseIdentifier: "FeatureCells")

    }
    
    func bind(featurePost: [[String:Any]]){
        postImages = featurePost
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FeaturePostCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCells", for: indexPath) as! FeatureCells
        if let index = postImages?[indexPath.row] {
            if let image = index["postFile_full"] as? String {
                let url = URL(string: image)
                cell.postImageView.kf.setImage(with: url)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 130, height: (collectionView.frame.height - 20))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 20, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //..
    }
    
}
