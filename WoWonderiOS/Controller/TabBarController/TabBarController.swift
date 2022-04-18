

import UIKit
import CircleBar

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)

        
//        let controllers = [ViewController(),MoreController()]
//        self.viewControllers = controllers
//        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }

}
