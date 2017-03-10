Pod::Spec.new do |s|
  s.name         = 'SCMapCatch'
  s.version      = '0.2'
  s.summary      = 'A prompt view which show in the top of the screen .'
  s.homepage     = 'https://github.com/Chan4iOS/SCPromptView'
  s.author       = "CT4 => 284766710@qq.com"
  s.source       = {:git => 'https://github.com/Chan4iOS/SCPromptView.git', :tag => "#{s.version}"}
  s.source_files = "SCPromptView/**/*.{h,m}"
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.license = 'MIT'
end
