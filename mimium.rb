# frozen_string_literal: true

class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", revision: "12fb684a030e400bb85eb69b325abea426207aaa", tag: "v0.4.0"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url "https://dl.bintray.com/tomoyanonymous/bottles-mimium"
    sha256 cellar: :any,                 catalina:     "242f4ac8ae74f7ab42cdf0babeadd4b0be536eca36e512107dc9d113af4115ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ebfb122b74741f200f53d979cb5256c51d3f3ad5d190b2a82c1e94809846c5ee"
  end

  depends_on "bison" =>:build
  depends_on "cmake" => :build
  depends_on "flex" =>:build
  depends_on "gcc@9" => :build unless OS.mac?
  depends_on "ncurses" => :build unless OS.mac?
  depends_on "pkg-config" => :build
  depends_on "zlib" => :build unless OS.mac?
  depends_on "alsa-lib" unless OS.mac?
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
      system "cmake", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
      opoo "Homebrew release on Linux is currently experimental. If you failed to load on alsa plugins and crushes, "
      "try 'brew reinstall alsa-lib -s'."
    end
    system "make", "-j18"
    system "make", "install"
  end

  test do
    system "true"
  end
end
