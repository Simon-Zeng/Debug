Pod::Spec.new do |s|
s.name          = 'eLongFramework'
s.version       = '9.12.0'
s.summary       = 'a base framework of iOS app of elong.'
s.description   = <<-DESC
eLongFramework
-eLongDebug
-eLongStorage
-eLongCountly
-eLongAccount
-eLongCrash
-eLongGPS
-eLongBus
-eLongExtension
-eLongLoadImage
-eLongNetworking
-eLongMVCBase
-eLongJSONModel
-eLongJSONKit
-eLongFileIO
-eLongRefresh
-eLongAdvertisement
-eLongCoreSpotlight
-eLongMyElongPublicModel
-eLongMyElongImageUpload
-eLongThirdParty
-eLongHostResolver
DESC
s.homepage     = 'http://code.corp.elong.com/ios/elongframework'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.author       = { 'iOS Team' => 'mobile-it-ios@corp.elong.com' }
s.platform     = :ios, '7.0'
s.source       = { :git => 'http://code.corp.elong.com/ios/elongframework.git', :tag => s.version }
s.source_files = 'eLongFramework/eLongFramework.h'
s.public_header_files = 'eLongFramework/eLongFramework.h'
s.requires_arc = true
s.dependency 'JSONModel', '1.1.2'
s.dependency 'RegexKitLite', '4.0'
s.dependency 'pop', '1.0.8'
s.dependency 'FXBlurView', '1.6.4'
s.dependency 'SDWebImage', '3.7.3'
s.dependency 'Aspects', '1.4.1'
s.dependency 'FXLabel', '1.5.8'
s.dependency 'TTTAttributedLabelVodafone', '1.13.3.1'
s.dependency 'PLCrashReporter', '1.2.0'
s.dependency 'Masonry', '0.6.3'
s.dependency 'FMDB', '2.5'
s.dependency 'ZipArchive', '1.4.0'


# ――― eLongHostResolver ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongHostResolver' do |ss|
ss.source_files = 'eLongFramework/eLongHostResolver/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongHostResolver/*.h'
ss.frameworks = 'CFNetwork', 'Foundation'
ss.dependency 'eLongFramework/eLongExtension'
end

# ――― eLongDebug ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongDebug' do |ss|
ss.source_files = 'eLongFramework/eLongDebug/eLongDebugManager.{h,m}', 'eLongFramework/eLongDebug/**/*.{h,m}'
ss.resources = 'eLongFramework/eLongDebug/DebugDB/eLongDebug.xcdatamodeld'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongDebug/DebugModel/*.h', 'eLongFramework/eLongDebug/DebugObject/*.h', 'eLongFramework/eLongDebug/eLongDebugManager.h', 'eLongFramework/eLongDebug/DebugView/eLongDebugView.h'
ss.frameworks = 'CoreData', 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongBus'
end

# ――― eLongRefresh ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongRefresh' do |ss|
ss.source_files = 'eLongFramework/elongRefresh/*.{h,m}'
ss.resources = 'eLongFramework/elongRefresh/elongRefresh.xcassets'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongRefresh/*.h'
ss.frameworks = 'Foundation', 'UIKit'
end

# ――― eLongMyElongPublicModel ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongMyElongPublicModel' do |ss|
ss.source_files = 'eLongFramework/eLongMyElongPublicModel/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongMyElongPublicModel/*.h'
ss.frameworks = 'Foundation', 'UIKit','AdSupport'
ss.dependency 'eLongFramework/eLongExtension'
end

# ――― eLongMyElongImageUpload ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongMyElongImageUpload' do |ss|
ss.source_files = 'eLongFramework/eLongMyElongImageUpload/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongMyElongImageUpload/*.h'
ss.frameworks = 'Foundation', 'UIKit','AdSupport','AssetsLibrary'
ss.dependency 'eLongFramework/eLongExtension'
ss.dependency 'eLongFramework/eLongNetworking'
end

# ――― eLongMyElongNewImageUpload ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongMyElongNewImageUpload' do |ss|
ss.source_files = 'eLongFramework/eLongNewImageUpload/**/*.{h,m}'
ss.requires_arc = true
ss.resources = 'eLongFramework/eLongNewImageUpload/eLongImagUpload.xcassets','eLongFramework/eLongNewImageUpload/**/*.{xib}','eLongFramework/eLongNewImageUpload/**/*.plist'
ss.public_header_files = 'eLongFramework/eLongNewImageUpload/**/*.h'
ss.frameworks = 'Foundation', 'UIKit','AdSupport','AssetsLibrary'
ss.dependency 'eLongFramework/eLongExtension'
ss.dependency 'eLongFramework/eLongNetworking'
end

