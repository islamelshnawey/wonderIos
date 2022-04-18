//
//  TwilloAudioCallVC.swift
//  WoWonder
//
//  Created by Abdul Moid on 30/12/2020.
//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import TwilioVideo

class TwilloAudioCallVC: UIViewController {
    
    // MARK:- View Controller Members
    
    // Configure access token manually for testing, if desired! Create one manually in the console
    // at https://www.twilio.com/console/video/runtime/testing-tools
    var accessToken = ""

    
    // Configure remote URL to fetch token from
    var tokenUrl = "https://www.vivlio.cy"
    
    
    // Video SDK components
    var room: TVIRoom?
    var audioDevice: TVIDefaultAudioDevice = TVIDefaultAudioDevice()
    var camera: TVICameraCapturer?
    var localVideoTrack: TVILocalVideoTrack?
    var localAudioTrack: TVILocalAudioTrack?
    var remoteParticipant: TVIRemoteParticipant?
    var remoteView: TVIVideoView?
    var profileImageUrlString: String?
    var usernameString: String?
    @IBOutlet weak var profileImage: UIImageView!
    // MARK:- UI Element Outlets and handles
    // `VideoView` created from a storyboard
//    @IBOutlet weak var previewView: TVIVideoView!
    
    
    let previewView:TVIVideoView = {
       let pv = TVIVideoView()
        pv.alpha = 0
        return pv
    }()
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var micButton: UIButton!
    var roomId:String? = ""
    @IBOutlet weak var roomNameLabel: UILabel!
    // MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("AccessToken = \(accessToken)")
        log.verbose("AccessToken = \(roomId ?? "")")
        if PlatformUtils.isSimulator {
            self.previewView.removeFromSuperview()
        } else {
            // Preview our local camera track in the local video preview view.
            self.startPreview()
        }
        self.setupUI()
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.connectVideoCall()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return self.room != nil
    }
    
    
    func setupUI(){
        self.usernameLabel.textColor = .black
        self.usernameLabel.text = self.usernameString ?? ""
        let url = URL.init(string:profileImageUrlString ?? "")
        self.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        //self.profileImage.cornerRadiusV = self.profileImage.frame.height / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        
        
        
    }

    func setupRemoteVideoView()
    {
        // Creating `TVIVideoView` programmatically
        self.remoteView = TVIVideoView.init(frame: CGRect.zero, delegate:self as! TVIVideoViewDelegate)
        
//        self.view.insertSubview(self.remoteView!, at: 0)
//
//        self.remoteView?.alpha = 0
//
//
//        // `TVIVideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
//        // scaleAspectFit is the default mode when you create `TVIVideoView` programmatically.
//        self.remoteView!.contentMode = .scaleAspectFill;
//
//        let centerX = NSLayoutConstraint(item: self.remoteView!,
//                                         attribute: NSLayoutConstraint.Attribute.centerX,
//                                         relatedBy: NSLayoutConstraint.Relation.equal,
//                                         toItem: self.view,
//                                         attribute: NSLayoutConstraint.Attribute.centerX,
//                                         multiplier: 1,
//                                         constant: 0);
//        self.view.addConstraint(centerX)
//        let centerY = NSLayoutConstraint(item: self.remoteView!,
//                                         attribute: NSLayoutConstraint.Attribute.centerY,
//                                         relatedBy: NSLayoutConstraint.Relation.equal,
//                                         toItem: self.view,
//                                         attribute: NSLayoutConstraint.Attribute.centerY,
//                                         multiplier: 1,
//                                         constant: 0);
//        self.view.addConstraint(centerY)
//        let width = NSLayoutConstraint(item: self.remoteView!,
//                                       attribute: NSLayoutConstraint.Attribute.width,
//                                       relatedBy: NSLayoutConstraint.Relation.equal,
//                                       toItem: self.view,
//                                       attribute: NSLayoutConstraint.Attribute.width,
//                                       multiplier: 1,
//                                       constant: 0);
//        self.view.addConstraint(width)
//        let height = NSLayoutConstraint(item: self.remoteView!,
//                                        attribute: NSLayoutConstraint.Attribute.height,
//                                        relatedBy: NSLayoutConstraint.Relation.equal,
//                                        toItem: self.view,
//                                        attribute: NSLayoutConstraint.Attribute.height,
//                                        multiplier: 1,
//                                        constant: 0);
//
//        self.view.addConstraint(height)
    }

    // MARK:- IBActions
    fileprivate func connectVideoCall() {
        // Configure access token either from server or manually.
        // If the default wasn't changed, try fetching from server.
        if (accessToken == "TWILIO_ACCESS_TOKEN") {
            do {
                accessToken = try TokenUtils.fetchToken(url: tokenUrl)
            } catch {
                let message = "Failed to fetch access token"
                logMessage(messageText: message)
                return
            }
        }
        
        self.prepareLocalMedia()
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = TVIConnectOptions.init(token: accessToken) { (builder) in
            
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [TVILocalAudioTrack]()
//            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [TVILocalVideoTrack]()
            
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use the preferred video codec
            if let preferredVideoCodec = Settings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = self.roomId ?? ""
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideo.connect(with: connectOptions, delegate: self)
        self.showRoomUI(inRoom: true)
        self.dismissKeyboard()
    }
    
    @IBAction func disconnect(_ sender: Any) {
        guard let dis = self.room else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        dis.disconnect()
        logMessage(messageText: "Attempting to disconnect from room \(room!.name)")
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    
    @IBAction func speakerClicked(_ sender: Any) {
        //..
    }
    
    @IBAction func toggleMic(_ sender: Any) {
        if (self.localAudioTrack != nil) {
            self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
            // Update the button title
            if (self.localAudioTrack?.isEnabled == true) {
                self.micButton.setTitle("Mute", for: .normal)
            } else {
                self.micButton.setTitle("Unmute", for: .normal)
            }
        }
    }
    
    // MARK:- Private
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }

        // Preview our local camera track in the local video preview view.
        camera = TVICameraCapturer(source: .frontCamera, delegate: self)
        localVideoTrack = TVILocalVideoTrack.init(capturer: camera!, enabled: true, constraints: nil, name: "Camera")
        if (localVideoTrack == nil) {
            logMessage(messageText: "Failed to create video track")
        } else {
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)
            
            // logMessage(messageText: "Video track created")

            logMessage(messageText: "Press button to start video call")

            // We will flip camera on tap.
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.flipCamera))
            self.previewView.addGestureRecognizer(tap)
        }
    }

    @objc func flipCamera() {

        if (self.camera?.source == .frontCamera) {
            self.camera?.selectSource(.backCameraWide)
        } else {
            self.camera?.selectSource(.frontCamera)
        }
    }

    func prepareLocalMedia() {

        // We will share local audio and video when we connect to the Room.

        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = TVILocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")
            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }
        
        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
    }

    // Update our UI based upon if we are in a Room or not
    func showRoomUI(inRoom: Bool) {
        self.micButton.isHidden = !inRoom
        self.disconnectButton.isHidden = !inRoom
        self.navigationController?.setNavigationBarHidden(inRoom, animated: true)
        UIApplication.shared.isIdleTimerDisabled = inRoom
        
        // Show / hide the automatic home indicator on modern iPhones.
        if #available(iOS 11.0, *) {
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }

    func cleanupRemoteParticipant() {
        if ((self.remoteParticipant) != nil) {
            if ((self.remoteParticipant?.videoTracks.count)! > 0) {
                let remoteVideoTrack = self.remoteParticipant?.remoteVideoTracks[0].remoteTrack
                remoteVideoTrack?.removeRenderer(self.remoteView!)
                self.remoteView?.removeFromSuperview()
                self.remoteView = nil
            }
        }
        self.remoteParticipant = nil
    }

    func logMessage(messageText: String) {
        NSLog(messageText)
        //usernameLabel.text = messageText
    }
}

