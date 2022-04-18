
import UIKit
import AVFoundation
import AVKit

import WoWonderTimelineSDK

class ShowChatIntentsVC: UIViewController {
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    var imageUrl:String? = ""
    var videoUrl:String? = ""
    private var player = AVPlayer()
    private var playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()

    }
    

    @IBAction func crossPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI(){
        crossBtn.imageView?.image = crossBtn.imageView!.image!.withRenderingMode(.alwaysTemplate)
        crossBtn.imageView!.tintColor = UIColor.hexStringToUIColor(hex: "#a84849")
        if !self.imageUrl!.isEmpty{
            self.selectedImage.isHidden = false
            self.videoView.isHidden = true
            let url = URL.init(string:imageUrl ?? "")
            self.selectedImage.sd_setImage(with: url , placeholderImage:nil)
        }else{
            self.selectedImage.isHidden = true
            self.videoView.isHidden = false
            self.playVideo()
        }
       
       
    }
   private func playVideo() {
    
        let videoURL = URL(string: self.videoUrl ?? "")
        player = AVPlayer(url: videoURL! as URL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.addChild(playerController)
        playerController.view.frame = self.view.frame
        self.videoView.addSubview(playerController.view)
        
        player.play()
    }
}
