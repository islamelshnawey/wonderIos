

import Foundation
import UIKit
import WoWonderTimelineSDK
struct AppConstant {
    //cert key for WoWonder
    //Demo Key
    /*
     VjFaV2IxVXdNVWhVYTJ4VlZrWndUbHBXVW5OamJHUnpXVE5vYTJFemFERlhhMmhoWVRBeGNXSkVSbGhoTWxKWVdsWldOR1JHVW5WWGJXeFdWa1JCTlNOV01uUlRVV3N3ZDA1VlZsZFdSVXBQVldwR1YwMUdaSEphUlhCUFZsUlZNVlJWVWtOWlYwWnlWMjVHVlZKc1NubFVWM2h6VG0xRmVsVnJPV2hoZWtWNlZqSjBVMkZ0VmxkaVJsWm9Vak5TVUZsc1ZYZGxRVDA5UURFek1XTTBOekZqT0dJMFpXUm1Oall5WkdRd1pXSm1OMkZrWmpOak0yUTNNelkxT0RNNFlqa2tNVGszTURNeU1UWT0=
     
     */
//        static let key = "VjFaV2IxVXdNVWhVYTJ4VlZrWndUbHBXVW5OT2JHdDNXWHBXYkZZeFNrcFpNR2hUVjJ4WmVGTnVUbFZTZWtaUVdrY3hTMVpGT1VWTlJEQTlJMVpITlhkak1rWkdUbFZXVmxaRk5WRldhMVpIVFVaU1ZsVnROVTVOUkZVeFZGVlNRMWxXU2tkalNFcFZVbXhLZFZSVlZUVlNWbHBaVldzNVUwMUdjSHBXUmxaVFUyMVJkMDVVV21sU01uaFFWV3RrYW1WblBUMUFOelkwWW1Jek9EZGpNREZqT1dWbE56azBZbUl3WTJSa01XRTJZalEzWVRVa01UazNNRE15TVRZPQ=="
    
//    Vm0weE5HRXlVWGhVV0doVlYwZG9WVmxVU2xOaFJsWjBUVlJTYUZKc1ducFdWM1JyWVZVeFdWRnNiRnBOTTBKSVZrUkdTMlJIVmtkaVJuQk9VbXhzTTFadGRHRlpWMUpJVld0V1dHSkdjRmhhVjNoYVpXeGFkR05GU214U2EzQjZWMnRvUzJKR1NYZFhiRkpWVmtWd2RsWkZXbUZXYkdSeVYyeENWMkV3Y0ZSV1ZWcFNaREpTYzFGc1VtdFNia0poV1cxMGQxWldVblZqUmtwUVZsaFJNVlF4V210VWJGcDFVV3hzV0ZZelFraFdiVEZTWkRBeFYxZHRhRk5pUm5CMlZrWmpNV0l4V1hoWGJsSnJVakJhY2xSV1drdGxiR3QzVjIxMFYySlZjSGxVYkdoSFYyMUZlVlZzVW1GV00yaHlWbXhhVTJSRk9WaGhSVFZvVFZacmVWWXhXbGRWTVVsNFdrVm9VMWRIZUc5VmFrcHZXVlphY2xaclpFOVNiWFEwVjJ0V01GVXhXbkpqU0hCYVZsZFNkbFpITVV0U2JVNUhZMFprVG1KdGFHOVdiWEJDVFZaT1IxWnVTbUZTYkhCd1dXdGFkMWRzWkZobFIzUlBVbXhzTkZZeU5VdFdiVVYzWTBaQ1YxWnNSak5VTVZZd1RsVTVSV0pHU21oaVNFSTBWbXhTVDFReFZsWmtSRlpRVWtkNFdGVnRlSGRXUmxwSVRWWmtVMDFyY0VaV01uaGhWakZLVlZac1FsZGlXRUpEV2tSQmVGSXhjRWRoUjNCVFlYcFdkMVpYTURGUk1VNVhWMWhvVm1FelVsWlVWM1JoWlZacmQyRkZkRmhTTUZZMFZUSjBVMWR0UlhoalNIQmhVbFp3Y2xac1dsTmpNazVIV2tVMVYxZEZSak5XYlhSaFZURk5lRlZ1VWxkaWF6VnhWV3hhWVZsV1VsVlVhMDVXVW0xNFdWcFZXbUZVYkVwelUyeHdXazFIVFRGWlZWcGhWbGRLUjFSc1dsTmlSVmw2VmxWYVQyVnRVbk5SYkdSVVYwaENWMVJYTlVOa1ZsSnpWRzV3YTJKRlNsaFdNalZUWVRGSmVsVnVTbFZXYkZZMFZHdGFhMk50Umtaa1JsWnBVbTVDV2xac1l6RlJNVnB5VFZWa1dHSlhhRmhVVlZwM1lVWnJlV1ZIUm10U2EzQjZWbTF6TVZZd01IbGFla3BYWWxSQ05GUnJaRVpsUmxaMVZHeFNhV0Y2VmxaWFYzUnJUa1pzVjFWc1dtRlNWRlp6VlcweE5HVldXWGxOVldSb1RWVnNORlV4VWt0V2JVcFpZVVpvVjJGcldtaFpNakZQVW14YWMxcEZOVmRpYTBwMlZtMXdTbVZHVm5SV2JHUlVZa2Q0Y1ZWcVNqUldSbXh5VjI1a1YxWnRVbGxhVldSSFZrVXhWMU5yYUZkTmJsSnlWbTB4Um1WV1ZuVlNiRlpYWWxaS1ZWWlVRbUZaVm1SSVZtdHNWV0pIVW5CV2JGcHlaVlphZEUxVVVtbE5WbkF3VlcwMVMxUXhaRWRqUmxwWFlrWndNMWxWV2xkalZrcDFVMjE0YVZaV2NFbFdhMk40WWpKS1NGTnJaR3BTYlhoWVdWUkdkMkZHV2xWU2JrNVhUVmhDUjFkclpFZFZNVmw1WVVod1YxWjZSWGRYVmxwclVqSktSMkZIZEZOTlJuQlpWa1phWVZNeFdYaFdiazVXWW1zMVYxWnRlR0ZXYkZKV1ZXNUtVVlZVTURrPQ==/LHBhc3M9/Vnp3b0tYUnVaRGw1V1ZoUkszQkRhRjQ1TkRnbUpDcFhiMWR2Ym1SbGNpb2tKbGN0STAxcU9FQjNWU1FxUTI5dFltbHVaV1FxSkE9PQ==
    
