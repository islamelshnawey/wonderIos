
import UIKit
import WoWonderTimelineSDK


class GetOffersTableItem: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var endDateBg: DesignView!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    var colors = [
       "#E0E0E0",
       "#808080",
       "#3A6728",
       "#4285f4",
       "#00FF00",
       "#FF0000",
       "#FFFFFF"
       ]
    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionLabel.numberOfLines = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func bind(_ object: [String:Any],index:Int){
        
        if let endDate = object["expire_date"] as? String{
            self.endDateLabel.text = "End Date \(endDate ?? "")"
        }
        if let image = object["image"] as? String{
            let url = URL(string: image)
            self.thumbImage.kf.setImage(with: url)
        }
        if let desc = object["description"] as? String{
            self.descriptionLabel.text = desc.htmlToString
        }
        if let title = object["offer_text"] as? String{
            self.titleLabel.text = title.htmlToString
        }
//        self.endDateLabel.text = "End Date \(object.expireDate ?? "")"
//        let url = URL(string: object.image ?? "")
//                    self.thumbImage.kf.setImage(with: url)
//        self.titleLabel.text = "\(object.discountType?.htmlToString ?? "") \(object.discountedItems?.htmlToString ?? "")"
//        self.descriptionLabel.text = object.datumDescription?.htmlToString ?? ""
        self.endDateBg.backgroundColor = UIColor.hexStringToUIColor(hex: self.colors[index])
    }
    
}
