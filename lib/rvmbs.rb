require "rvmbs/version"
require "optparse"

module RVMBS

  module Command
  
    def self.run(args)
      
      options = {}
      optparse = OptionParser.new do |opts|
        opts.banner = "Usage: rvmbs [options] PROJECT_NAME"
        
        opts.on('-d', '--directory NAME', "The name of the project's directory") do |name|
          options[:directory_name] = name
        end
         
        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

      end.parse!(args)
      
      if options.size < 1
        exec 'rvmbs -h'
      end

      Dir.mkdir(options[:directory_name])
      Dir.chdir(options[:directory_name])
      File.open(".rvmrc", "w") do |f|
        f.write("rvm use --create 1.9.2@#{options[:directory_name]}")
      end
      Dir.chdir('..')
      system "rvm rvmrc trust #{options[:directory_name]}"
    end

  end

end
