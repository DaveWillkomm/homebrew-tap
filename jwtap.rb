class Jwtap < Formula
  desc 'JSON Web Token Authentication Proxy'
  homepage 'https://github.com/DaveWillkomm/jwtap'
  head 'https://github.com/DaveWillkomm/jwtap.git'
  url 'https://github.com/DaveWillkomm/jwtap/archive/v1.1.0.tar.gz'
  sha256 '85543543ac67e0b8c9332a3ac3e5075a6c46a63fdeecb144723a672b74289421'

  depends_on 'openssl@1.1'
  depends_on 'pcre'
  depends_on 'wget' => :build

  def install
    ohai 'Building Nginx + ngx_mruby + mruby-jwt (this may take some time)'
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
    system 'bin/install-ngx_mruby'

    # Copy lib
    prefix.install Dir['lib']

    # Create needed directories
    mkpath var/'run/jwtap'
  end

  def caveats
    <<-HEREDOC.undent
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
