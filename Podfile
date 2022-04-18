# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WoWonderiOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  
  # Pods for News_Feed
  
  #  pod 'PINCache', :git => 'https://github.com/pinterest/PINCache', :branch => 'master'
  #  pod 'PINRemoteImage', :git => 'https://github.com/pinterest/PINRemoteImage', :branch => 'master'
  pod 'Alamofire','~> 5.2'
  pod 'AlamofireImage'
  pod 'Kingfisher', '~>5.15.7'
#  pod 'Kingfisher', :git => 'https://github.com/onevcat/Kingfisher.git', :branch => 'version6-xcode13'

  pod 'ZKProgressHUD'
  pod 'SDWebImage'
  pod 'MobilePlayer'
  pod 'Player'
  pod 'FBSDKCoreKit'
  pod 'R.swift'
  pod 'FBSDKLoginKit'
  pod 'IQKeyboardManager' #iOS8 and later
  pod 'GoogleSignIn', '5.0.0'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'YouTubePlayer'
  pod 'ActiveLabel'
  pod 'PaginatedTableView'
  pod 'Cosmos', '~> 20.0'
  pod 'Toast-Swift'
  pod 'CropViewController'
  pod 'XLPagerTabStrip'
  pod 'ImageSlideshow'
  pod 'ImageSlideshow/Kingfisher'
  pod 'NVActivityIndicatorView'
  pod 'TTRangeSlider'
  pod 'MMPlayerView'
  pod 'ActionSheetPicker-3.0'
  pod 'FontAwesome.swift'
  pod 'FittedSheets'
  pod 'VersaPlayer'
  pod "LinearProgressBar"
  pod 'Google-Mobile-Ads-SDK'
  pod 'Braintree'
  pod 'BraintreeDropIn'
  pod 'iRecordView'
  pod 'AgoraRtcEngine_iOS'
  pod 'Paystack'
  pod 'CircleBar'
  
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'
  pod 'SwiftEventBus', :tag => '3.0.0', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'
  pod 'AsyncSwift'
  pod 'SwiftyBeaver'
#  pod 'FBAudienceNetwork'
  pod 'JGProgressHUD'
  pod "BSImagePicker", "~> 3.1"
  pod 'DropDown'
  pod 'TwilioVideo', '~> 2.3'
  pod 'SkyFloatingLabelTextField'
 # pod 'IQKeyboardManagerSwift'
  pod 'Floaty'
  
  #    pod 'Giphy'
  target 'WoWonderiOSTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'WoWonderiOSUITests' do
    # Pods for testing
  end
  
end

target 'OneSignalNotificationServiceExtension' do
  use_frameworks!
  pod 'OneSignal', '>= 2.11.2', '< 3.0'
end
#post_install do |installer|
#  installer.pods_project.build_configurations.each do |config|
#    config.build_settings.delete('CODE_SIGNING_ALLOWED')
#    config.build_settings.delete('CODE_SIGNING_REQUIRED')
#  end
#end
post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
