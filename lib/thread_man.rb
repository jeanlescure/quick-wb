module QuickWb
  class ThreadMan
    def help(*arg)
      puts ''
      puts 'Welcome to the Interactive Server Manager'
      puts ''
      puts 'Starting a server:'
      puts 'start [options]'
      puts '(\'start -h\' for more information about available options)'
      puts ''
      puts 'The following is a list of available commands:'
      puts ''
      COMMANDS.each do |command|
        puts " #{command}"
      end
    end

    def start(arg)
      $threads << Thread.new{
          begin
            $threads.last()[:server] = QuickWb::Server.new().start(arg)
            $threads.last()[:server].start if $threads.last()[:server].is_a? WEBrick::HTTPServer
          rescue Errno::EADDRINUSE => ex
            puts "\nERROR! Port already in use!"
          end
        }
      $threads.last().abort_on_exception = true
      $threads.last()[:description] = "#{$input.chomp} (#{Time.now().strftime("%Y/%m/%d %I:%M%p")})"
      puts 'Started new server thread successfully!'
      puts "\nid\t\tdescription\n#{$threads.length-1}\t\t#{$threads.last()[:description]}"
      puts "\n(tip: to change a thread's description simply run 'describe [id] [your description]')\n"
    end

    def list(*arg)
      id = 0
      puts "#{$threads.length} threads in memory\n\nid\t\tstatus\t\tdescription"
      $threads.each do |thread|
        puts "#{id}\t\t#{thread.status}\t\t#{thread[:description]}"
        id += 1
      end
    end

    def kill(*arg)
      args = arg[0]
      index = args[0].to_i
      
      if !$threads[index].nil?
        $threads[index][:server].shutdown
        Thread.kill($threads.delete($threads[index]))
      else
        puts "ERROR! Unable to kill thread with id: #{index}"
        puts '(Run "list" command to view running threads and their respective id numbers)'
      end
    end
    def killall(*arg)
      while $threads.length > 0
        kill 0
      end
    end

    def describe(*arg)
      args = arg[0]
      index = args.shift().to_i
      
      if !$threads[index].nil?
        $threads[index][:description] = args.join(' ')
      else
        puts "ERROR! No thread with id: #{index}"
        puts '(Run "list" command to view running threads and their respective id numbers)'
      end
    end
    
    def clear(*arg)
      print "\e[H\e[2J\r"
    end
    def cls(*arg)
      clear arg
    end
    
    def version(*arg)
      puts VERSION
    end
  end
end
