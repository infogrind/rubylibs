# Usage

Clone this repository into a directory `mk` under your Ruby library directory. This is something like `/usr/local/lib/ruby` or (on OS X) `~/Library/Ruby/Site`. (Hint: Use `ruby -e 'puts $:'` to find out the directories that are on your Ruby installation's library path.)

## lockfile

This library allows you to create a lock file to prevent a Ruby script from
concurrently running in more than one instance.

Sample usage to create a lockfile:

    require 'mk/lockfile'
    
    lock = MK::Lockfile.new('myscript.lock') # You can provide any name for the lockfile
    unless lock.lock()
        debug "There is already an instance running, stopping."
        exit(1)
    end
    
    begin
        
        # Your code here
        
    ensure
        lock.unlock()
    end

## tempdir

With this library you can create your own temporary subdirector in the system temporary directory. After you are done using it, it will be deleted.

Use it inside a block:

    require 'mk/tempdir'
    
    TempDir.open() do |tmpdir|
        # here you can use the variable tmpdir as the temporary directory, such as
        # foofile = tmpdir + Pathname.new("foo.txt")
        
    end  # Here the directory tmpdir will automatically be deleted.
