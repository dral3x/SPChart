Pod::Spec.new do |s|
  s.name         = "SPChart"
  s.version      = "0.3.1"

  s.summary      = "A simple, animated and beatiful chart library used in Spreaker for iPhone app."

  s.homepage     = "https://github.com/dral3x/SPChart"
  s.author       = { "Alessandro Calzavara" => "alessandro.calzavara@gmail.com", "Tomasz Muszyński" => "thom@union.waw.pl"  }

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/dral3x/SPChart.git", :tag => s.version }

  s.source_files = 'SPChart/**/*.{h,m}'
  s.public_header_files = 'SPChart/**/*.h'

  s.frameworks   = 'CoreGraphics', 'Foundation', 'UIKit', 'QuartzCore'
  s.requires_arc = true
end