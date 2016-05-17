platform:ios, '7.0'

def available_pods
  pod 'AFNetworking', '~> 2.0'
  pod 'SDWebImage'
  pod 'JSONModel'
  pod 'MJRefresh'
  pod 'Masonry'
  pod 'MBProgressHUD', '~> 0.9.1'
  pod 'UITableView+FDTemplateLayoutCell'
  pod 'ISDiskCache'
  pod 'TTTAttributedLabel'
  pod 'UMengAnalytics-NO-IDFA'
  pod 'THProgressView', '~> 1.0'
  pod 'EDStarRating'
  
  # Depending on how your project is organized, your node_modules directory may be
  # somewhere else; tell CocoaPods where you've installed react-native from npm
  pod 'React', :path => './node_modules/react-native', :subspecs => [
  'Core',
  'RCTImage',
  'RCTNetwork',
  'RCTText',
  'RCTWebSocket',
  # Add any other subspecs you want to use in your project
  'RCTLinkingIOS'
  ]
  
end

target 'MomiaIOS' do
  available_pods
end

target 'MomiaIOS DEBUG' do
  available_pods
end
