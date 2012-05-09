require_relative 'parser'
require_relative 'news'
class NewsParser < Parser
  def all_news=(v)
    @all_news = v
  end
  def all_news
    @all_news ||= []
  end

  def update_data
    get_news.each do |news|
      all_news << News.from_hash(
          {
            expire: Time.local(*(news.xpath('expire').children.text.split('-'))),
            publish: Time.local(*(news.xpath('publish').children.text.split('-'))),
            text: news.xpath('text').children.text,
            subject: news.xpath('subject').children.text,
            people: news.xpath('teacher').map{ |t| build_person(t.children.text) }
          }
        )
    end
    print "news: #{all_news.count}\n".blue
    save_all
  end
  def save_all
    all_news.each(&:save)
  end

private
  def get_news
    get_with_xpath('http://fi.cs.hm.edu/fi/rest/public/news.xml', './newslist/news') || []
  end
end
