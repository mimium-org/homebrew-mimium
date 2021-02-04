# frozen_string_literal: true

class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", revision: "ea6f7636f173a5a2658c6ef7e9ebdac97621816b", tag: "v0.3.0"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url ""
    sha256 cellar: :any,                 catalina:     "3566e94d0a81a37952c039946aef0151f3b961e954fc0fb2d0202d393ae09c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5157fd53d294a9dcb15f175569e774d26c262d7f1b7b2e8de68a09b93618306e"
  end

  depends_on "alsa-lib" unless OS.mac?
  depends_on "bison" =>:build
  depends_on "cmake" => :build
  depends_on "flex" =>:build
  depends_on "pkg-config" => :build
  depends_on "gcc@9" unless OS.mac?
  depends_on "libsndfile"
  depends_on "llvm"

  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  def install
    mkdir "build"
    cd "build"
    if OS.mac?
      if MacOS.version >= :mojave
        sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
        ENV["HOMEBREW_SDKROOT"] = sdk_path
      end
      system "cmake", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "..",
             "-DCMAKE_OSX_SYSROOT=#{sdk_path}"
    else
      ENV.remove %w[LDFLAGS LIBRARY_PATH HOMEBREW_LIBRARY_PATHS], "#{HOMEBREW_PREFIX}/lib"
      system "cmake", "-DCMAKE_BUILD_TYPE=Release", "--config", "release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
    end
    system "make", "-j18"
    system "make", "install"
  end

  test do
    system "true"
  end
end
