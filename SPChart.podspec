Pod::Spec.new do |s|
  s.name         = "SPChart"
  s.version      = "0.1.0"

  s.summary      = "A simple, animated and beatiful chart library used in Spreaker for iPhone app."

  s.homepage     = "https://github.com/dral3x/SPChart"
  #s.screenshots  = "https://github-camo.global.ssl.fastly.net/ea8565b7a726409d5966ff4bcb8c4b9981fb33d3/687474703a2f2f646c2e64726f70626f7875736572636f6e74656e742e636f6d2f752f313539393636322f706e63686172742e706e67"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Alessandro Calzavara" => "alessandro.calzavara@gmail.com" }

  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/dral3x/SPChart.git" }

  s.source_files = 'SPChart/*.{h,m}'
  s.public_header_files = 'SPChart/*.h'

  s.frameworks   = 'CoreGraphics', 'Foundation', 'UIKit', 'QuartzCore'
  s.requires_arc = true
end