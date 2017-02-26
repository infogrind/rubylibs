#!/usr/bin/ruby

require 'fileutils'
require 'tmpdir'
require 'pathname'

class TempDir
    def TempDir::open()
        # 1) Make temporary directory
        tmp = Pathname.new(Dir.tmpdir())
        tmpdir = tmp + Pathname.new(rand_string())
        FileUtils.mkdir(tmpdir, :mode => 0700)

        # 2) Pass the temporary directory to the block
        begin
            yield(tmpdir)
        rescue StandardError
            raise
        ensure
            # 3) Remove the temporary directory
            FileUtils.rm_r(tmpdir, :force => true)
        end
    end

    def TempDir::rand_string()
        (0...12).map{'a'.ord.+(rand(26)).chr}.join()
    end
end

def test()
    TempDir.open() do |tmpdir|
        puts "Playing around in the directory #{tmpdir}"
        open(tmpdir + Pathname.new("foo.txt"), "w") do |file|
            file.write("Hello, world")
        end

        puts "Reading file:"
        open(tmpdir + Pathname.new("foo.txt"), "r") do |file|
            puts file.read
        end
    end
end
