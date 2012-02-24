require "rvmbs/version"
require "optparse"
require "fileutils"

module RVMBS

  module Command
  
    def self.run(args)
      
      options = {}
      optsp = nil

      optparse = OptionParser.new do |opts|
        optsp = opts
        opts.banner = "Usage: rvmbs [options] PROJECT_NAME"
        
        # This define the directory name.
        opts.on('-d', '--directory NAME', "The name of the project's directory.") do |name|
          options[:directory] = name
        end
         
        # This define the ruby interpreter.
        options[:ruby] = '1.9.2'
        opts.on('-r', '--ruby-implementation NAME', "The name of the Ruby implementation.") do |name|
          options[:ruby] = name
        end

        # This define the ruby interpreter.
        options[:force] = false
        opts.on('-f', '--force', "Delete directory if already exists.") do 
          options[:force] = true
        end

       # This will print an options summary.
        opts.on_tail("-h", "--help", "Show this message.") do
          puts opts
          exit
        end

      end.parse!(args)
      
      # Directory must be set.
      if options[:directory] == nil
        puts optsp
        exit
      end

      create_directory(options)
      create_rvmrc(options)
      set_rvmrc_trusted(options, Dir.pwd)
    end

    # Creates the directory.
    def self.create_directory(options)
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
      Dir.chdir(options[:directory])
      File.open(".rvmrc", "w") do |f|
        f.write("rvm use --create #{options[:ruby]}@#{options[:directory]}\n")
      end
      Dir.chdir('..')
    end

    # Run rvm rvmrc trust command detached from console.
    def self.set_rvmrc_trusted(options, current_dir)
      current_dir = 
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
        exit system "rvm rvmrc trust #{current_dir}/#{options[:directory]}/"
      end
      _, status = Process.waitpid2(pid)
      puts "ERROR: rvm rvmrc trust command fail!" if status != 0
    end

  end

end
