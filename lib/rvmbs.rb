require "rvmbs/version"
require "optparse"
require "fileutils"
require "yaml"

module RVMBS

  module Command
  
    def self.run(args)
      
      options = {}
      optsp = nil

      load_config

      optparse = OptionParser.new do |opts|
        optsp = opts
        opts.banner = "RVM Bootstrap - Command to create a project directory with a configured .rvmrc into.

Usage: rvmbs -d <PROJECT_NAME> [options]"
        
        # This define the directory name.
        opts.on('-d', '--directory NAME', "The project's directory name.") do |name|
          options[:directory] = name
        end
         
        # This define the ruby implementation.
        options[:implementation] = @implementation
        opts.on('-i', '--ruby-implementation NAME', "The name of the Ruby implementation.") do |name|
          options[:implementation] = name
        end

        # This force to delete de directory if already exists. 
        options[:force] = false
        opts.on('-f', '--force', "Delete directory if already exists.") do 
          options[:force] = true
        end

        # Verbose mode 
        options[:verbose] = false
        opts.on('-v', '--verbose', "Print extra info.") do 
          options[:verbose] = true
        end

        # This will print an options summary.
        opts.on_tail("-h", "--help", "Show this message.") do
          puts opts
          exit
        end

      end

      begin
        optparse.parse!(args)
      rescue OptionParser::MissingArgument
        puts 'rvmbs: missing argument, -h for help'
        exit
      end

      # Directory must be set.
      if options[:directory] == nil
        puts optsp 
        exit
      else
        create_directory(options)
        create_rvmrc(options)
        set_rvmrc_trusted(options, Dir.pwd)
      end
    end

    # Load config from user home dir.
    def self.load_config
      config_path = File.expand_path('~/.rvmbsrc')
      config = YAML.load_file( config_path ) if File.exists? config_path
  
      # config values
      @implementation = config['implementation']  || '1.9.2'
    end

    # Creates the directory.
    def self.create_directory(options)
      puts "Making new directory: #{options[:directory]}" if options[:verbose]
      begin
        Dir.mkdir options[:directory]
      rescue 
        if options[:force] 
          FileUtils.rm_rf options[:directory]
          options[:force] = false
          retry 
        end
        puts "ERROR: directory already exists or cannot be created (try with --force)."
      end
    end
  
    # Creates the .rvmrc file.
    def self.create_rvmrc(options)  
      puts "Creating rvmrc file" if options[:verbose]
      Dir.chdir(options[:directory]) 
      File.open(".rvmrc", "w") do |f|
        f.write("rvm use --create #{options[:implementation]}@#{options[:directory]}\n")
      end
      Dir.chdir('..') 
    end

    # Run rvm rvmrc trust command detached from console.
    def self.set_rvmrc_trusted(options, current_dir)
      puts "Setting rvmrc file to trusted" if options[:verbose]
      pid = daemonize do 
        current_dir = current_dir + "/" + options[:directory] 
        exit system "rvm rvmrc trust #{current_dir}/"
      end
      _, status = Process.waitpid2(pid)
      puts "ERROR: rvm rvmrc trust command fail!" if status != 0
    end
    
    private 

    def self.daemonize
       pid = fork do
        if RUBY_VERSION < "1.9"
          exit if fork
          Process.setsid
          exit if fork
          Dir.chdir "/"
          STDIN.reopen "/dev/null"
          STDOUT.reopen "/dev/null", "a"
          STDERR.reopen "/dev/null", "a"
        else
          Process.daemon
        end
        yield
      end
    end

  end

end
