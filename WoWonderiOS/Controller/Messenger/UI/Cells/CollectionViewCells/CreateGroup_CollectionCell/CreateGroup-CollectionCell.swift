

import UIKit
protocol deleteParticipantDelegate{
    func deleteParticipant(index:Int,status:Bool,selectedUseArray:[AddParticipantModel])
}
class CreateGroup_CollectionCell: UICollectionViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var indexPath:Int? = 0
    var selectedParticipantArray = [AddParticipantModel]()
    var delegate:deleteParticipantDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func cancelPressed(_ sender: Any) {
        self.selectedParticipantArray.remove(at: indexPath ?? 0)
       
        self.delegate?.deleteParticipant(index: indexPath ?? 0, status: true, selectedUseArray:self.selectedParticipantArray)
     
    }
}
