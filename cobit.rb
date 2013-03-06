require "rubygems"
require "sinatra"
require "sinatra/cometio"
require "fssm"
require "redcarpet"

#set :cometio, :timeout => 60

class Cobit

  class Renderer
    attr_accessor :path
 
    def initialize
      @path = "data/README.md"
      @redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    end
 
    def connect(session)
      @@instance.session = session
    end
    
    def render(path)
      @path = path
      render
    end

    def render
      content = @redcarpet.render(File.read(@path))
      #puts content
      #CometIO.push :cobit, { :content => content }
    end
  end

  @@renderer = Renderer.new
  @@session = ""

  def self.start
    EM.defer do
      FSSM.monitor("data", "*") do
        update do|base, file|
          puts "UPDATE: #{base} #{file}"
          #@@renderer.render
          CometIO.push :cobit, { :content => @@renderer.render }
        end
        create do|base, file|
          CometIO.push :cobit, { :content => @@renderer.render(file) }
        end
        delete do|base, file|
          puts "DELETE: #{base} #{file}"
        end
      end
    end
  end

  def self.connect(session)
    @@session = session
  end

  def self.get_session
    @@session
  end

  def self.render
            @@renderer.render
  end
end

Cobit.start

get "/" do
  @markdown = Cobit.render
  @filelist = Dir.entries("data").select {|f| File.extname(f) == ".md"}
  erb :index
end 
