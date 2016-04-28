class Jwtap < Formula
  desc 'JSON Web Token Authentication Proxy'
  homepage 'https://github.com/dinosaurjr10/jwtap'
  head 'https://github.com/dinosaurjr10/jwtap.git'
  url 'https://github.com/dinosaurjr10/jwtap/archive/v0.1.0.tar.gz'
  sha256 '5217cddba4a2607a9f648bef68e09f371be641e808a67c920606bf9293372a17'

  depends_on 'openssl'
  depends_on 'wget'

  def install
    ohai 'Building Nginx + ngx_mruby + mruby-jwt (this may take some time)'
    openssl = Formula['openssl']
    ENV['NGINX_CONFIG_OPT_ENV'] = %W[
      --prefix=#{prefix}
      --with-cc-opt=-I#{openssl.include}
      --with-http_ssl_module
      --with-ld-opt=-L#{openssl.lib}
    ].join(' ')
    system 'bin/install-ngx_mruby'

    # Copy access handler
    lib.mkpath
    cp buildpath/'lib/jwtap/access_handler.rb', lib

    # Create symlink
    File.open sbin/'jwtap', 'w' do |f|
      f.write <<-HEREDOC.undent
        #!/usr/bin/env bash
        #{sbin/'nginx'} -p #{prefix} "$@"
      HEREDOC
    end
    (HOMEBREW_PREFIX/'bin').install_symlink sbin/'jwtap'
  end

  def post_install
    # Create the logs directory
    # Creating this in #install does not work as it is deleted at some later point
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
