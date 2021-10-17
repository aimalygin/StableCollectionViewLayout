#
# Be sure to run `pod lib lint StableCollectionViewLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StableCollectionViewLayout'
  s.version          = '1.0.0'
  s.summary          = 'The StableCollectionViewLayout adjusts content offset'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This layout adjusts a content offset if the collection view is updated. 
You can insert, delete or reload items and StableCollectionViewLayout will take care of the content offset.
                       DESC

  s.homepage         = 'https://github.com/aimalygin/StableCollectionViewLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Malygin' => 'ai.malygin@icloud.com' }
  s.source           = { :git => 'https://github.com/aimalygin/StableCollectionViewLayout.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_versions = '5.0'

  s.source_files = 'StableCollectionViewLayout/Sources/**/*'
  
  # s.resource_bundles = {
  #   'StableCollectionViewLayout' => ['StableCollectionViewLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
