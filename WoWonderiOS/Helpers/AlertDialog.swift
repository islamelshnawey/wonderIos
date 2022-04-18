//
//  AlertDialog.swift
//  WoWonder
//
//  Created by Olivin Esguerra on 18/03/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

//import UIKit
//
//
//protocol AlertDialogProtocol {
//    func open(url: URL)
//    func promptFor<Action: CustomStringConvertible>(_ title:String,_ message: String, cancelAction: Action, actions: [Action],vc:UIViewController) -> Observable<Action>
//}
//
//
//class AlertDialog: AlertDialogProtocol {
//    
//    static let shared = AlertDialog()
//    
//    private static func rootViewController() -> UIViewController {
//        return UIApplication.shared.keyWindow!.rootViewController!
//    }
//    
//    static func presentAlert(_ title: String,_ message: String) {
//        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
//        })
//        rootViewController().present(alertView, animated: true, completion: nil)
//    }
//    
//    func open(url: URL) {
//        
//    }
//    
//    func promptFor<Action>(_ title: String, _ message: String, cancelAction: Action, actions: [Action],vc:UIViewController) -> Observable<Action> where Action : CustomStringConvertible {
//        return Observable.create { observer in
//            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
//                observer.on(.next(cancelAction))
//            })
//            
//            for action in actions {
//                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
//                    observer.on(.next(action))
//                })
//            }
//            
//            vc.present(alertView, animated: true, completion: nil)
//            
//            return Disposables.create {
//                alertView.dismiss(animated:false, completion: nil)
//            }
//        }
//    }
//    
//    func promptForWithoutObservable(title: String, _ message: String,actionTitle:String,vc:UIViewController){
//        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertView.addAction(UIAlertAction(title: actionTitle, style: .cancel) { _ in
//            alertView.dismiss(animated: true, completion: nil)
//        })
//        
//        vc.present(alertView, animated: true, completion: nil)
//    }
//    func promptForWithoutObservable(title: String, _ message: String,cancelActionTitle:String,positiveActionTitle:String,vc:UIViewController){
//        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertView.addAction(UIAlertAction(title: cancelActionTitle, style: .cancel) { _ in
//            alertView.dismiss(animated: true, completion: nil)
//        })
//        
//        vc.present(alertView, animated: true, completion: nil)
//    }
//}
//
//
//
//
