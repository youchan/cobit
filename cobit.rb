require "rubygems"
require "sinatra"
require "sinatra/cometio"
require "fssm"
require "redcarpet"

path = ARGV[0]

renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

Thread.new do
  FSSM.monitor(File.dirname(path), File.basename(path)) do
    update do|base, file|
      open(path) do |f|
        md = renderer.render(f.read)
        puts "push: #{md}"
        CometIO.push :markdown, { :content => md }
      end
    end
    create do|base, file|
      puts "CREATE: #{base} #{file}"
    end
    delete do|base, file|
      puts "DELETE: #{base} #{file}"
    end
  end
end

CometIO.on :connect do |session|
  puts "new client <#{session}>"
end

get "/" do
  open(path) do |f|
    @markdown = renderer.render(f.read)
  end
  erb :index
end 

