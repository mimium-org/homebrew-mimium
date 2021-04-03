# frozen_string_literal: true

class Mimium < Formula
  desc "Programming language as an infrastructure for sound and music"
  homepage "https://mimium.org"
  url "https://github.com/mimium-org/mimium.git", revision: "4ac36f25a17324954bf36edbad1fc7fa785f6c74", tag: "v0.4.0"
  license "MPL-2.0"
  head "https://github.com/mimium-org/mimium.git", branch: "dev"

  bottle do
    root_url "https://dl.bintray.com/tomoyanonymous/bottles-mimium"
    sha256 cellar: :any,                 catalina:     "656dd4affc310fb2b1ca2fa4dba7f57884f7b45a262dcb969c776027eda97bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c1672d0d62dc8b6b2f085f2a11e918eff88e4afa677bc8ce08d324fa26bce7b3"
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
