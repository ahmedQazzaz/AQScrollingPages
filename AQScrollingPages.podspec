#
# Be sure to run `pod lib lint AQScrollingPages.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AQScrollingPages'
  s.version          = '1.1.0'
  s.summary          = 'AQScrollingPages is an easy scolling pages component for iOS to integrate in your project'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'AQScrollingPages is an easy component for iOS to integrate in your project, you can make pages with a scrolling tab bar, or without tab bar, in a few lettle steps.'

  s.homepage         = 'https://github.com/ahmedQazzaz/AQScrollingPages'
  s.screenshots     = 'http://aaqsoftwarecom.ipage.com/storyboardCustomization.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ahmedQazzaz' => 'aqazzaz2@hotmail.com' }
  s.source           = { :git => 'https://github.com/ahmedQazzaz/AQScrollingPages.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  s.source_files = 'AQScrollingPages/Classes/*.swift'
  
  # s.resource_bundles = {
  #   'AQScrollingPages' => ['AQScrollingPages/Assets/*.png']
  # }

  #s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
end
