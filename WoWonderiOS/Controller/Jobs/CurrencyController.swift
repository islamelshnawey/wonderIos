

import UIKit
import WoWonderTimelineSDK


class CurrencyController: UIViewController {
    
    @IBOutlet weak var selectCurrencyLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var delegate : JobCurrencyDelegate!
    
    var currencies = [String:String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.selectCurrencyLbl.text = NSLocalizedString("Select Currency", comment: "Select Currency")
        self.closeBtn.setTitle(NSLocalizedString("Close", comment: "Close"), for: .normal)
        self.closeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        let config = AppInstance.instance.siteSettings
        if let currenciey_array = config["currency_symbol_array"] as? [String:String]{
            self.currencies = currenciey_array
            self.tableView.reloadData()
        }
    }
    

    @IBAction func SelectCurrency(_ sender: UIButton) {
//        switch sender.tag {
//        case 0:
//            self.delegate.jobCurrency(currency: "$", currencyId: "0")
//            self.dismiss(animated: true, completion: nil)
//        case 1:
//            self.delegate.jobCurrency(currency: "€", currencyId: "1")
//            self.dismiss(animated: true, completion: nil)
//        case 2:
//            self.delegate.jobCurrency(currency: "₺", currencyId: "2")
//            self.dismiss(animated: true, completion: nil)
//        case 3:
//            self.delegate.jobCurrency(currency: "£", currencyId: "3")
//            self.dismiss(animated: true, completion: nil)
//        case 4:
//            self.delegate.jobCurrency(currency: "руб", currencyId: "4")
//            self.dismiss(animated: true, completion: nil)
//        case 5:
//            self.delegate.jobCurrency(currency: "zl", currencyId: "5")
//            self.dismiss(animated: true, completion: nil)
//        case 6:
//            self.delegate.jobCurrency(currency: "₪", currencyId: "6")
//            self.dismiss(animated: true, completion: nil)
//        case 7:
//            self.delegate.jobCurrency(currency: "R$", currencyId: "7")
//            self.dismiss(animated: true, completion: nil)
//        case 8:
//            self.delegate.jobCurrency(currency: "₹", currencyId: "8")
//            self.dismiss(animated: true, completion: nil)
//
//        default:
//            print("Default")
//        }
    }
    

    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate.jobCurrency(currency: "", currencyId: "")
    }
    
}

extension CurrencyController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let values = Array(self.currencies.values)[indexPath.row]
        cell.textLabel?.text = NSLocalizedString(values, comment: values)
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let values = Array(self.currencies.values)[indexPath.row]
        let keys = Array(self.currencies.keys)[indexPath.row]
        print(keys,values)
        self.dismiss(animated: true) {
            self.delegate.jobCurrency(currency: values, currencyId: "0")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
