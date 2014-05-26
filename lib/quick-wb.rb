require_relative 'safe-require'
require_relative 'opt_parser'
require_relative 'thread_man'
require_relative 'quick-wb/version'

safe_require 'optparse'
safe_require 'ostruct'
safe_require 'webrick'
require_relative 'handlers/php'

COMMANDS = ['help','start','list','kill','killall','describe','clear','cls','version']
$threads = []

module QuickWb
  class Logger
    def initialize()
      @log_file = 'main.log'
      file = File.open(@log_file, 'w+')
      file.write ''
      file.close
    end
    def log(msg)
      unless $verbose
        file = File.open(@log_file, 'a+')
        file.puts msg
        file.close
      end
      puts msg if $verbose
    end
  end

  class Server
    def start(arg)
      options = OptParser.parse(arg)
      unless options.help
      
        server_params = {
            :Port=>options.port,
            :DocumentRoot=>options.directory,
          }
        
        unless $verbose
          log_file = File.open("#{File.basename(options.directory)}.log", 'a+')
        
          log = WEBrick::Log.new(log_file)
          server_params[:Logger] = log
          
          access_log = [
            [log_file, WEBrick::AccessLog::COMBINED_LOG_FORMAT]
          ]
          
          server_params[:AccessLog] = access_log
        end
        
        if options.php
          server_params[:PHPPath] = options.phpdir
          server_params[:DirectoryIndex] = ["index.php", "index.html", "index.htm", "index.cgi", "index.rhtml"]
        end
        
        server = WEBrick::HTTPServer.new(server_params)
        $logger.log "Starting server: http://#{Socket.gethostname}:#{options.port}"
        $logger.log "Serving folder: #{options.directory}"
        
        if options.php
          server.mount("/", WEBrick::HTTPServlet::FileHandler, options.directory,
          {:FancyIndexing => true, :HandlerTable => {"php" => WEBrick::HTTPServlet::PHPHandler}})
          $logger.log "PHP Handling Activated"
          $logger.log "Handling files using php installation at: #{options.phpdir}"
        end
        
        server
      end
    end
    def interactive
      print 'quick-wb> '
      tm = ThreadMan.new
      trap("INT"){ 
        tm.killall
        puts $ciao_msg
        sleep 0.1 while $threads.length > 0
        exit
      }
      while ARGF.gets
        $threads.each do |thread| 
          Thread.kill($threads.delete(thread)) if thread.status == false
        end
        $input = $_
        input_arr = $input.split(' ')
        command = input_arr.shift
        
        if command == 'exit'
          puts $ciao_msg
          exit
        end
        if COMMANDS.include? command
          tm.method(command).call(input_arr)
        elsif !command.nil?
          puts "Unknown command: #{command}"
        end
        
        print 'quick-wb> '
      end
    end
  end
end
