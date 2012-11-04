require 'formula'

class X64ElfGdb < Formula
  homepage 'http://gcc.gnu.org'
  url 'http://ftp.gnu.org/gnu/gdb/gdb-7.5.tar.bz2'
  sha1 '79b61152813e5730fa670c89e5fc3c04b670b02c'

  depends_on 'x64-elf-binutils'
  depends_on 'x64-elf-gcc'

  def install
    ENV['CC'] = '/usr/local/bin/gcc-4.2'
    ENV['CXX'] = '/usr/local/bin/g++-4.2'
    ENV['CPP'] = '/usr/local/bin/cpp-4.2'
    ENV['LD'] = '/usr/local/bin/gcc-4.2'

    mkdir 'build' do
      system '../configure', '--target=x86_64-elf', "--prefix=#{prefix}"
      system 'make'
      system 'make install'
    end
  end
end
