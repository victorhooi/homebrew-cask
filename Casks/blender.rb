cask "blender" do
  version "2.83.4"
  sha256 "504212175a178a738a32120786862b75774e4f8e86bed97a395c4db05eb89518"

  url "https://download.blender.org/release/Blender#{version.major_minor.delete("a-z")}/blender-#{version}-macOS.dmg"
  appcast "https://download.blender.org/release/",
          must_contain: version.major_minor.delete("a-z")
  name "Blender"
  homepage "https://www.blender.org/"

  app "Blender.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/blender.wrapper.sh"
  binary shimscript, target: "blender"

  preflight do
    # make __pycache__ directories writable, otherwise uninstall fails
    FileUtils.chmod "u+w", Dir.glob("#{staged_path}/*.app/**/__pycache__")

    IO.write shimscript, <<~EOS
      #!/bin/bash
      '#{appdir}/Blender.app/Contents/MacOS/Blender' "$@"
    EOS
  end
end
