
import UIKit
import WoWonderTimelineSDK

class ChangeLanguageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let languagesArray = [
        "Automatic",
        "English",
        "Arabic",
        "German",
        "Greek",
        "Spanish",
        "French",
        "Italian",
        "Japanese",
        "Dutch",
        "Portuguese",
        "Romanian",
        "Russian",
        "Albanian",
        "Serbian",
        "Thai",
        "Turkish"
    ]
    
    private var checkLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    func setupUI(){
        self.tableView.separatorStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.selectLanguageTableCell(), forCellReuseIdentifier: R.reuseIdentifier.selectLanguage_TableCell.identifier)
        log.verbose("Language selected = \(UserDefaults.standard.getLanguage(Key: Local.LANGUAGE.Language))")
        self.checkLanguage =  UserDefaults.standard.getLanguage( Key: Local.LANGUAGE.Language)
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension ChangeLanguageVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectLanguage_TableCell.identifier) as? SelectLanguage_TableCell
        cell?.languageLabel.text = self.languagesArray[indexPath.row]
        cell?.delegate = self
        cell?.indexPath = indexPath.row
        if checkLanguage == self.languagesArray[indexPath.row]{
            cell?.selectBtn.setImage(R.image.ic_radio_on(), for: .normal)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    
}
extension ChangeLanguageVC:SelectLanguageDelegate{
    func selectLanguage(index: Int, Button: UIButton) {
        let selectedLanguage = self.languagesArray[index]
        Button.setImage(R.image.ic_radio_on(), for: .normal)
        log.verbose("Language = \(selectedLanguage)")
        UserDefaults.standard.setLanguage(value: selectedLanguage, ForKey: Local.LANGUAGE.Language)
        self.view.makeToast(NSLocalizedString("Application will close to change the language", comment: "Application will close to change the language"))
        let timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
    }
    @objc func update() {
        exit(0)
    }
    
}
