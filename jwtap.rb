class Jwtap < Formula
  desc 'JSON Web Token Authentication Proxy'
  homepage 'https://github.com/DaveWillkomm/jwtap'
  head 'https://github.com/DaveWillkomm/jwtap.git'
  url 'https://github.com/DaveWillkomm/jwtap/archive/v1.2.0-homebrew.tar.gz'
  sha256 '50f0408a20c7f481f25c22a634b76933cc9424a1c1138ffbbb8f084e99966899'

  # Install without Superenv because it removes the -I flag specified by NGX_MRUBY_CFLAGS.
  # See https://stackoverflow.com/a/22260944/6130964 and http://www.rubydoc.info/github/Homebrew/brew/Superenv.
  env :std

  # See #caveats
  #depends_on 'openssl'

  depends_on 'pcre'
  depends_on 'wget' => :build

  def install
    ohai 'Building Nginx + ngx_mruby + mruby-jwt (this may take some time)'

    # See #caveats
    system 'brew install openssl'

    openssl = Formula['openssl']
    ENV['NGINX_CONFIG_OPT_ENV'] = %W[
      --build=jwtap
      --conf-path=#{etc}/jwtap/jwtap.conf
      --error-log-path=#{var}/log/jwtap/error.log
      --http-client-body-temp-path=#{var}/run/jwtap/client_body_temp
      --http-fastcgi-temp-path=#{var}/run/jwtap/fastcgi_temp
      --http-log-path=#{var}/log/jwtap/access.log
      --http-proxy-temp-path=#{var}/run/jwtap/proxy_temp
      --http-scgi-temp-path=#{var}/run/jwtap/scgi_temp
      --http-uwsgi-temp-path=#{var}/run/jwtap/uwsgi_temp
      --lock-path=#{var}/run/jwtap.lock
      --pid-path=#{var}/run/jwtap.pid
      --prefix=#{prefix}
      --sbin-path=#{bin}/jwtap
      --with-cc-opt=-I#{openssl.include}
      --with-http_ssl_module
      --with-ld-opt=-L#{openssl.lib}
    ].join(' ')
    ENV['NGX_MRUBY_CFLAGS'] = "-I#{openssl.include}"
    ENV['NGX_MRUBY_LDFLAGS'] = "-L#{openssl.lib} -lcrypto"
    system 'bin/install_ngx_mruby.sh'

    # Copy lib
    prefix.install Dir['lib']

    # Create needed directories
    mkpath var/'run/jwtap'
  end

  def caveats
    <<-HEREDOC.undent
      NOTE: This formula depends on openssl and wget; however, because wget depends on openssl@1.1, this formula cannot
            declare its dependency on openssl as Homebrew claims it is a circular dependency. Because of this,
            brew install openssl is executed during installation.

      Access handler path: #{lib}/jwtap.rb
      Multi-path directive path: #{lib}/mruby_directive_paths.rb
      Edit the config: #{etc}/jwtap/jwtap.conf
      Start the app: jwtap
    HEREDOC
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
    system 'false'
  end
end
