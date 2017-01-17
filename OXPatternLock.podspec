Pod::Spec.new do |s|
  s.name         = "OXPatternLock"
  s.version      = "1.0"
  s.summary      = "An iOS pattern lock like Android authentication written in Swift"
  s.homepage     = "https://github.com/oxozle/OXPatternLock"
  s.license      = "MIT"
  s.author       = { "Dmitriy Azarov" => "contacts@oxozle.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/oxozle/OXPatternLock.git", :tag => s.version}
  s.source_files = "Source/**/*.swift"

  s.ios.deployment_target = '9.0'
end
