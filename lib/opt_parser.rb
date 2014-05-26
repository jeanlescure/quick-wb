module QuickWb
  class OptParser
    def self.parse(args)
      options = OpenStruct.new
      options.directory = Dir::pwd
      options.port = 8080
      options.php = false
      options.phpdir = 'c:\php'
      options.help = false
      
      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Run a WEBrick server locally and serve any folder on any port of your choice, quickly and hassle-free.'
        
        if $interactive
          opts.banner = 'Usage: start [options]'
        else
          opts.banner = 'Usage: quick-wb interactive\nquick-wb [options]'
        end
        
        opts.separator 'The \'interactive\' command runs the server manager.'
        opts.separator '(Useful for managing multiple server instances on a single console)'

        opts.separator ''
        opts.separator 'Specific options:'
        
        opts.separator ''
        
        opts.on('-d', '--directory [path/to/dir]', 
          'This is the folder WEBrick will be serving as root.',
          "(default: #{options.directory})") do |d|
          options.directory = d
        end
        
        opts.separator ''
        
        opts.on('-p', '--port [1234]', Integer, 
        'This is the port WEBrick will be listening at for HTTP requests.',
        "(default: #{options.port})") do |p|
          options.port = p
        end
        
        opts.separator ''
        
        # Boolean switch.
        opts.on('--[no-]php', 'Serve files using a local installation of php.') do |p|
          options.php = p
        end
        
        opts.on('--phpdir [path/to/php/install/dir]', 
          'This is the folder where php is installed in your system.',
          "(default: #{options.phpdir})") do |pd|
          options.phpdir = pd
        end
        
        # Boolean switch.
        opts.on('-v', '--[no-]verbose', 'Run verbosely','(when verbose is off, a log file is created for this application, also one for each WEBrick instance)') do |v|
          $verbose = v
        end

        opts.separator ''
        opts.separator 'Common options:'
        
        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail('-h', '--help', 'Show this message') do
          options.help = true
          puts ''
          puts opts
          exit unless $interactive
          Thread.exit
        end

        # Another typical switch to print the version.
        opts.on_tail('--version', 'Show version') do
          options.help = true
          puts ''
          puts VERSION
          exit unless $interactive
          Thread.exit
        end
      end
      
      opt_parser.parse!(args)
      options
    end
  end
end
