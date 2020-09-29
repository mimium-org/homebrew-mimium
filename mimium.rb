# frozen_string_literal: true

class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", revision: "5257c48f1bd3a154ea7a0b00c57f12d84d17587a", tag: "v0.1.4"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url "https://github.com/mimium-org/homebrew-mimium/releases/download/v0.1.4"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eb62a95a10ec1db69045c8186bac70c20d66328fe85fb18594a83319dcbfd901" => :catalina
    sha256 "cc2a64bc6be7fab5dd560a0ac741a2c3d5244c2c4ea8a0006937b03ff8d2a577" => :x86_64_linux
  end

  depends_on "bison" =>:build
  depends_on "cmake" => :build
  depends_on "flex" =>:build
  depends_on "llvm" =>:build
  depends_on "pkg-config" => :build
  depends_on "libsndfile"

  def install
    mkdir "build"
    cd "build"
    if OS.mac?
      system "cmake", "-DBUILD_TEST=OFF", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "..",
             "-DCMAKE_OSX_SYSROOT='/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk'"
    elsif OS.linux?
      system "cmake", "-DBUILD_TEST=OFF", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
    end

    system "make", "-j18"
    system "make", "install"
  end

  test do
    system "true"
  end
end