# ――― eLongStorage ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongStorage' do |ss|
ss.source_files = 'eLongFramework/eLongStorage/eLongStorage.h', 'eLongFramework/eLongStorage/**/*.{h,m}'
ss.requires_arc = ['eLongFramework/eLongStorage/Keychain/eLongKeyChain.m', 'eLongFramework/eLongStorage/UserDefault/eLongUserDefault.m']
ss.public_header_files = 'eLongFramework/eLongStorage/eLongStorage.h', 'eLongFramework/eLongStorage/**/*.h'
ss.frameworks = 'Foundation', 'UIKit', 'Security'
ss.dependency 'eLongFramework/eLongExtension'
end

# ――― eLongCountly ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongCountly' do |ss|
ss.source_files = 'eLongFramework/eLongCountly/eLongCountly.h', 'eLongFramework/eLongCountly/**/*.{h,m}'
ss.resources = 'eLongFramework/eLongCountly/Countly/Countly.xcdatamodeld'
ss.requires_arc = ['eLongFramework/eLongCountly/CountlyEvent/*.m']
ss.public_header_files = 'eLongFramework/eLongCountly/eLongCountly.h', 'eLongFramework/eLongCountly/CountlyEvent/*.h', 'eLongFramework/eLongCountly/Countly/Countly.h'
ss.frameworks = 'Foundation', 'CoreTelephony', 'UIKit', 'CoreData'
ss.dependency 'eLongFramework/eLongExtension'
ss.dependency 'eLongFramework/eLongNetworking'
end

# ――― eLongAccount ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongAccount' do |ss|
ss.source_files = 'eLongFramework/eLongAccount/eLongAccount.h', 'eLongFramework/eLongAccount/**/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongAccount/eLongAccount.h', 'eLongFramework/eLongAccount/**/*.h'
ss.frameworks = 'Foundation'
ss.dependency 'eLongFramework/eLongExtension'
ss.dependency 'eLongFramework/eLongNetworking'
end

# ――― eLongCrash ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongCrash' do |ss|
ss.source_files = 'eLongFramework/eLongCrash/eLongCrashRequestModel.{h,m}', 'eLongFramework/eLongCrash/Airbrake/notifier/*.{h,m}'
ss.resources = 'eLongFramework/eLongCrash/Airbrake/notifier/ABNotifier.bundle'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongCrash/eLongCrashRequestModel.h', 'eLongFramework/eLongCrash/Airbrake/notifier/*.h'
ss.frameworks = 'Foundation', 'SystemConfiguration', 'UIKit'
ss.dependency 'eLongFramework/eLongExtension'
ss.dependency 'eLongFramework/eLongNetworking'
end

# ――― eLongGPS ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongGPS' do |ss|
ss.source_files = 'eLongFramework/eLongGPS/**/*.{h,m}'
ss.resources = 'eLongFramework/eLongGPS/eLongLocation.bundle','eLongFramework/eLongGPS/eLongNewLocation/coordinates.plist'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongGPS/eLongLocation.h', 'eLongFramework/eLongGPS/**/*.h'
ss.frameworks = 'Foundation', 'CoreLocation', 'UIKit'
ss.vendored_frameworks = 'eLongFramework/eLongGPS/eLongNewLocation/BaiduMapAPI_Base.framework', 'eLongFramework/eLongGPS/eLongNewLocation/BaiduMapAPI_Search.framework'
ss.dependency 'eLongFramework/eLongExtension'
end

# ――― eLongBus ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongBus' do |ss|
ss.source_files = 'eLongFramework/eLongBus/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongBus/*.h'
ss.frameworks = 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongMVCBase'
#s.xcconfig = { 'ENABLE_STRICT_OBJC_MSGSEND' => 'NO' }
end

# ――― eLongExtension ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongExtension' do |ss|
ss.resources = 'eLongFramework/eLongExtension/eLongExtension.xcassets'
ss.source_files = 'eLongFramework/eLongExtension/eLongExtension.h', 'eLongFramework/eLongExtension/**/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongExtension/eLongExtension.h', 'eLongFramework/eLongExtension/**/*.h'
ss.frameworks = 'Foundation', 'UIKit'
ss.dependency 'RegexKitLite', '~> 4.0'
end

