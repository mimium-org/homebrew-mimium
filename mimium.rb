# frozen_string_literal: true

class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", revision: "5257c48f1bd3a154ea7a0b00c57f12d84d17587a", tag: "v0.1.4"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url "https://dl.bintray.com/mimium-org/bottles-mimium"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eb62a95a10ec1db69045c8186bac70c20d66328fe85fb18594a83319dcbfd901" => :catalina
    sha256 "cc2a64bc6be7fab5dd560a0ac741a2c3d5244c2c4ea8a0006937b03ff8d2a577" => :x86_64_linux
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
      system "cmake", "-DBUILD_TEST=OFF", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "..",
             "-DCMAKE_OSX_SYSROOT=#{sdk_path}"
    else
      ENV.remove %w[LDFLAGS LIBRARY_PATH HOMEBREW_LIBRARY_PATHS], "#{HOMEBREW_PREFIX}/lib"
      system "cmake", "-DBUILD_TEST=OFF", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
    end
    system "make", "-j18"
    system "make", "install"
  end

  test do
    system "true"
  end
end
