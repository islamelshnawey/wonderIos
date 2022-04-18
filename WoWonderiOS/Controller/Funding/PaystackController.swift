//
//  PaystackController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 1/30/21.
//  Copyright © 2021 clines329. All rights reserved.
//

import UIKit
import WebKit



class PaystackController: UIViewController,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {

    
    @IBOutlet weak var naView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    private var paystackTestKey = "pk_test_d4af9729efaa43fdcf22a6bf4026a2ac6f8edb46"
     var email = ""
     var amount = 0
    private let ref = UUID().uuidString
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.naView.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.backgroundColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let htmlString = """
                             <!DOCTYPE html>
                             <html>

                             <head>
                                 <!--Let browser know website is optimized for mobile-->
                                 <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                                 <script src="https://js.paystack.co/v1/inline.js"></script>
                                 <script>
                                     function payWithPaystack() {
                                         var handler = PaystackPop.setup({
                                             key: '\(self.paystackTestKey)', //put your public key here
                                             email: '\(self.email)', //put your customer's email here
                                             amount: '\(self.amount)', //amount the customer is supposed to pay
                                             currency: "ZAR",
                                             ref: '\(self.ref)',
                                             metadata: {
                                                 custom_fields: [
                                                     {
                                                         display_name: "Mobile Number",
                                                         variable_name: "mobile_number",
                                                         value: "+2348012345678" //customer's mobile number
                                                     }
                                                 ]
                                             },
                                             callback: function (response) {
                             window.webkit.messageHandlers.observer.postMessage(response);
                                                '\(print("Transaction Succcessfull"))'
                                                 //after the transaction have been completed
                                                 'self.'
                                                 //make post call  to the server with to verify payment
                                                 //using transaction reference as post data
                                             
                                             },
                                             onClose: function () {
                                                 //when the user close the payment modal
                                                 alert('Transaction cancelled');
                                             }
                                         });
                                         handler.openIframe(); //open the paystack's payment modal
                                     }

                                 </script>
                             </head>

                             <body onload="payWithPaystack()">
                             </body>

                             </html>
                             """
        self.webView.loadHTMLString(htmlString, baseURL: nil)

    }
    
    @IBAction func Back(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished")
//        self.dismiss(animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.dismiss(animated: true) {
            self.view.makeToast(error.localizedDescription)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
        switch ScriptMessageHandler(rawValue: message.name)! {
        case .cancelPaymentHandler:
            self.dismiss(animated: true, completion: nil)
            break
        case .transactionResponse:
            guard let dict = message.body as? [String:AnyObject],
                let reference = dict["ref"] as? String else {return}
             print("Paystack Payment done with ref: \(reference)")
            
            break
        }
    }
    
}

enum ScriptMessageHandler:String {
    case cancelPaymentHandler = "cancelPaymentHandler"
    case transactionResponse
}

enum VerificationState:Int{
    case verifying = 0
    case success
    case failed
}
