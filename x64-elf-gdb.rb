require 'formula'

class X64ElfGdb < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftp.gnu.org/gnu/gdb/gdb-7.6.tar.bz2'
  sha1 'b64095579a20e011beeaa5b264fe23a9606ee40f'

  depends_on 'x64-elf-binutils'
  depends_on 'x64-elf-gcc'

  def install
    mkdir 'build' do
      system '../configure', '--target=x86_64-pc-linux', "--prefix=#{prefix}",'--disable-werror',
      system 'make'
      system 'make install'
      FileUtils.rm_rf share/"locale"
      FileUtils.mv lib, libexec
    end
  end

  def patches
    # When debugging 64-bit kernels via qemu, gdb has a tough time on the switch
    # to long mode, and this patch helps it out by making sure that gdb keeps up
    # with the switches in architecture that qemu makes
    DATA
  end
end

__END__
diff --git a/gdb/remote.c b/gdb/remote.c
index 1c9367d..5940ce2 100644
--- a/gdb/remote.c
+++ b/gdb/remote.c
@@ -5957,8 +5957,18 @@ process_g_packet (struct regcache *regcache)
   buf_len = strlen (rs->buf);

   /* Further sanity checks, with knowledge of the architecture.  */
-  if (buf_len > 2 * rsa->sizeof_g_packet)
-    error (_("Remote 'g' packet reply is too long: %s"), rs->buf);
+  if (buf_len > 2 * rsa->sizeof_g_packet) {
+    rsa->sizeof_g_packet = buf_len;
+    for (i = 0; i < gdbarch_num_regs (gdbarch); i++) {
+      if (rsa->regs[i].pnum == -1)
+        continue;
+      if (rsa->regs[i].offset >= rsa->sizeof_g_packet)
+        rsa->regs[i].in_g_packet = 0;
+      else
+        rsa->regs[i].in_g_packet = 1;
+    }
+  }
+

   /* Save the size of the packet sent to us by the target.  It is used
      as a heuristic when determining the max size of packets that the