// MARK:- RoomDelegate
// MARK: TVIRoomDelegate
extension TwilloAudioCallVC : TVIRoomDelegate {
    
    func didConnect(to room: TVIRoom) {
        
        // At the moment, this example only supports rendering one Participant at a time.

        //logMessage(messageText: "Connected to room \(room.name) as \(String(describing: room.localParticipant?.identity))")

        logMessage(messageText: "Connecting...")
        



        // logMessage(messageText: "Please wait until \(self.selectedUserName!) accept your request...")

        //Please wait until (user name) accept your request.

        if (room.remoteParticipants.count > 0) {
            self.remoteParticipant = room.remoteParticipants[0]
            self.remoteParticipant?.delegate = self
        }

        //        let cxObserver = callKitCallController.callObserver
        //        let calls = cxObserver.calls
        //
        //        // Let the call provider know that the outgoing call has connected
        //        if let uuid = room.uuid, let call = calls.first(where:{$0.uuid == uuid}) {
        //            if call.isOutgoing {
        //                callKitProvider.reportOutgoingCall(with: uuid, connectedAt: nil)
        //            }
        //        }
        //
        //        self.callKitCompletionHandler!(true)
    }
    
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
        logMessage(messageText: "Disconncted from room \(room.name), error = \(String(describing: error))")

