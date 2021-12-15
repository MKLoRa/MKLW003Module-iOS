#
# Be sure to run `pod lib lint MKLoRaWAN-B.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKLoRaWAN-B'
  s.version          = '1.0.3'
  s.summary          = 'MOKO LW003.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MKLoRa/MKLW003Module-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/MKLoRa/MKLW003Module-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  
  s.resource_bundles = {
    'MKLoRaWAN-B' => ['MKLoRaWAN-B/Assets/*.png']
  }
  
  s.subspec 'ApplicationModule' do |ss|
    ss.source_files = 'MKLoRaWAN-B/Classes/ApplicationModule/**'
    
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKLoRaWAN-B/Classes/CTMediator/**'
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'CTMediator'
  end
  
  s.subspec 'DatabaseManager' do |ss|
    ss.source_files = 'MKLoRaWAN-B/Classes/DatabaseManager/**'
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'FMDB'
  end
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKLoRaWAN-B/Classes/SDK/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKLoRaWAN-B/Classes/Target/**'
    ss.dependency 'MKLoRaWAN-B/Functions'
  end
  
  s.subspec 'ConnectModule' do |ss|
    ss.source_files = 'MKLoRaWAN-B/Classes/ConnectModule/**'
    
    ss.dependency 'MKLoRaWAN-B/SDK'
    
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/AboutPage/Controller/**'
      end
    end
    
    ss.subspec 'AdvertiserPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/AdvertiserPage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/AdvertiserPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/AdvertiserPage/Model/**'
      end
    end
    
    ss.subspec 'DevicePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/DevicePage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/DevicePage/Model'
        ssss.dependency 'MKLoRaWAN-B/Functions/DevicePage/View'
        
        ssss.dependency 'MKLoRaWAN-B/Functions/UpdatePage/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/DevicePage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/DevicePage/View/**'
      end
    end
    
    ss.subspec 'FilterCondition' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/FilterCondition/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/FilterCondition/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/FilterCondition/Model/**'
      end
    end
    
    ss.subspec 'FilterOptions' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/FilterOptions/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/FilterOptions/Model'
        ssss.dependency 'MKLoRaWAN-B/Functions/FilterOptions/View'
        
        ssss.dependency 'MKLoRaWAN-B/Functions/FilterCondition/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/FilterOptions/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/FilterOptions/View/**'
      end
    end
    
    ss.subspec 'LoRaPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/LoRaPage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/LoRaPage/Model'
        
        ssss.dependency 'MKLoRaWAN-B/Functions/LoRaSettingPage/Controller'
        ssss.dependency 'MKLoRaWAN-B/Functions/NetworkCheck/Controller'
        ssss.dependency 'MKLoRaWAN-B/Functions/MulticastGroup/Controller'
        ssss.dependency 'MKLoRaWAN-B/Functions/PayloadPage/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/LoRaPage/Model/**'
      end
    end
    
    ss.subspec 'LoRaSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/LoRaSettingPage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/LoRaSettingPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/LoRaSettingPage/Model/**'
      end
    end
    
    ss.subspec 'MulticastGroup' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/MulticastGroup/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/MulticastGroup/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/MulticastGroup/Model/**'
      end
    end
    
    ss.subspec 'NetworkCheck' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/NetworkCheck/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/NetworkCheck/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/NetworkCheck/Model/**'
      end
    end
    
    ss.subspec 'PayloadPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/PayloadPage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/PayloadPage/Model'
        ssss.dependency 'MKLoRaWAN-B/Functions/PayloadPage/View'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/PayloadPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/PayloadPage/View/**'
      end
    end
    
    ss.subspec 'ScannerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/ScannerPage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/ScannerPage/Model'
        ssss.dependency 'MKLoRaWAN-B/Functions/ScannerPage/View'
        
        ssss.dependency 'MKLoRaWAN-B/Functions/FilterOptions/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/ScannerPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/ScannerPage/View/**'
      end
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/ScanPage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/ScanPage/Model'
        ssss.dependency 'MKLoRaWAN-B/Functions/ScanPage/View'
        
        ssss.dependency 'MKLoRaWAN-B/Functions/TabBarPage/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/ScanPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/ScanPage/View/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/ScanPage/Model'
      end
    end
    
    ss.subspec 'SettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/SettingPage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/SettingPage/Model'
        ssss.dependency 'MKLoRaWAN-B/Functions/SettingPage/View'
        
        ssss.dependency 'MKLoRaWAN-B/Functions/AdvertiserPage/Controller'
        ssss.dependency 'MKLoRaWAN-B/Functions/SynDataPage/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/SettingPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/SettingPage/View/**'
      end
    end
    
    ss.subspec 'SynDataPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/SynDataPage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/SynDataPage/View'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/SynDataPage/View/**'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKLoRaWAN-B/Functions/LoRaPage/Controller'
        ssss.dependency 'MKLoRaWAN-B/Functions/ScannerPage/Controller'
        ssss.dependency 'MKLoRaWAN-B/Functions/SettingPage/Controller'
        ssss.dependency 'MKLoRaWAN-B/Functions/DevicePage/Controller'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/UpdatePage/Controller/**'
        ssss.dependency 'MKLoRaWAN-B/Functions/UpdatePage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKLoRaWAN-B/Classes/Functions/UpdatePage/Model/**'
      end
    end
    
    ss.dependency 'MKLoRaWAN-B/SDK'
    ss.dependency 'MKLoRaWAN-B/DatabaseManager'
    ss.dependency 'MKLoRaWAN-B/CTMediator'
    ss.dependency 'MKLoRaWAN-B/ConnectModule'
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    ss.dependency 'iOSDFULibrary'
    
  end
  
end
