class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", branch: "master", tag: "v0.1.1"
  version "0.1.1"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url "https://github.com/mimium-org/homebrew-mimium/releases/download/v0.1.1"
    cellar :any
    sha256 "9280358ef2e80b378aead66f706cbf3f7cc54d8a7a0939246176b4b80f24c8af" => :catalina
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
