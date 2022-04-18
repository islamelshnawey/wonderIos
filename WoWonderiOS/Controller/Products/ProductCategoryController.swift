

import UIKit
import WoWonderTimelineSDK

class ProductCategoryController: UIViewController {
    
    
    @IBOutlet weak var cateLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var categories = [String:String]()
    
    var delegate : ProductCategoryDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.cateLabel.text = NSLocalizedString("Select A Category", comment: "Select A Category")
        self.closeBtn.setTitle(NSLocalizedString("Close", comment: "Close"), for: .normal)
        
        let config = AppInstance.instance.siteSettings
        if let productCat = config["products_categories"] as? [String:String]{
            self.categories = productCat
            self.tableView.reloadData()
        }
        
        self.closeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
    }
    

  
    @IBAction func Category(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.delegate.category(categoryName: "Others", categoryId: "1")
            self.dismiss(animated: true, completion: nil)
        case 1:
           self.delegate.category(categoryName: "Autos & Vehicles", categoryId: "2")
            self.dismiss(animated: true, completion: nil)
        case 2:
            self.delegate.category(categoryName: "Baby & Childer's Products", categoryId: "3")
            self.dismiss(animated: true, completion: nil)
        case 3:
            self.delegate.category(categoryName: "Beauty Products & Services", categoryId: "4")
            self.dismiss(animated: true, completion: nil)
        case 4:
            self.delegate.category(categoryName: "Computers & Peripherals", categoryId: "5")
            self.dismiss(animated: true, completion: nil)
        case 5:
            self.delegate.category(categoryName: "Consumer Electronics", categoryId: "6")
            self.dismiss(animated: true, completion: nil)
        case 6:
            self.delegate.category(categoryName: "Dating Services", categoryId: "7")
            self.dismiss(animated: true, completion: nil)
        case 7:
            self.delegate.category(categoryName: "Financial Services", categoryId: "8")
            self.dismiss(animated: true, completion: nil)
        case 8:
            self.delegate.category(categoryName: "Gifts & Services", categoryId: "9")
            self.dismiss(animated: true, completion: nil)
        case 9:
            self.delegate.category(categoryName: "Home & Garden", categoryId: "10")
            self.dismiss(animated: true, completion: nil)
        default:
            print("Nothing")
        }
    }
    
    
    @IBAction func Close(_ sender: Any) {
        self.delegate.category(categoryName: "", categoryId: "")
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension ProductCategoryController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let values = Array(self.categories.values)[indexPath.row]
        cell.textLabel?.text = NSLocalizedString(values, comment: values)
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let values = Array(self.categories.values)[indexPath.row]
        let keys = Array(self.categories.keys)[indexPath.row]
        print(keys,values)
        self.dismiss(animated: true) {
            self.delegate.category(categoryName: NSLocalizedString(values, comment: values), categoryId: keys)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
