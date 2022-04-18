//
//  GifCollectionCell.swift
//  WoWonder
//
//  Created by Muhammad Haris Butt on 11/3/20.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import WebKit

class GifCollectionCell: UICollectionViewCell {

    @IBOutlet weak var contentWebView: WKWebView!
    @IBOutlet weak var typeImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindGif(item:GIFModel.Datum,indexPath:IndexPath){
           self.typeImgView.image = UIImage(named: "ic_type_gif")
           
           DispatchQueue.main.async {
               let htmlString = "<html style=\"margin: 0;\"><body style=\"margin: 0;\"><img src=\"\(item.images?.fixedHeightStill?.url ?? "")\" style=\"width: 100%; height: 100%\" /></body></html>"
               self.contentWebView.loadHTMLString(htmlString, baseURL: nil)
           }
       }
}
