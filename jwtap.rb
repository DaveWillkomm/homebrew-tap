class Jwtap < Formula
  desc 'JSON Web Token Authentication Proxy'
  homepage 'https://github.com/dinosaurjr10/jwtap'
  head 'https://github.com/dinosaurjr10/jwtap.git'
  url 'https://github.com/dinosaurjr10/jwtap/archive/v0.4.0.tar.gz'
  sha256 '9b8c4a85fe980dbb02eef313fdd74656388297aecf52aa09c238c266926b40e0'

  depends_on 'openssl'
  depends_on 'wget'

  skip_clean 'logs'

  def install
    ohai 'Building Nginx + ngx_mruby + mruby-jwt (this may take some time)'
    openssl = Formula['openssl']
    ENV['NGINX_CONFIG_OPT_ENV'] = %W[
      --prefix=#{prefix}
      --sbin-path=#{libexec/'nginx'}
      --with-cc-opt=-I#{openssl.include}
      --with-http_ssl_module
      --with-ld-opt=-L#{openssl.lib}
    ].join(' ')
    system 'bin/install-ngx_mruby'

    # Create a symlink
    bin.mkpath
    bin.install_symlink libexec/'nginx' => bin/'jwtap'

    # Copy the access handler
    lib.mkpath
    cp buildpath/'lib/jwtap/access_handler.rb', lib

    # Create the logs directory
    (prefix/'logs').mkpath
  end

  def caveats
    <<-HEREDOC.undent
      Access handler path: #{lib}/access_handler.rb
      Edit the config:     #{prefix}/conf/nginx.conf
      Start the app:       jwtap
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