# ――― eLongLoadImage ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongLoadImage' do |ss|
ss.source_files = 'eLongFramework/eLongLoadImage/*.{h,m}', 'eLongFramework/eLongLoadImage/**/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongLoadImage/*.h', 'eLongFramework/eLongLoadImage/**/*.h'
ss.frameworks = 'MapKit', 'Foundation', 'UIKit', 'ImageIO'
end

# ――― eLongNetworking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongNetworking' do |ss|
ss.source_files = 'eLongFramework/eLongNetworking/eLongNetworking.h', 'eLongFramework/eLongNetworking/**/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongNetworking/eLongNetworking.h', 'eLongFramework/eLongNetworking/**/*.h'
ss.frameworks = 'Foundation', 'UIKit', 'SystemConfiguration', 'CoreTelephony'
ss.library = 'z'
ss.dependency 'eLongFramework/eLongDebug'
end

# ――― eLongMVCBase ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongMVCBase' do |ss|
ss.source_files = 'eLongFramework/eLongMVCBase/*.{h,m}'
ss.resources = 'eLongFramework/eLongMVCBase/BaseVC.xcassets'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongMVCBase/*.h'
ss.framework = 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongDefine'
ss.dependency 'JSONModel', '~> 1.1.0'
end

# ――― eLongLogger ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongLogger' do |ss|
ss.source_files = 'eLongFramework/eLongLogger/*.{h,m}', 'eLongFramework/eLongLogger/**/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongLogger/eLongLogger.h'
ss.frameworks = 'Foundation', 'CoreFoundation', 'UIKit'
end

# ――― eLongJSONKit ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongJSONKit' do |ss|
ss.source_files = 'eLongFramework/eLongJSONKit/*.{h,m}'
ss.requires_arc = false
ss.public_header_files = 'eLongFramework/eLongJSONKit/*.h'
ss.framework = 'Foundation', 'CoreFoundation'
end
# ――― eLongUMeng ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongUMeng' do |ss|
ss.source_files = 'eLongFramework/eLongUMeng/*.{h,m}'
ss.public_header_files = 'eLongFramework/eLongUMeng/*.h'
ss.framework = 'Foundation', 'UIKit'
ss.vendored_libraries = 'eLongFramework/eLongUMeng/libMobClickLibrary.a'
end
# ――― eLongFileIO ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongFileIO' do |ss|
ss.source_files = 'eLongFramework/eLongFileIO/**/*.{h,m}'
ss.resources = 'eLongFramework/eLongFileIO/eLongFileDirTypeKey_NameValue.plist'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongFileIO/eLongFileIOEnum.h','eLongFramework/eLongFileIO/eLongFileReadModel.h', 'eLongFramework/eLongFileIO/eLongFileWriteModel.h', 'eLongFramework/eLongFileIO/eLongFileIOManager.h', 'eLongFramework/eLongFileIO/eLongFileIOUtils.h', 'eLongFramework/eLongFileIO/CacheManage/CacheManage.h', 'eLongFramework/eLongFileIO/CacheManage/CacheManagerDelegate.h'
ss.frameworks = 'CoreData', 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongExtension'
end
# ――― eLongDefine ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongDefine' do |ss|
ss.source_files = 'eLongFramework/eLongDefine/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongDefine/*.h'
end
# ――― eLongControls ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongControls' do |ss|
ss.source_files = 'eLongFramework/eLongControls/*.{h,m}', 'eLongFramework/eLongControls/eLongPopupController/*.{h,m}',
    'eLongFramework/eLongControls/eLongPopupController/CNPPopupController/*.{h,m}',
    'eLongFramework/eLongControls/eLongPopupController/UIButton+SSEdgeInsets/*.{h,m}','eLongFramework/eLongControls/eLongGeographySelect/*.{h,m}','eLongFramework/eLongControls/eLongGeographySelect/Controller/*.{h,m}','eLongFramework/eLongControls/eLongGeographySelect/Model/*.{h,m}','eLongFramework/eLongControls/eLongGeographySelect/View/*.{h,m}','eLongFramework/eLongControls/eLongParticleEmitter/*.{h,m}','eLongFramework/eLongControls/eLongMap/Controller/*.{h,m}','eLongFramework/eLongControls/eLongMap/Model/*.{h,m}','eLongFramework/eLongControls/eLongMap/View/*.{h,m}','eLongFramework/eLongControls/eLongDateAndKeywordsSearchBarView/*.{h,m}','eLongFramework/eLongControls/eLongTopToolBarView/*.{h,m}'
