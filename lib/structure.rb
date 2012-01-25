require 'redis'
module Structure
  def get_modul_label code
    label = $redis.get "course:#{code}"
    unless label
      label = get_with_xpath("http://fi.cs.hm.edu/fi/rest/public/modul/title/#{code}.xml", '/modul/name').first.text
      $redis.set "course:#{code}", label
      $redis.expire "course:#{code}", 60*60*24*10
    end
    return label
  end

  def get_person_name code
    label = $redis.get "people:#{code}"
    unless label
      person = get_with_xpath("http://fi.cs.hm.edu/fi/rest/public/person/name/#{code}.xml", '/person').first
      label = [ person.xpath('title').text, person.xpath('firstname').text, person.xpath('lastname').text ].delete_if{|e| e.empty? }.join ' '
      $redis.set "people:#{code}", label
      $redis.expire "people:#{code}", 60*60*24*10
    end
    return label
  end

  def build_room room
    return nil if room.empty?
    {
      name: room,
      label: room.upcase.insert(2,'.'),
      building: room[0],
      floor: room[1]
    }
  end

  def build_course course
    return nil if course.empty?
    {
      name: course,
      label: get_modul_label(course)
    }
  end

  def build_group group
    return nil if group.empty?
    { name: group }
  end

  def build_person person
    return nil if person.empty?
    {
      name: person,
      label: get_person_name(person)
    }
  end

  def build_timeslot day, stime, etime
    stimes = stime.split(':').map(&:to_i)
    etimes = etime.split(':').map(&:to_i)
    {
      start_minute: stimes[1],
      start_hour: stimes[0],
      length: ( etimes[0] - stimes[0] ) * 60 + ( etimes[1] - stimes[1] ),
      day: get_day(day)
    }
  end
  def get_day id
    case id
    when 'mo'
      { name: 'mo', label: 'Montag' }
    when 'di'
      { name: 'di', label: 'Dienstag' }
    when 'mi'
      { name: 'mi', label: 'Mittwoch' }
    when 'do'
      { name: 'do', label: 'Donnerstag' }
    when 'fr'
      { name: 'fr', label: 'Freitag' }
    end
  end
end
