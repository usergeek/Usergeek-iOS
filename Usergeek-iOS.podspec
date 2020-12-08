Pod::Spec.new do |s|
s.name                   = "Usergeek-iOS"
s.version                = "1.0.0"
s.summary                = "Usergeek Native iOS SDK."
s.homepage               = "https://github.com/usergeek/Usergeek-iOS"
s.author                 = "Alexey Chirkov"
s.source                 = { :git => "git@github.com:usergeek/Usergeek-iOS.git", :tag => "#{s.version}" }
s.ios.deployment_target  = '9.0'
s.source_files           = "Usergeek-iOS/Sources/**/*.{h,m}"
s.requires_arc           = true
s.library 	           = 'sqlite3.0'
end