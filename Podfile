source 'https://github.com/CocoaPods/Specs.git'


def pods
    use_frameworks!
    pod 'Astral'
    pod 'BrightFutures'
end

target 'BFAstral-iOS' do
    platform :ios, '9.3'
    pods

    target 'BFAstralTests' do
        inherit! :search_paths
        # Pods for testing
    end

end

target 'BFAstral-Mac' do
    platform :macos, '10.11'
    pods
end

target 'BFAstral-tvOS' do
    platform :tvos, '11.0'
    pods
end

target 'BFAstral-watchOS' do
    platform :watchos, '4.0'
    pods
end
