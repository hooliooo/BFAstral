source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.3'

def pods
    use_frameworks!
    pod 'Astral'
    pod 'BrightFutures'
end

target 'BFAstral-iOS' do
    pods

    target 'BFAstralTests' do
        inherit! :search_paths
        # Pods for testing
    end

end

target 'BFAstral-Mac' do
    pods
end

target 'BFAstral-tvOS' do
    pods
end

target 'BFAstral-watchOS' do
    pods
end
