# frozen_string_literal: true

class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", branch: "master", tag: "v0.1.5"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url "https://github.com/mimium-org/homebrew-mimium/releases/download/v0.1.4"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eb62a95a10ec1db69045c8186bac70c20d66328fe85fb18594a83319dcbfd901" => :catalina
    sha256 "92485413647a3db9b94c912dc60eb50557050563d6b2f3e7a7de8aee6fc7388d" => :x86_64_linux
  end

  depends_on "bison" =>:build
  depends_on "cmake" => :build
  depends_on "flex" =>:build
  depends_on "libsndfile" => :build
  depends_on "llvm" =>:build
  depends_on "pkg-config" => :build
  on_linux do
    depends_on "gcc@9" => :build
  end

  def install
    mkdir "build"
    cd "build"
    if OS.mac?
      system "cmake", "-DBUILD_TEST=OFF", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
    elsif OS.linux?
      opoo "If you fail to install, try 'brew unlink gcc@5.5 && brew link gcc@9' before install.\
      After an installation, make sure to do  'brew link gcc@5.5 --overwrite'"
      system "cmake", "-DBUILD_TEST=OFF", "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_C_COMPILER=gcc-9", "-DCMAKE_CXX_COMPILER=g++-9",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
    end

    system "make", "-j18"
    system "make", "install"
  end

  test do
    system "false"
  end
end
