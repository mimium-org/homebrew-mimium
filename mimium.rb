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
  depends_on "libsndfile" => :build
  depends_on "llvm" => :build
  depends_on "ncurses" => :build unless OS.mac?
  depends_on "pkg-config" => :build
  depends_on "zlib" => :build unless OS.mac?

  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  patch :DATA # patch for linking libsndfile statically in 0.3.1

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

__END__

diff --git a/cmake/FindSndFile.cmake b/cmake/FindSndFile.cmake
index d19eb4b..86291c8 100644
--- a/cmake/FindSndFile.cmake
+++ b/cmake/FindSndFile.cmake
@@ -16,15 +16,14 @@
 #
 
 if (SNDFILE_LIBRARIES AND SNDFILE_INCLUDE_DIRS)
-  # in cache already
-  set(SNDFILE_FOUND TRUE)
+# in cache already
+set(SNDFILE_FOUND TRUE)
 else (SNDFILE_LIBRARIES AND SNDFILE_INCLUDE_DIRS)
 if(APPLE)
 set(HOMEBREW_PATH /usr/local)
 elseif(UNIX)
 set(HOMEBREW_PATH /home/linuxbrew/.linuxbrew )
 else()#windows
-SET(CMAKE_FIND_LIBRARY_SUFFIXES ".lib" ".dll" ".a.dll" ".dll.a" ".a")
 set(CMAKE_FIND_LIBRARY_PREFIXES "lib")  
 endif()
 find_path(SNDFILE_INCLUDE_DIR
@@ -42,7 +41,7 @@ find_path(SNDFILE_INCLUDE_DIR
   
   find_library(SNDFILE_LIBRARY
     NAMES
-      sndfile 
+      libsndfile.a sndfile 
     PATHS
       ${HOMEBREW_PATH}/lib
       /usr/lib
@@ -55,7 +54,7 @@ find_path(SNDFILE_INCLUDE_DIR
 
   find_library(OGG_LIBRARY
   NAMES
-  ogg
+  libogg.a ogg
   PATHS
   ${HOMEBREW_PATH}/lib
   /usr/lib
@@ -67,7 +66,7 @@ find_path(SNDFILE_INCLUDE_DIR
   )
   find_library(VORBIS_LIBRARY
   NAMES
-  vorbis 
+  libvorbis.a vorbis 
   PATHS
   ${HOMEBREW_PATH}/lib
   /usr/lib
@@ -79,7 +78,7 @@ find_path(SNDFILE_INCLUDE_DIR
   )
   find_library(VORBISENC_LIBRARY
   NAMES
-  vorbisenc
+  libvorbisenc.a vorbisenc
   PATHS
   ${HOMEBREW_PATH}/lib
   /usr/lib
@@ -91,7 +90,7 @@ find_path(SNDFILE_INCLUDE_DIR
   )
   find_library(FLAC_LIBRARY
   NAMES
-  flac FLAC
+  libFLAC.a flac FLAC
   PATHS
   ${HOMEBREW_PATH}/lib
   /usr/lib
@@ -103,7 +102,7 @@ find_path(SNDFILE_INCLUDE_DIR
   )
   find_library(OPUS_LIBRARY  REQUIRED
   NAMES
-  opus libopus.a
+  libopus.a opus
   PATHS
   ${HOMEBREW_PATH}/lib
   /usr/lib
