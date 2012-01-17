require 'redis'
module Structure
  #TODO add redis lookup to these two methods
  def get_modul_label code
    from_redis = $redis.get "course:#{code}"
    unless from_redis
      label = get_with_xpath("http://fi.cs.hm.edu/fi/rest/public/modul/title/#{code}.xml", '/modul/name').first.text
      $redis.set "course:#{code}", label
      $redis.expire "course:#{code}", 60*60*24*10
    end
  end

  def get_teacher_name code
    from_redis = $redis.get "teacher:#{code}"
    unless from_redis
      person = get_with_xpath("http://fi.cs.hm.edu/fi/rest/public/person/name/#{code}.xml", '/person').first
      label = "#{person.xpath('title').text} #{person.xpath('firstname').text} #{person.xpath('lastname').text}"
      $redis.set "teacher:#{code}", label
      $redis.expire "teacher:#{code}", 60*60*24*10
    end
  end

  def build_room room
    {
      name: room,
      label: room.upcase.insert(2,'.'),
      building: room[0],
      floor: room[1]
    }
  end

  def build_course course
    {
      name: course,
      label: get_modul_label(course)
    }
  end

  def build_group group
    {
      name: group
    }
  end

  def build_teachers teacher
    {
      name: teacher,
      label: get_teacher_name(teacher)
    }
  end

  def build_timeslot day, stime, etime
    {
      start_minute: stime.split(':')[1].to_i,
      start_hour: stime.split(':')[0].to_i,
      end_minute: etime.split(':')[1].to_i,
      end_hour: etime.split(':')[0].to_i
    }
  end
end