ss.resources = 'eLongFramework/eLongControls/eLongControls.xcassets','eLongFramework/eLongControls/eLongMap/eLongMap.xcassets','eLongFramework/eLongControls/KeyBoard/*.png','eLongFramework/eLongControls/eLongPopupController/eLongPopupController.bundle','eLongFramework/eLongControls/Images/*.png'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongControls/**/*.h'
ss.dependency 'eLongFramework/eLongDefine'
end
# ――― eLongCalendar ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongCalendar' do |ss|
ss.source_files = 'eLongFramework/eLongCalendar/*.{h,m}'
ss.resources = 'eLongFramework/eLongCalendar/*.plist','eLongFramework/eLongCalendar/eLongCalendar.xcassets'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongCalendar/*.h'
ss.dependency 'eLongFramework/eLongDefine'
end
# ――― eLongThirdParty ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongThirdParty' do |ss|
ss.source_files = 'eLongFramework/eLongThirdParty/**/*.{h,m}'
ss.requires_arc = false
ss.vendored_frameworks = 'eLongFramework/eLongThirdParty/iOS-WebP/WebP.framework'
ss.public_header_files = 'eLongFramework/eLongThirdParty/**/*.h'
end
# ――― eLongHotel ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongHotel' do |ss|
ss.source_files = 'eLongFramework/elongHotel/**/*.{h,m}'
ss.resources = 'eLongFramework/elongHotel/eLongFileDirTypeKey_NameValue.plist'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/elongHotel/*.h','eLongFramework/elongHotel/Model/*.h','eLongFramework/elongHotel/MyElongHotelModel/*.h',
ss.frameworks = 'CoreData', 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongExtension'
ss.dependency 'eLongFramework/eLongNetworking'
ss.dependency 'eLongFramework/eLongDefine'
ss.dependency 'eLongFramework/eLongAccount'
ss.dependency 'eLongFramework/eLongGPS'

end
# ――― eLongImageUpload ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongImageUpload' do |ss|
ss.source_files = 'eLongFramework/eLongImageUpload/**/*.{h,m}'
ss.resources = 'eLongFramework/elongImageUpload/eLongFileDirTypeKey_NameValue.plist', 'eLongFramework/elongImageUpload/eLongImageUpload.xcassets'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongImageUpload/**/*.{h,m}'
ss.frameworks = 'CoreData', 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongHotel'

end
# ――― eLongPublicModel ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongPublicModel' do |ss|
ss.source_files = 'eLongFramework/eLongPublicModel/**/*.{h,m}'
ss.resources = 'eLongFramework/eLongPublicModel/eLongFileDirTypeKey_NameValue.plist'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongPublicModel/*.h'
ss.frameworks = 'CoreData', 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongDefine'
end

# ――― eLongTimer ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongTimer' do |ss|
ss.source_files = 'eLongFramework/eLongTimer/**/*.{h,m}'
ss.resources = 'eLongFramework/eLongTimer/eLongFileDirTypeKey_NameValue.plist'
ss.requires_arc = false
ss.public_header_files = 'eLongFramework/eLongTimer/**/*.{h,m}'
ss.frameworks = 'Foundation'
ss.dependency 'eLongFramework/eLongDefine'
end

# ――― eLongRobotForbidStrategy ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongRobotForbidStrategy' do |ss|
ss.source_files = 'eLongFramework/eLongRobotForbidStrategy/**/*.{h,m}'
ss.resources = 'eLongFramework/eLongRobotForbidStrategy/eLongFileDirTypeKey_NameValue.plist'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongRobotForbidStrategy/**/*.{h,m}'
ss.frameworks = 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongDefine'
ss.dependency 'eLongFramework/eLongNetworking'
ss.dependency 'eLongFramework/eLongControls'
ss.dependency 'eLongFramework/eLongExtension'
ss.dependency 'eLongFramework/eLongLoadImage'
end

