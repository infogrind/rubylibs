require 'tmpdir'
require 'pathname'

module MK
    class Lockfile
        def initialize(fn)
            @lfpath = Pathname.new(Dir.tmpdir) + Pathname.new(fn)
        end

        def lock()

            # If there is already a valid lock file, stop here. 
            return false if @lfpath.exist? and is_running(@lfpath)

            # If there is a lock file and we have arrived at this point, the
            # lockfile corresponds to a process that is no longer running and we
            # can delete it.
            @lfpath.unlink if @lfpath.exist?

            create_lockfile()
            debug "Created lock file #@lfpath."
            return true
        end

        def unlock()
            @lfpath.unlink if @lfpath.exist?
            debug "Removed lock file #@lfpath."
        end

        private
        def create_lockfile
            pid = Process.pid
            open(@lfpath, 'w') do |fout|
                fout.puts("#{pid}")
            end
        end

        def is_running(file)
            pid = ""
            open(file, 'r') do |fin|
                pid = fin.gets or ""
            end
            pid.chomp!
            return false if pid == ""
            begin    
                pid_i = Integer(pid)
            rescue ArgumentError
                # Could not convert to integer, assuming the process is not
                # running.
                return false
            end

            return is_process_running(pid_i)
        end

        def is_process_running(pid)
            begin
                Process.kill 0, pid
                true
            rescue Errno::ESRCH
                false
            end
        end

    end
end

    if __FILE__ == $0
        puts "No tests at this point."
    end