        print("Disconncted from room \(room.name), error = \(String(describing: error))")

        UserDefaults.standard.set(nil , forKey: "voip")

        self.navigationController?.popToRootViewController(animated: true)

        self.cleanupRemoteParticipant()
        self.room = nil

        self.showRoomUI(inRoom: false)
    }
    
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
        logMessage(messageText: "Failed to connect to room with error")
        
        
        print(error)
        print("Failed to connect to room with error")
        self.room = nil

        self.showRoomUI(inRoom: false)
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
        if (self.remoteParticipant == nil) {
            self.remoteParticipant = participant
            self.remoteParticipant?.delegate = self
        }
        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
        print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
        if (self.remoteParticipant == participant) {
            cleanupRemoteParticipant()
        }
        self.navigationController?.popToRootViewController(animated: true)
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
        print("Room \(room.name), Participant \(participant.identity) disconnected")

        UserDefaults.standard.set(nil , forKey: "voip")
    }
}

// MARK: TVIRemoteParticipantDelegate
extension TwilloAudioCallVC : TVIRemoteParticipantDelegate {
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           publishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
        
        // Remote Participant has offered to share the video Track.

        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
        print("Participant \(participant.identity) published \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           unpublishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
        
        // Remote Participant has stopped sharing the video Track.
        
        //logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
        print("Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           publishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
        
        // Remote Participant has offered to share the audio Track.

        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
        print("Participant \(participant.identity) published \(publication.trackName) audio track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           unpublishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
        
        // Remote Participant has stopped sharing the audio Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
        print("Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }
    
    func subscribed(to videoTrack: TVIRemoteVideoTrack,
                    publication: TVIRemoteVideoTrackPublication,
                    for participant: TVIRemoteParticipant) {
        
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's video frames now.

        // logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        logMessage(messageText: "")

        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == participant) {
            setupRemoteVideoView()
            videoTrack.addRenderer(self.remoteView!)
        }
    }
    
    func unsubscribed(from videoTrack: TVIRemoteVideoTrack,
                      publication: TVIRemoteVideoTrackPublication,
                      for participant: TVIRemoteParticipant) {
        
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.

        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")

        print("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == participant) {
            videoTrack.removeRenderer(self.remoteView!)
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
        }
    }
    
    func subscribed(to audioTrack: TVIRemoteAudioTrack,
                    publication: TVIRemoteAudioTrackPublication,
                    for participant: TVIRemoteParticipant) {
        
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.

        //logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")

        logMessage(messageText: "")

        print("Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")

        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    func unsubscribed(from audioTrack: TVIRemoteAudioTrack,
                      publication: TVIRemoteAudioTrackPublication,
                      for participant: TVIRemoteParticipant) {
        
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.

        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
        print("Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           enabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
        print("Participant \(participant.identity) enabled \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           disabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")

        print("Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           enabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")

        print("Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
    
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           disabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")

        print("Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }
    
    func failedToSubscribe(toAudioTrack publication: TVIRemoteAudioTrackPublication,
                           error: Error,
                           for participant: TVIRemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
        print("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func failedToSubscribe(toVideoTrack publication: TVIRemoteVideoTrackPublication,
                           error: Error,
                           for participant: TVIRemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}



// MARK: TVIVideoViewDelegate
extension TwilloAudioCallVC : TVIVideoViewDelegate {
    func videoView(_ view: TVIVideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}


// MARK: TVICameraCapturerDelegate
extension TwilloAudioCallVC : TVICameraCapturerDelegate {
    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
        logMessage(messageText: "Camera source failed with error: \(capturer.isCapturing)")
        
    }
}
