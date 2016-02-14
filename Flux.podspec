
Pod::Spec.new do |s|
  s.name        = "Flux"
  s.version     = "0.1.0"
  s.summary     = "A Swift implementation of the Flux application architecture."
  s.homepage    = "https://github.com/Adlai-Holler/Flux.swift"
  s.license     = { :type => "MIT" }
  s.authors     = { "Adlai-Holler" => "adlai@icloud.com" }

  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.source   = { :git => "https://github.com/Adlai-Holler/Flux.swift.git", :tag => "v#{s.version}" }
  s.source_files = "Flux/*.swift"
end
