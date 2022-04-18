
import UIKit
import WoWonderTimelineSDK
class IntroController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var nextImageBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!{
        
        didSet  {
            scrollView.delegate = self
        }
        
    }
    
    
    var imageSlides:[IntroImageSlider] = [];
    var newsFeed_data = [[String:Any]]()
    let status = Reach().connectionStatus()
    
    var isPage1 = 0
    var isPage2 = 0
    var isPage3 = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.alwaysBounceHorizontal = false
        self.scrollView.alwaysBounceVertical = false
        self.scrollView.scrollsToTop = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        imageSlides = createSlides()
        setupSlideScrollView(slides: imageSlides)
        self.scrollView.bounces = false
        self.scrollView.bouncesZoom = false
        pageController.numberOfPages = imageSlides.count
        pageController.currentPage = 0
        view.bringSubviewToFront(pageController)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    private func getNewsFeed () {
        switch status {
        case .unknown, .offline:
//            ZKProgressHUD.dismiss()
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
            self.view.isUserInteractionEnabled = true
        case .online(.wwan), .online(.wiFi):
            performUIUpdatesOnMain {
                GetNewsFeedManagers.sharedInstance.get_News_Feed(filter: 1, access_token: "\("?")\("access_token")\("=")\(UserData.getAccess_Token() ?? "")", limit: 15, off_set: "") {[weak self] (success, authError, error) in
                    if success != nil {
                        for i in success!.data{
                            AppInstance.instance.newsFeed_data.append(i)
                            self?.newsFeed_data.append(i)
                        }
                        
                        print(self?.newsFeed_data)
                       
//                        for it in self!.newsFeed_data{
//                            let boosted = it["is_post_boosted"] as? Int ?? 0
//                            self?.newsFeedArray.sorted(by: { _,_ in boosted == 1 })
//                        }
//                        self?.spinner.stopAnimating()
//                        ZKProgressHUD.dismiss()
                    }
                    else if authError != nil {
//                        ZKProgressHUD.dismiss()
//                        self?.view.isUserInteractionEnabled = true
//                        self?.view.makeToast(authError?.errors.errorText)
                    }
                    else if error  != nil {
//                        ZKProgressHUD.dismiss()
//                        self?.view.isUserInteractionEnabled = true
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    private func getSuggestedUsers(){
        switch status {
        case .unknown, .offline:
//            self.activityIndicator.stopAnimating()
            self.view.makeToast("Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetSuggestedGroupManager.sharedInstance.getGroups(type: "users", limit: 8) { (success, authError, error) in
                    if (success != nil){
                        for i in success!.data{
                            AppInstance.instance.suggested_users.append(i)
    //                        self.suggestedGroups.append(i)
                        }
                        
    //                    self.activityIndicator.stopAnimating()
    //                    self.tableView.reloadData()
                        
                    }
                    else if (authError != nil){
    //                    self.activityIndicator.stopAnimating()
    //                    self.view.makeToast(authError?.errors?.errorText)
                    }
                    else if (error != nil){
    //                    self.activityIndicator.stopAnimating()
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    private func getSuggestedGroups(){
        switch status {
        case .unknown, .offline:
//            self.activityIndicator.stopAnimating()
            self.view.makeToast("Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetSuggestedGroupManager.sharedInstance.getGroups(type: "groups", limit: 8) { (success, authError, error) in
                    if (success != nil){
                        for i in success!.data{
                            AppInstance.instance.suggested_groups.append(i)
    //                        self.suggestedGroups.append(i)
                        }
    //                    self.activityIndicator.stopAnimating()
    //                    self.tableView.reloadData()
                        
                    }
                    else if (authError != nil){
    //                    self.activityIndicator.stopAnimating()
    //                    self.view.makeToast(authError?.errors?.errorText)
                    }
                    else if (error != nil){
    //                    self.activityIndicator.stopAnimating()
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    private func getmyGroups() {
        switch status {
        case .unknown, .offline:
            showAlert(title: "", message: "Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetMyGroupsManager.sharedInstance.getMyGroups(userId: UserData.getUSER_ID()!, offset: "") { (success, authError, error) in
                    if success != nil {
                        print(success!.data)
                        for i in success!.data{
                            AppInstance.instance.myGroups.append(i)
                        }
                        //        self.myGroups = self.groupList.filter({$0["user_id"] as? String == UserData.getUSER_ID()!})
                        //            print(self.myGroups.count)
                        //        self.groupList = self.groupList.filter({$0["user_id"] as? String != UserData.getUSER_ID()!})
                        //                     print(self.groupList.count)
                        
//                        self.tableView.reloadData()
                    }
                    else if authError != nil {
                        print(authError?.errors.errorText ?? "")
//                        self.showAlert(title: "", message: (authError?.errors.errorText)!)
                    }
                    else if error != nil {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func getMyPages() {
        switch status {
        case .unknown, .offline:
            print("Internet Connection Failed")
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetMyPagesManager.sharedInstance.getLikedPages(userId: UserData.getUSER_ID()!, offset: "0") { (success, authError, error) in
                    if success != nil {
//                        self.myPages.removeAll()
                        for i in success!.data{
                            AppInstance.instance.myPages.append(i)
                        }
            
                        }
//                        self.activityIndicator.stopAnimating()
//                        self.tableView.reloadData()
                    
                    else if authError != nil {
                        print(authError?.errors.errorText ?? "")
//                        self.showAlert(title: "", message: (authError?.errors.errorText)!)
                    }
                    else if error != nil {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    
//    private func getSearchData(){
//        switch status {
//        case .unknown, .offline:
//            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
//        case .online(.wwan),.online(.wiFi):
//            performUIUpdatesOnMain {
//                GetSearchDataManager.sharedInstance.getSearchData(search_keyword: "", country: "", status: "", verified: "", gender: "", filterbyage: "", age_from: "", age_to: "") { (success, authError, error) in
//                    if success != nil{
//                        for i in success!.users{
//                            AppInstance.instance.suggested_users.append(i)
//                        }
//                        for i in success?.groups{
//                            AppInstance.instance.suggested_groups.append(i)
//                        }
////                        let userInfo =  ["pageData" : success!.pages]
////                        let usersInfo = ["groupData" : success!.groups]
////                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadpage"), object: nil, userInfo: userInfo)
////                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadGroup"), object: nil, userInfo: usersInfo)
////                        if self.users.count == 0{
////                            self.tableView.isHidden = true
////                            self.noContentView.isHidden = false
////                            self.activityIndicator.stopAnimating()
////                        }
////                        else {
////                            self.tableView.isHidden = false
////                            self.noContentView.isHidden = true
////                            self.activityIndicator.stopAnimating()
////                        }
////                        print(self.users)
////                        self.tableView.reloadData()
//                    }
//                    else if authError != nil{
////                        self.view.makeToast(authError?.errors.errorText)
////                        self.tableView.isHidden = false
////                        self.noContentView.isHidden = true
//                    }
//                    else if error != nil{
////                        self.view.makeToast(error?.localizedDescription)
////                        self.tableView.isHidden = false
////                        self.noContentView.isHidden = true
//                    }
//                }
//            }
//        }
//    }
    
    
    
    func createSlides() -> [IntroImageSlider] {
        
        let slide1:IntroImageSlider = Bundle.main.loadNibNamed("IntroImageSlider", owner: self, options: nil)?.first as! IntroImageSlider
        slide1.sliderImage.image = UIImage(named: "ic_rocket")
        slide1.textLabel.text = "Set your Location"
        slide1.descriptionLabel.text = "Set your location so we can tell you where the nearest interesting people are, Discover friends near by."
        slide1.backgroundColor = UIColor.hexStringToUIColor(hex: "2C4154")
        slide1.sliderImage.isHidden = true
        slide1.textLabel.isHidden = true
        slide1.descriptionLabel.isHidden = true
        slide1.backImage.image = UIImage(named: "boardImage1")
        
        
        let slide2:IntroImageSlider = Bundle.main.loadNibNamed("IntroImageSlider", owner: self, options: nil)?.first as! IntroImageSlider
        slide2.sliderImage.image = UIImage(named: "ic_magnifying_glass")
        slide2.textLabel.text = "Create Groups"
        slide2.descriptionLabel.text = "you are getting bored? Start and create a new group and add your friends and contacts and share all your posts from one place."
        slide2.backgroundColor = UIColor.hexStringToUIColor(hex: "FCB741")
        slide2.sliderImage.isHidden = true
        slide2.textLabel.isHidden = true
        slide2.descriptionLabel.isHidden = true
        slide2.backImage.image = UIImage(named: "boardImage2")
        
        
        let slide3:IntroImageSlider = Bundle.main.loadNibNamed("IntroImageSlider", owner: self, options: nil)?.first as! IntroImageSlider
        slide3.sliderImage.image = UIImage(named: "ic_paper_plane")
        slide3.textLabel.text = "Recording Access"
        slide3.descriptionLabel.text = "Grant us the permission to allow your app to leave voice notes and recorded songs on your new feed comments."
        slide3.backgroundColor = UIColor.hexStringToUIColor(hex: "2385C2")
        slide3.sliderImage.isHidden = true
        slide3.textLabel.isHidden = true
        slide3.descriptionLabel.isHidden = true
        slide3.backImage.image = UIImage(named: "boardImage3")
        
        let slide4:IntroImageSlider = Bundle.main.loadNibNamed("IntroImageSlider", owner: self, options: nil)?.first as! IntroImageSlider
        slide4.sliderImage.image = UIImage(named: "ic_chat_violet")
        slide4.textLabel.text = "Post Multimedia Files"
        slide4.descriptionLabel.text = "Post all kind of images & stickers & videos & document files on your won news feed"
        slide4.backgroundColor = UIColor.hexStringToUIColor(hex: "8E43AC")
        slide4.sliderImage.isHidden = true
        slide4.textLabel.isHidden = true
        slide4.descriptionLabel.isHidden = true
        slide4.backImage.image = UIImage(named: "boardImage4")
        
        
        return [slide1, slide2, slide3, slide4]
    }
    
    
    
    func setupSlideScrollView(slides : [IntroImageSlider]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageController.currentPage = Int(pageIndex)
        if pageController.currentPage == 1{
            if (self.isPage1 == 0){
                self.isPage1 = 1
                self.getNewsFeed()
            }
        }
        if (pageController.currentPage == 2){
            if (self.isPage2 == 0){
                self.isPage2 = 1
                self.getSuggestedUsers()
                self.getSuggestedGroups()
            }
        }
        if pageController.currentPage == 3 {
            if (self.isPage3 == 0){
                self.isPage3 = 1
                self.getMyPages()
                self.getmyGroups()
            }
            self.skipBtn.isHidden = true
            self.nextImageBtn.setImage(UIImage(named: "verified"), for: .normal)
            
        }else {
            self.skipBtn.isHidden = false
            self.nextImageBtn.setImage(UIImage(named: "arrow-pointing"), for: .normal)
            self.nextImageBtn.setTitle(nil, for: .normal)
        }
        
    }
    
    
    
    func scrollToNextSlide(){
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        let contentOffset = scrollView.contentOffset;
        
        scrollView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);
        
    }
    
    
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageController.currentPage == 0) {

            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageController.pageIndicatorTintColor = pageUnselectedColor
            
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            imageSlides[pageController.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageController.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    func fade(fromRed: CGFloat,fromGreen: CGFloat,fromBlue: CGFloat,fromAlpha: CGFloat,toRed: CGFloat,
              toGreen: CGFloat,toBlue: CGFloat,toAlpha: CGFloat,withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        
    }
    
//    News_FeedVC
    @IBAction func Next(_ sender: Any) {
        if pageController.currentPage == 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "TabbarVC")
            myVC.modalPresentationStyle = .fullScreen
            myVC.modalTransitionStyle = .coverVertical
            self.present(myVC, animated: true, completion: nil)
        }
        else {
            self.scrollToNextSlide()
        }
    }
    
    
    @IBAction func Skip(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let myVC = storyboard.instantiateViewController(withIdentifier: "TabbarVC")
        myVC.modalPresentationStyle = .fullScreen
        myVC.modalTransitionStyle = .coverVertical
        self.present(myVC, animated: true, completion: nil)
    }
    
    
    
}


