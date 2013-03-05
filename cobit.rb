require "rubygems"
require "sinatra"
require "sinatra/cometio"
require "fssm"
require "redcarpet"

class Cobit
  attr_accessor :path

  def initialize
    @path = "data/README.md"
    @renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    Thread.new do
      FSSM.monitor("data", "*") do
        update do|base, file|
          puts "UPDATE: #{base} #{file}"
          push
          if File.basename(@path) == file then
          end
        end
        create do|base, file|
          @path = file
          push
        end
        delete do|base, file|
          puts "DELETE: #{base} #{file}"
        end
      end
    end
  end

  def connect(session)
    @session = session
  end
  
  def push
    #files = Dir::entries("data")
    #CometIO.push :chat, { :content => render, :files => files }, { :to => @session }
    CometIO.push :cobit, { :content => render }
  end

  def render
    @renderer.render(File.read(@path))
  end
end

cobit = Cobit.new

CometIO.on :connect do |session|
  puts "new client <#{session}>"
  cobit.connect session
end

get "/" do
  @markdown = cobit.render
  erb :index
end 


