class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", branch: "master"
  version "0.1.0"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url "https://github.com/mimium-org/homebrew-mimium/releases/download/v0.1.0"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2bee9b4aa88427e3a5294c0ba7b87308645ab4fa7377cb649c4fbcc6b9a68c3a" => :x86_64_linux
    sha256 "b6352041fe5dfe3864402f416866d1b42eab7c6284d579ed878cf5ca33499d13" => :catalina
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
      system "cmake", "-DBUILD_TEST=ON", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
    elsif OS.linux?
      opoo "If you fail to install, try 'brew unlink gcc@5.5 && brew link gcc@9' before install.\
      After an installation, make sure to do  'brew link gcc@5.5 --overwrite'"
      system "cmake", "-DBUILD_TEST=ON", "-DCMAKE_BUILD_TYPE=Release",
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
