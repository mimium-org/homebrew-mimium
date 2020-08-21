class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", branch: "master"
  version "0.1.0"
  license "MPL-2.0"

  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  depends_on "bison" =>:build
  depends_on "cmake" => :build
  depends_on "flex" =>:build
  depends_on "libsndfile" => :build
  depends_on "llvm" =>:build
  depends_on "pkg-config" => :build

  def install
    mkdir "build"
    cd "build"
    system "cmake", "-DBUILD_TEST=ON",
              "..",
              "-DCMAKE_BUILD_TYPE=Release",
              "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make", "-j18"
    system "make", "install"
  end

  test do
    system "false"
  end
end
