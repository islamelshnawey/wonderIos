

import UIKit
import ActiveLabel
import WoWonderTimelineSDK


class PostOptionCell: UITableViewCell {

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var statusLabel: ActiveLabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var view1: DesignView!
    @IBOutlet weak var view2: DesignView!
    @IBOutlet weak var view3: DesignView!
    @IBOutlet weak var view4: DesignView!
    @IBOutlet weak var view5: DesignView!
    @IBOutlet weak var view6: DesignView!
    @IBOutlet weak var view7: DesignView!
    @IBOutlet weak var view8: DesignView!
    @IBOutlet weak var view9: DesignView!
    @IBOutlet weak var view10: DesignView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label10: UILabel!
    
    @IBOutlet weak var checkBtn1: RoundButton!
    @IBOutlet weak var checkBtn2: RoundButton!
    @IBOutlet weak var checkBtn3: RoundButton!
    @IBOutlet weak var checkBtn4: RoundButton!
    @IBOutlet weak var checkBtn5: RoundButton!
    @IBOutlet weak var checkBtn6: RoundButton!
    @IBOutlet weak var checkBtn7: RoundButton!
    @IBOutlet weak var checkBtn8: UIButton!
    @IBOutlet weak var checkBtn9: RoundButton!
    @IBOutlet weak var checkBtn10: RoundButton!
    
    @IBOutlet weak var Percent1: UILabel!
    @IBOutlet weak var Percent2: UILabel!
    @IBOutlet weak var Percent3: UILabel!
    @IBOutlet weak var Percent4: UILabel!
    @IBOutlet weak var Percent5: UILabel!
    @IBOutlet weak var Percent6: UILabel!
    @IBOutlet weak var Percent7: UILabel!
    @IBOutlet weak var Percent8: UILabel!
    @IBOutlet weak var Percent9: UILabel!
    @IBOutlet weak var Percent10: UILabel!
    
    @IBOutlet weak var ProgressView1: UIProgressView!
    @IBOutlet weak var ProgressView2: UIProgressView!
    @IBOutlet weak var ProgressView3: UIProgressView!
    @IBOutlet weak var ProgressView4: UIProgressView!
    @IBOutlet weak var ProgressView5: UIProgressView!
    @IBOutlet weak var ProgressView6: UIProgressView!
    @IBOutlet weak var ProgressView7: UIProgressView!
    @IBOutlet weak var ProgressView8: UIProgressView!
    @IBOutlet weak var ProgressView9: UIProgressView!
    @IBOutlet weak var ProgressView10: UIProgressView!
    
