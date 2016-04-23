# Documentation: https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Jwtap < Formula
  desc "JSON Web Token Authentication Proxy"
  homepage "https://github.com/dinosaurjr10/jwtap"
  head 'https://github.com/dinosaurjr10/jwtap.git', branch: 'feature/build'
  url "https://github.com/dinosaurjr10/jwtap/archive/v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "updateme"

  depends_on 'wget'

  def install
    #system 'bin/install-ngx_mruby', prefix
    `bin/install-ngx_mruby #{prefix}`
    bin.install_symlink bin/'nginx' => 'jwtap'
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test jwtap`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
