
import UIKit
import AVFoundation
import AVKit
import Async
import WoWonderTimelineSDK

class CreateStoryVC: BaseVC {
    
    @IBOutlet weak var addNewStoryLabel: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addTextView: UITextView!
    
    var status:Bool? = true
    var pickedImage:UIImage? = nil
    var videoUrl:URL? = nil
    var videoData:Data? = nil
    private var player = AVPlayer()
    private var playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        if self.status!{
            self.videoView.isHidden = true
            self.selectedImage.isHidden = false
            self.selectedImage.image = pickedImage ?? UIImage()
            
        }else{
            self.videoView.isHidden = false
            self.selectedImage.isHidden = true
            playVideo()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func backPressed(_ sender: Any) {
        if !status!{
            self.navigationController?.popViewControllers(viewsToPop: 2)
        }else{
             self.navigationController?.popViewControllers(viewsToPop: 1)
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if !status!{
            self.createStory(data: (self.videoData ?? nil)!, type: "video")
        }else{
            let imageData = self.selectedImage.image?.jpegData(compressionQuality: 0.1)
            self.createStory(data:(imageData ?? nil)!, type: "image")
        }
    }
    private func setupUI(){
        self.addNewStoryLabel.text = NSLocalizedString("Add new Story", comment: "")
        self.usernameLabel.text  = AppInstance.instance.userProfile?.username ?? ""
        let url = URL.init(string:AppInstance.instance.userProfile?.avatar ?? "")
        profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        self.sendBtn.cornerRadiusV = self.sendBtn.frame.height  / 2
         self.profileImage.cornerRadiusV = self.profileImage.frame.height  / 2
    }
    func playVideo() {
        let videoURL = videoUrl
        player = AVPlayer(url: videoURL! as URL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.addChild(playerController)
        playerController.view.frame = self.view.frame
        self.videoView.addSubview(playerController.view)
        player.play()
    }
    private func createStory(data:Data,type:String){
        
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = AppInstance.instance.sessionId ?? ""
        let storyText = self.addTextView.text ?? ""
        
        Async.background({
            StoriesManager.instance.createStory(session_Token: sessionToken, type: type, storyDescription: storyText, storyTitle: "", data: data, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.apiStatus ?? nil)")
                            if type == "image"{
                                self.navigationController?.popViewControllers(viewsToPop: 1)
                                
                            }else{
                                self.navigationController?.popViewControllers(viewsToPop: 2)
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
            })
        })
    }
}
