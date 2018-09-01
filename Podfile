platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target :Journal do
  pod 'SnapKit'
  pod 'RealmSwift'

  pod 'Firebase/Core'
  pod 'Firebase/Database'
  
  target :JournalTests do
    inherit! :search_paths
    pod 'Nimble', '~> 7.0.0'
  end
end
