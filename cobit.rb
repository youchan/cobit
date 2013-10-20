require "rubygems"
require "sinatra"
require "sinatra/cometio"
require "fssm"
require "redcarpet"
require "qiita"

#set :cometio, :timeout => 60

class Cobit

  class Renderer
    attr_accessor :path
 
    def initialize
      @title = "README"
      @redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    end
 
    def connect(session)
      @@instance.session = session
    end
    
    def open(title)
      @title = title
      CometIO.push :cobit, { :content => render, :title => @title }
    end

    def path
      "data/#{@title}.md"
    end

    def content
      if File.exist? path
        File.read(path)
      else
        ""
      end
    end

    def render
      @redcarpet.render(content)
    end
  end

  @@renderer = Renderer.new
  @@session = ""
  @@qiita = nil

  def self.start
    token = File.read(".token") if File.exist? ".token"
    @@qiita = Qiita.new token: token
    EM.defer do
      FSSM.monitor("data", "*") do
        update do|base, file|
          puts "UPDATE: #{base} #{file}"
          #@@renderer.render
          if (file == File.basename(@@renderer.path))
            CometIO.push :cobit, { :content => @@renderer.render }
          end
        end
        create do|base, file|
          puts "CREATE: #{base} #{file}"
          CometIO.push :filelist, { :type => "add", :filename => file }
        end
        delete do|base, file|
          puts "DELETE: #{base} #{file}"
          CometIO.push :filelist, { :type => "remove", :filename => file }
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

  def self.content
    @@renderer.content
  end

  def self.render
    @@renderer.render
  end

  def self.open(title)
    @@renderer.open title
  end

  def self.upload(title)
    puts "upload: #{title}"
    @@qiita.post_item title: title, body: Cobit.content, tags: [], private: false
  end
end

Cobit.start

get "/" do
  @markdown = Cobit.render
  @filelist = Dir.entries("data").select {|f| File.extname(f) == ".md"}
  erb :index
end 

get "/open/:title" do
  Cobit.open params[:title]
end

get "/upload/:title" do
  Cobit.upload params[:title]
  ""
end

