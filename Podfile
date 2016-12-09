use_frameworks!

def common
  pod "RxSwiftUtilities", :path => "."
end

def common_iOS
  platform :ios, '8.0'
  common
end

def common_macOS
  platform :osx, '10.10'
  common
end

def common_tvOS
  platform :tvos, '9.0'
  common
end

def common_watchOS
  platform :watchos, '2.0'
  common
end

target("RxSwiftUtilities iOS")      { common_iOS }
target("RxSwiftUtilitiesTests iOS") { common_iOS }

target("RxSwiftUtilities macOS")      { common_macOS }
target("RxSwiftUtilitiesTests macOS") { common_macOS }

target("RxSwiftUtilities tvOS")      { common_tvOS }
target("RxSwiftUtilitiesTests tvOS") { common_tvOS }

target("RxSwiftUtilities watchOS") { common_watchOS }