    static let key = "Vm0weE5GbFdWWGhUV0d4VFYwZG9XVmxyWkZOV2JHeDBaVVYwVjFadGVGWlZNakExVmpKS1NHVkliRmROYWtaSVZtMHhTMUl4V25GVWJHaG9UVzFvZVZac1kzaFRNVTVIVm01S2FGSnRVazlaYlhNd1RVWmtWMVp0UmxSaVZrWTBWMnRvVjFVeVNrZFhhemxXWWxob01sUlhlR0ZXYkdSeVYyeENWMkV3Y0ZSV1ZWcFNaREpTYzFGc1VtdFNia0poV1cxMGQxWldVblZqUmtwUVZsaFJNVlF4V210VWJGcDFVV3hzV0ZZelFraFdiVEZTWkRBeFYxZHRhRk5pUm5CMlZrWmpNV0l4V1hoWGJsSnJVakJhY2xSV1drdGxiR3QzVjIxMFYySlZjSGxaTUdoUFYyMUZlV0ZGVWxaaVdHaG9WVEJWZUZkV2NFaGhSVFZYWWxoa05sWnRjRXROUjAxNFYxaHNWR0pHV2xSWmJUVkRWMVphZEdWSVpGcFdia0paV2xWYWEyRXhXblZSYTJoYVRVZFNlbFpxUmt0V01rNUhWbXhrVG1Kc1NtOVdNVnByVkRKU1IxZHVUbGhpUlVwWVdXeG9iMWRHV25Sa1JrNVNZWHBzVlZsNlRtRlZWbHBXWVROc1dsWXphRkJhVjNoWFVrZE5lbGRzUmxkaVZrcGFWMVJDVjAxSFJrZFRibEpzVWtWS1YxbHNVa2RsYkZwV1YydDBVMDFYVWpGVlYzaHZWakpLVjFOc1JsaFdiVkkyVkZaYWExSXhjRWRXYkZwb1pXMTRXVlpYZUdGV2JWRjRWMWhzVGxkSFVtOVpXSEJIVWpGU2MxWnRPVmRTTUhCWldsVlZOVlpXV1hwaFJXUlZWbFp3Y2xwRlZYaFdiVkpJWVVVMVUxSnJhM2hXYkdRMFZXMVJlRkZzVW1wTk1YQlNWbTEwYzA1c1dsVlRibVJwWVhwV1ZWbDZUbUZWVmxwelkwUkNXazFHV2pOWlZFRjRZekZrY21GR1pGTmxiRnBWVm0xd1MxTXlUblJVYTJSU1lrZFNjRlZ0TlVOaU1WbDRWMjFHVmsxV2NGaFdWelZMVmxkS1dHRkdVbHBpUjJoMlZqSjRhMk5zV25SUFZsWk9WbXR3TmxaVVNURlVNVnBJVTJ0b2JGSnNjRmhaYkdodllVWlNWVkp0UmxOV2EzQXdWVzE0YTFZeVNrbFJiR1JYVm5wRk1GWnFSbHBsUm1SMVUyMXdVMVpzY0ZsWFZsSkhVekZTUjFacVdsTmlTRUp6Vm0xNFMyVldiSEpYYkdSb1ZtdHdlbGt3V2xkWFJsbDZWV3hvWVZKRlJYaFdha1ozVTFaT2MxZHRhRTVUUlVwUlZtMHhORlV4V1hsV2JrNVlWMGQ0YzFVd1ZURlhSbXh6Vm14d1RtSkhlSGxXTW5oUFZqSktWbU5HY0ZwV1ZuQjJWbXhhWVZKc1pIUmhSbHBvWVRGd2IxZHJWbXRWTVVsNFkwVm9hRkl6YUc5VVZXUXdUVEZhY1ZKdGRFNVNNR3cwVlRGb2IxWXlTbkpPVjJoV1lrZFNkbGxxUmxkak1WWjFWR3hvVTJKWWFGZFdWRW8wVXpGU2MxTnVVbXRTUm5CWlZqQm9RMlZzV2xkWGJHUlhWbFJHUmxsWWIzZFFVVDA5/LHBhc3M9/Vnp3b0tYUnVaRGw1V1ZoUkszQkRhRjQ1TkRnbUpDcFhiMWR2Ym1SbGNpb2tKbGN0STAxcU9FQjNWU1FxUTI5dFltbHVaV1FxSkE9PQ=="
}