    @IBOutlet weak var VoteBtn: UIButton!
    @IBOutlet weak var VoteBtn1: UIButton!
    @IBOutlet weak var VoteBtn2: UIButton!
    @IBOutlet weak var VoteBtn3: UIButton!
    @IBOutlet weak var VoteBtn4: UIButton!
    @IBOutlet weak var VoteBtn5: UIButton!
    @IBOutlet weak var VoteBtn6: UIButton!
    @IBOutlet weak var VoteBtn7: UIButton!
    @IBOutlet weak var VoteBtn8: UIButton!
    @IBOutlet weak var VoteBtn9: UIButton!

    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var CommentBtn: UIButton!
    @IBOutlet weak var ShareBtn: UIButton!
    @IBOutlet weak var likesCountBtn: UIButton!
    @IBOutlet weak var commentsCountBtn: UIButton!
    @IBOutlet weak var sharesCountBtn: UIButton!
    @IBOutlet weak var likeandcommentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    var vc: UIViewController?
    var votesArray = [[String:Any]]()
    var selectedVote = [[String:Any]]()
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ProgressView1.transform = self.ProgressView1.transform.scaledBy(x: 1, y: 1.8)
        self.ProgressView2.transform = self.ProgressView2.transform.scaledBy(x: 1, y: 1.8)
        self.ProgressView3.transform = self.ProgressView3.transform.scaledBy(x: 1, y: 1.8)
        self.ProgressView4.transform = self.ProgressView4.transform.scaledBy(x: 1, y: 1.8)
        self.ProgressView5.transform = self.ProgressView5.transform.scaledBy(x: 1, y: 1.8)
        self.ProgressView6.transform = self.ProgressView6.transform.scaledBy(x: 1, y: 1.8)
        self.ProgressView7.transform = self.ProgressView7.transform.scaledBy(x: 1, y: 1.8)
        self.ProgressView8.transform = self.ProgressView8.transform.scaledBy(x: 1, y: 1.8)
        self.ProgressView9.transform = self.ProgressView9.transform.scaledBy(x: 1, y: 1.8)
        self.ProgressView10.transform = self.ProgressView10.transform.scaledBy(x: 1, y: 1.8)
        self.LikeBtn.setTitle("\(" ")\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
        self.CommentBtn.setTitle("\(" ")\(NSLocalizedString("Comment", comment: "Comment"))", for: .normal)
        self.ShareBtn.setTitle("\(" ")\(NSLocalizedString("Share", comment: "Share"))", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func voteUP(voteId: Int,index:Int){
        AddVoteManager.sharedInstance.addVote(vote_id: voteId) { (success, authError, error) in
            if (success != nil){
                var count = 0
                for i in success!.votes{
                    count += 1
                    self.selectedVote.append(i)
                                        
                        if count == 1 {
                            if index == 1{
                                self.checkBtn1.setImage(UIImage(named: "checkess"), for: .normal)
                                self.checkBtn1.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            if let text = i["text"] as? String{
                                self.label1.text! = text.htmlToString
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView1.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent1.text = "\(percentage)"
                            }
                            if let all_Vote = i["all"] as? Int{
                                self.voteLabel.text = "\(all_Vote)\(" Votes")"
                            }
                        }
                        else if count == 2 {
                            
                            if index == 2{
                                self.checkBtn2.setImage(UIImage(named: "checkess"), for: .normal)
                                self.checkBtn2.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            
                            if let text = i["text"] as? String{
                                self.label2.text! = text.htmlToString
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView2.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent2.text = "\(percentage)"
                            }
                            
                        }
                        else if count == 3 {
                            if index == 3{
                                self.checkBtn3.setImage(UIImage(named: "checkess"), for: .normal)
                                self.checkBtn3.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            
                            if let text = i["text"] as? String{
                                self.label3.text! = text.htmlToString
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView3.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent3.text = "\(percentage)"
                            }
                            
                        }
                        else if count == 4{
                            if index == 4{
                                self.checkBtn4.setImage(UIImage(named: "checkess"), for: .normal)
                                self.checkBtn4.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            if let text = i["text"] as? String{
                                self.label4.text! = text.htmlToString
//                                self.view4.isHidden = true
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView4.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent4.text = "\(percentage)"
                            }
                            
                        }
            
                        else if count == 5 {
                            if index == 5{
                                self.checkBtn5.setImage(UIImage(named: "checkess"), for: .normal)
                                self.checkBtn5.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            if let text = i["text"] as? String{
                                self.label5.text! = text.htmlToString
//                                self.view5.isHidden = true
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView5.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent5.text = "\(percentage)"
                            }
                            
                        }
                            
                        else if count == 6{
                            if index == 6{
                                self.checkBtn6.setImage(UIImage(named: "checkess"), for: .normal)
                                self.checkBtn6.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            if let text = i["text"] as? String{
                                self.label6.text! = text.htmlToString
//                                self.view6.isHidden = true
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView6.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent6.text = "\(percentage)"
                            }
                        }
                            
                        else if count == 7 {
                            if index == 7{
                                self.checkBtn7.setImage(UIImage(named: "checkess"), for: .normal)
                                self.checkBtn7.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            if let text = i["text"] as? String{
                                self.label7.text! = text.htmlToString
//                                self.view7.isHidden = true
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView7.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent7.text = "\(percentage)"
                            }
                        }
                            
                        else if count == 8{
                            if index == 8{
                                self.checkBtn8.setImage(UIImage(named: "checkess"), for: .normal)
//                                self.checkBtn8.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            if let text = i["text"] as? String{
                                self.label8.text! = text.htmlToString
//                                self.view8.isHidden = true
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView8.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent8.text = "\(percentage)"
                            }
                        }
                            
                        else if count == 9 {
                            if index == 9{
                                self.checkBtn9.setImage(UIImage(named: "checkess"), for: .normal)
                                self.checkBtn9.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            if let text = i["text"] as? String{
                                self.label9.text! = text.htmlToString
//                                self.view9.isHidden = true
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView9.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent9.text = "\(percentage)"
                            }
                            
                        }
                            
                        else if count == 10{
                            if index == 10{
                                self.checkBtn10.setImage(UIImage(named: "checkess"), for: .normal)
                                self.checkBtn10.borderColor = UIColor.hexStringToUIColor(hex: "#984243")
                            }
                            if let text = i["text"] as? String{
                                self.label10.text! = text.htmlToString
//                                self.view10.isHidden = true
                            }
                            if let percentage_num = i["percentage_num"] as? String{
                                if let floatValue = Float(percentage_num) {
                                    print("Float value = \(floatValue)")
                                    self.ProgressView10.progress = floatValue/100
                                } else {
                                    print("String does not contain Float")
                                }
                            }
                            if let percentage = i["percentage"] as? String{
                                self.Percent10.text = "\(percentage)"
                            }
                        }

                }
            }
            else if (authError != nil){
                self.vc?.view.makeToast(authError?.errors?.errorText ?? "")
            }
            else if (error != nil){
                self.vc?.view.makeToast(error?.localizedDescription)
            }
        }
    }
    
    
    @IBAction func VoteUp(_ sender: UIButton) {
        var iD = ""
        if let id = self.votesArray[sender.tag]["id"] as? String{
          iD = id
        }
        switch sender.tag {
        case 0:
            self.index = 1
            self.voteUP(voteId: Int(iD) ?? 0, index: 1)
        case 1:
            self.index = 2
            self.voteUP(voteId: Int(iD) ?? 0, index: 2)
        case 2:
            self.index = 3
            self.voteUP(voteId: Int(iD) ?? 0, index: 3)
        case 3:
            self.index = 4
            self.voteUP(voteId: Int(iD) ?? 0, index: 4)
        case 4:
            self.index = 5
            self.voteUP(voteId: Int(iD) ?? 0, index: 5)
        case 5:
            self.index = 6
            self.voteUP(voteId: Int(iD) ?? 0, index: 6)
        case 6:
            self.index = 7
            self.voteUP(voteId: Int(iD) ?? 0, index: 7)
        case 7:
            self.index = 8
            self.voteUP(voteId: Int(iD) ?? 0, index: 8)
        case 8:
            self.index = 9
            self.voteUP(voteId: Int(iD) ?? 0, index: 9)
        case 9:
            self.index = 10
            self.voteUP(voteId: Int(iD) ?? 0, index: 10)
        default:
            print("Nothing")
        }
    }
    
}
