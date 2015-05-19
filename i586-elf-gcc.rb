require 'formula'

class I586ElfGcc < Formula
  homepage "http://gcc.gnu.org"
  url "http://ftpmirror.gnu.org/gcc/gcc-4.9.2/gcc-4.9.2.tar.bz2"
  mirror "ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.9.2/gcc-4.9.2.tar.bz2"
  sha1 "79dbcb09f44232822460d80b033c962c0237c6d8"

  depends_on 'gmp'
  depends_on 'libmpc'
  depends_on 'mpfr'
  depends_on 'i586-elf-binutils'
  depends_on 'cloog'
  depends_on 'isl'

  def install
    ENV.delete 'LD'
    # binutils = Formula.factory 'i586-elf-binutils'

    mkdir 'build' do
      system '../configure', '--disable-nls', '--target=i586-elf',
                             "--prefix=#{prefix}",
                             "--enable-languages=c",
                             "--with-gmp=#{Formula["gmp"].opt_prefix}",
                             "--with-mpc=#{Formula["mpc"].opt_prefix}",
                             "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
                             "--with-cloog=#{Formula["cloog"].opt_prefix}",
                             "--with-isl=#{Formula["isl"].opt_prefix}",
                             "--with-system-zlib",
                             "--disable-werror",
                             "--without-headers"
      system 'make all-gcc'
      system 'make install-gcc'
      FileUtils.ln_sf binutils.prefix/"i586-elf", prefix/"i586-elf"
      system 'make all-target-libgcc'
      system 'make install-target-libgcc'
      FileUtils.rm_rf share/"man"/"man7"
    end
  end
end
