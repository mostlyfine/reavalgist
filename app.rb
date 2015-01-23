require 'open-uri'
require 'bundler'
Bundler.require

class RevealGist < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  helpers do
    def gist(id)
      gist = Oj.load(open("https://api.github.com/gists/#{id}").read)
      gist['files'].values[0]['content']
    end
  end

  get '/' do
    @markdown = gist('0088939f2326b07e9910')
    slim :reveal
  end

  get %r{/slides/?([\w]+)?} do |id|
    @markdown = id ? gist(id) : open(params[:url]).read
    slim :reveal
  end

end

