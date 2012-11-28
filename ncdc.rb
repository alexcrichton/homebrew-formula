require 'formula'

class Ncdc < Formula
  homepage 'http://dev.yorhel.nl/ncdc'
  url 'http://dev.yorhel.nl/download/ncdc-1.13.tar.gz'
  sha1 'e919dfcf9ff11d48dd133cbd7709ebd317666295'
  head 'https://github.com/yorhel/ncdc.git'

  depends_on 'glib'
  depends_on 'libffi'
  depends_on 'gnutls'
  depends_on 'sqlite'
  depends_on 'gettext'
  depends_on 'autoconf' => :build if ARGV.build_head?

  def patches
    DATA
  end

  def install
    system "autoreconf -i" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/src/dl.c
+++ b/src/dl.c
@@ -131,7 +131,7 @@ struct dl_t {

 // Minimum filesize for which we request TTHL data. If a file is smaller than
 // this, the TTHL data would simply add more overhead than it is worth.
-#define DL_MINTTHLSIZE (2048*1024)
+#define DL_MINTTHLSIZE G_GUINT64_CONSTANT(2251799813685248)
 // Minimum TTHL block size we're interested in. If we get better granularity
 // than this, blocks will be combined to reduce the TTHL data.
 #define DL_MINBLOCKSIZE (1024*1024)
