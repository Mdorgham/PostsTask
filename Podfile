# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'TryCarTask' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TryCarTask
pod 'JTAppleCalendar', '~> 7.1'
pod 'FSCalendar'
pod 'MOLH'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

end