# ――― PublicMethods ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'PublicMethods' do |ss|
ss.source_files = 'eLongFramework/PublicMethods/**/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/PublicMethods/**/*.{h,m}'
ss.frameworks = 'Foundation', 'UIKit','CoreGraphics', 'CoreLocation'
ss.dependency 'eLongFramework/eLongDefine'
end

# ――― eLongSetting ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongSetting' do |ss|
ss.source_files = 'eLongFramework/eLongSetting/**/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongSetting/**/*.{h,m}'
ss.frameworks = 'Foundation', 'UIKit','CoreGraphics'
ss.dependency 'eLongFramework/eLongDefine'
end

# ――― eLongDevice ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongDevice' do |ss|
ss.source_files = 'eLongFramework/eLongDevice/**/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongDevice/**/*.{h,m}'
ss.frameworks = 'LocalAuthentication'
ss.dependency 'eLongFramework/eLongDefine'
end

# ――― eLongCounterConfig ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongCounterConfig' do |ss|
ss.source_files = 'eLongFramework/eLongCounterConfig/**/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongCounterConfig/**/*.{h,m}'
ss.frameworks = 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongDefine'
end

# ――― eLongAdvertisement ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongAdvertisement' do |ss|
ss.source_files = 'eLongFramework/eLongAdvertisement/*.{h,m}'
ss.requires_arc = true
ss.public_header_files = 'eLongFramework/eLongAdvertisement/*.h'
ss.framework = 'Foundation', 'UIKit'
ss.dependency 'eLongFramework/eLongDefine'
ss.dependency 'JSONModel', '~> 1.1.0'
end

# ――― eLongCoreSpotlight ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongCoreSpotlight' do |ss|
ss.source_files = 'eLongFramework/eLongCoreSpotlight/*.{h,m}'
ss.public_header_files = 'eLongFramework/elongSpotlightRegister/*.h'
ss.requires_arc = true
ss.framework = 'Foundation', 'CoreSpotlight', 'MobileCoreServices'
ss.dependency 'eLongFramework/eLongDefine'
end

# ――― elongUrlComponents ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'elongUrlComponents' do |ss|
ss.source_files = 'eLongFramework/elongUrlComponents/*.{h,m}'
ss.public_header_files = 'eLongFramework/elongSpotlightRegister/*.h'
ss.requires_arc = true
ss.framework = 'Foundation'
ss.dependency 'eLongFramework/eLongDefine'
end


# ――― eLongDBLogger―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongDBLogger' do |ss|
ss.source_files = 'eLongFramework/eLongDBLogger/*.{h,m}', 'eLongFramework/eLongDBLogger/**/*.{h,m}'
ss.public_header_files = 'eLongFramework/eLongDBLogger/*.h', 'eLongFramework/eLongDBLogger/**/*.h'
ss.requires_arc = true
ss.framework = 'Foundation'
ss.libraries = 'sqlite3', 'stdc++'
ss.dependency 'eLongFramework/eLongDefine'
end

# ――― eLongAnalytics―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongAnalytics' do |ss|
ss.source_files = 'eLongFramework/eLongAnalytics/*.{h,m}', 'eLongFramework/eLongAnalytics/**/*.{h,m}'
ss.public_header_files = 'eLongFramework/eLongAnalytics/*.h', 'eLongFramework/eLongAnalytics/**/*.h'
ss.requires_arc = true
ss.framework = 'Foundation','CoreTelephony'
ss.dependency 'eLongFramework/eLongDefine'
ss.dependency 'Aspects', '~> 1.4.1'
end

# ――― eLongWebController―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongWebController' do |ss|
ss.source_files = 'eLongFramework/eLongWebController/*.{h,m}'
ss.public_header_files = 'eLongFramework/eLongWebController/*.h'
ss.requires_arc = true
#ss.framework = 'Foundation','CoreTelephony'
#ss.dependency 'eLongFramework/eLongDefine'
end

# ――― eLongCountrySelect―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.subspec 'eLongCountrySelect' do |ss|
ss.source_files = 'eLongFramework/eLongCountrySelect/*.{h,m}'
ss.public_header_files = 'eLongFramework/eLongCountrySelect/*.h'
ss.requires_arc = true
ss.framework = 'Foundation','UIKit'
ss.dependency 'eLongFramework/eLongDefine'
end

end
