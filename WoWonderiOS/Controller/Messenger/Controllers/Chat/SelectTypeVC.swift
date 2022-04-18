

import UIKit

class SelectTypeVC: UIViewController {
    let selectTypeArray = [
    "Image",
    "Video",
    "File"
    ]
    var delegate:SelectFileDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
       
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI(){
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.selectTypeTableCell(), forCellReuseIdentifier: R.reuseIdentifier.selectType_TableCell.identifier)
        
        
    }
}
extension SelectTypeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectTypeArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectType_TableCell.identifier) as? SelectType_TableCell
        cell?.typeLabel.text = self.selectTypeArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.delegate?.selectImage(status: true)
            self.dismiss(animated: true, completion: nil)
        }else if indexPath.row == 1{
            self.delegate?.selecVideo(status: true)
             self.dismiss(animated: true, completion: nil)
        }else{
             self.dismiss(animated: true, completion: nil)
        }
    }
    
}
