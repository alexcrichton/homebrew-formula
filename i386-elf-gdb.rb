require 'formula'

class I386ElfGdb < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftp.gnu.org/gnu/gdb/gdb-7.6.tar.bz2'
  sha1 'b64095579a20e011beeaa5b264fe23a9606ee40f'

  depends_on 'i386-elf-binutils'
  depends_on 'i386-elf-gcc'

  def install
    mkdir 'build' do
      system '../configure', '--target=i386-elf', "--prefix=#{prefix}", '--disable-werror'
      system 'make'
      system 'make install'
      FileUtils.rm_rf share/"locale"
      FileUtils.mv lib, libexec
    end
  end
end
