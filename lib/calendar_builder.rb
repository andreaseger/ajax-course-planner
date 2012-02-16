class CalendarBuilder
  attr_accessor events

  LINELENGTH = 75

  def header
    #TODO
  end

  def ensure_linelength(text)
    #TODO
    string
  end

  def build_event(event)
    #TODO
  end
  def print
    ensure_linelength(self.header + self.events.reduce(""){|a,e| a << build_event(e) } )
  end
end
