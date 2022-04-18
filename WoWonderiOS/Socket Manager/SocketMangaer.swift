//
//  SocketMangaer.swift
//  WoWonder
//
//  Created by Muhammad Haris Butt on 03/09/2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
import SocketIO
import SwiftEventBus
import WoWonderTimelineSDK
class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: "\(API.baseURL):\(ControlSettings.socketPort)")!, config: [.log(true), .compress])
    var socket: SocketIOClient? = nil
    var status:Bool? = false
    func setupSocket() {
        self.socket = manager.defaultSocket
        print("Socket connection = \(self.socket?.description ?? "")")
    }
    func establishConnection() {
        self.socket?.on(clientEvent: .connect) {data, ack in
                    print("connect = \(data)")
                }
        self.socket?.connect()
    }
    func checkStatus()->Bool{
        let socketConnectionStatus = self.socket?.status
        switch socketConnectionStatus {
        case .connected:
            log.verbose("socket connected")
            status = true
            return true
        case .connecting:
            log.verbose("socket connecting")
            status = false
            return false
        case .disconnected:
            return false
            log.verbose("socket disconnected")
            status = false
            return false
        case .notConnected:
            log.verbose("socket not connected")
            status = false
            return false
        case .none:
            log.verbose("nothing")
            status = false
            return false
        }
    }
    
    func OnAnyEvent(){
        self.socket?.onAny({ event in
            print("event anme - \(event.event)")
        })
    }
    func closeConnection() {
        self.socket?.disconnect()
    }
    
    func emit(key:String,dic:[String:String]){
        self.socket!.emit(key,dic )
    }
    
    func sendMessage(eventName: String, toId:String ,fromID:String,username:String,msg:String,color:String,isSticker:String, message_reply_id:String,completionBlock: @escaping () ->()) {
        let data  =
            [
                API.SOCKET_PARAMS.to_id : toId,
                API.SOCKET_PARAMS.from_id : fromID,
                API.SOCKET_PARAMS.username : username,
                API.SOCKET_PARAMS.msg : msg,
                API.SOCKET_PARAMS.color : color,
                API.SOCKET_PARAMS.isSticker : isSticker,
                API.SOCKET_PARAMS.message_reply_id : message_reply_id,
              
            ]
        self.socket?.emitWithAck(eventName, data).timingOut(after: 0, callback: { data in
            if let ack = data.first as? String {
                print(ack)
            }
        })
        completionBlock()
        
    }

    func onPrivateMessage(completionHandler: (_ messageInfo: [String: Any]) -> Void) {
        self.socket?.on("private_message", callback: { (dataArray, socketAck ) -> Void in
            print("Message On Data = \(dataArray)")
        })
    }
    
    func sendTyping(message: String,recipentID:String,userID:String ,completionBlock: @escaping () ->()) {
        let data  =
            [
                API.SOCKET_PARAMS.recipient_id: recipentID,
                API.SOCKET_PARAMS.user_id:userID,
            ]
            as [String : Any]
        self.socket?.emit(message, data)
        completionBlock()
    }
    
    func sendJoin(message: String,username:String,userID:String ) {
        let data =
            [API.SOCKET_PARAMS.username:username ,API.SOCKET_PARAMS.user_id : userID]
        self.socket?.emit(message, data, completion: {
            log.verbose("JoingEmitted")
        })
    }
    
    func getChatMessage(completionHandler:@escaping  (_ messageInfo: [String: Any]) -> Void) {
        self.socket?.on(SocketEvents.SocketEventconstantsUtils.EVENT_PRIVATE_MESSAGE, callback: { (dataArray, socketAck ) -> Void in
            print("Message On data = \(dataArray)")
            var data  = dataArray[0] as? [String:Any]
            completionHandler(data ?? [:])
        })
    }
    func onTyping(completionHandler:@escaping (_ messageInfo: [String: Any]) -> Void) {
        self.socket?.on(SocketEvents.SocketEventconstantsUtils.EVENT_TYPING, callback: { (dataArray, socketAck ) -> Void in
            print("typing message = \(dataArray)")
            var data  =  dataArray[0] as? [String:Any]
            completionHandler(data ?? [:])
        })
    }
    
    func sendSeenMessage(message: String ,recipentID: String,userID:String,currentUserID:String ) {
        let data  =
            [
                API.SOCKET_PARAMS.recipient_id: recipentID,
                API.SOCKET_PARAMS.user_id:userID,
                API.SOCKET_PARAMS.current_user_id:currentUserID
            ] as [String : Any]
        self.socket?.emit(message, data)
    }
}
