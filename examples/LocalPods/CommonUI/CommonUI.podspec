Pod::CompactSpec.new do |s|
  s.name = "CommonUI"
  s.spm_dependency "SwiftUIX/SwiftUIX"

  prebuild_macro = false
  if prebuild_macro
    # when use prebuild macro in Podfile as follow:
    #
    # pod "Orcam", :macro => {
    #   :git => "https://github.com/trinhngocthuyen/orcam.git",
    #   :branch => "main",
    # }
    # pod "MacroCodableKit", :macro => {
    #   :git => "https://github.com/mikhailmaslo/macro-codable-kit",
    #   :tag => "0.3.0",
    # }
    s.dependency "MacroCodableKit"
    s.dependency "Orcam"
  else
    # When dont use prebuild macro in podfile as follow:
    # spm_pkg "Orcam", :git => "https://github.com/trinhngocthuyen/orcam.git", :branch => "main"
    # spm_pkg "macro-codable-kit", :git => "https://github.com/mikhailmaslo/macro-codable-kit", :tag => "0.3.0"
    s.spm_dependency "Orcam/Orcam"
    s.spm_dependency "macro-codable-kit/MacroCodableKit"
  end


end
