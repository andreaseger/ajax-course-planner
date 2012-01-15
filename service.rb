class CoursePlanner < Sinatra::Base
  configure do |c|
    register Sinatra::Contrib
    register Sinatra::Flash
    register Mustache::Sinatra

    set :mustache, {
      templates: File.dirname(__FILE__) + '/templates',
      views: File.dirname(__FILE__) + '/views',
      namespace: CoursePlanner
    }

    set :public_folder, File.dirname(__FILE__) + '/public'
    enable :sessions
  end

  def database
    @database ||= Redis.new(REDIS_CONFIG)
  end

end
