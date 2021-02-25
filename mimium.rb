# frozen_string_literal: true

class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", revision: "ff9b2377eb3a971ba161a1319655d9c369c00d4b", tag: "v0.3.1"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url "https://dl.bintray.com/tomoyanonymous/bottles-mimium"
    rebuild 1
    sha256 cellar: :any,                 catalina:     "774fb920b3d40ab37775f38fda7ad47b5f4abb92274f3081e7a3a64f02b99da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5157fd53d294a9dcb15f175569e774d26c262d7f1b7b2e8de68a09b93618306e"
  end

  depends_on "alsa-lib" =>:build unless OS.mac?
  depends_on "bison" =>:build
  depends_on "cmake" => :build
  depends_on "flex" =>:build
  depends_on "gcc@9" => :build unless OS.mac?
  depends_on "ncurses" => :build unless OS.mac?
  depends_on "pkg-config" => :build
  depends_on "zlib" => :build unless OS.mac?
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
