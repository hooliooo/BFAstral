#
# Be sure to run `pod lib lint BFAstral.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BFAstral'
  s.module_name      = 'BFAstral'
  s.version          = '0.1.1'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.summary          = 'An extension to Astral that uses BrightFutures as the abstraction of asynchronous programming'
  s.homepage         = 'https://github.com/hooliooo/BFAstral'

  s.author           = { 'Julio Alorro' => 'alorro3@gmail.com' }
  s.source           = { :git => 'https://github.com/hooliooo/BFAstral.git', :tag => s.version }

  s.ios.deployment_target = '9.3'

  s.source_files = 'Sources/*.swift'
  s.requires_arc = true

  s.frameworks = 'Foundation'
  s.dependency 'Astral'
  s.dependency 'BrightFutures'

  s.swift_version = '4.0'
end