struct ControlSettings {
    
    //Mark:- Messanger
    static let showSocicalLogin = true
    static let googleClientKey = "735367472754-h9d86vqh6n4vfd2hvmvrsam5sme7h34m.apps.googleusercontent.com"
    static let googleApiKey = "AIzaSyBnmmW7BAPwrIIVsL8MnNpoS1g2ehBn22I"

    static let oneSignalAppId = "ec5c74c1-c532-48ab-a19c-9f1b517a894212d6518a-221a-4b7f-915d-94e0add01e44"
    static let agoraCallingToken = "36d5fb268eb5424b8946892ed4c9eb6 "
    static let addUnitId = ""
    static let interestialAddUnitId = ""
    static let facebookPlacementID = "" //Change this ID with your facebook placement ID
    static let HelpLink = "\(API.baseURL)/contact-us"
    static let reportlink = "\(API.baseURL)/contact-us"
    static let termsOfUse = "\(API.baseURL)/terms/terms"
    static let privacyPolicy = "\(API.baseURL)/terms/privacy-policy"
    static let socketPort = "449"
    
    
    static let inviteFriendText = "Please vist our website \(API.baseURL)"
    static let AppName = NSLocalizedString("Chats", comment: "Chats")
    static let WoWonderText = "\(NSLocalizedString("Hi! there i am using", comment: "Hi! there i am using")) \(AppName)"
    
    static let socketChat = false
    
    static let twilloCall = false
    static let agoraCall = true
    
    static let facebookAds = false//true
    static let googleAds = false
    
    static let googleMapKey = "AIzaSyDq8oZekd_MWY9pU5YDdo17fGvWSpSQznM"
    static let ShowSettingsGeneralAccount = true
    static let ShowSettingsAccountPrivacy = true
    static let ShowSettingsPassword = true
    static let ShowSettingsBlockedUsers = true
    static let ShowSettingsNotifications = true
    static let ShowSettingsDeleteAccount = true
    static var shouldShowAddMobBanner:Bool = false
    static var interestialCount:Int? = 3
    
    
    //Mark:- timeline
   // static let showSocicalLogin = false
 //   static let googleClientKey = "497109148599-u0g40f3e5uh53286hdrpsj10v505tral.apps.googleusercontent.com"
 //    static let googleApiKey = "AIzaSyDAlG53TEdqWnwQ2wXJkC2CBKPyqW7vALU"
 //   static let oneSignalAppId = "cebbb7d2-0f27-4e41-ab21-457fd841df34"
  //  static let addUnitId = "ca-app-pub-3940256099942544/2934735716"
  //  static let  interestialAddUnitId = "ca-app-pub-3940256099942544/4411468910"
    static let BrainTreeURLScheme = "hebekind.timeline.chat.ios.payments"
    static let paypalAuthorizationToken = ""
    static var showFacebookLogin:Bool = true
    static var showGoogleLogin:Bool = true
    static var isShowSocicalLogin:Bool = true
    static var ShowDownloadButton:Bool = true
  //  static var shouldShowAddMobBanner:Bool = true
 //   static var interestialCount:Int? = 3
    static var showPaymentVC = true
    static var buttonColor = "#FFC107"
    static var appMainColor = "#FFC107"
//    "#984243"
    
}

//Mark:- Messanger
extension UIColor {
    //    984243
    
    @nonobjc class var mainColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#FFC107")
    }
    
    @nonobjc class var ButtonColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#FFC107")
    }
    
}

