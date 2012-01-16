require_relative 'parser'
class ExamParser < Parser
  def update_exams
    get_exams.each do |day|
      date = day.xpath('date').text
      day.xpath('time').each do |time|
        local_time = Time.local( *[ date.split('-') ,
                                    time.xpath('time').text.split(':')
                                  ].map(&:to_i) )
        time.xpath('examination').each do |e|
          exam = e.xpath('exam').first
          Exam.from_hash(
            {
              course: build_course(exam.xpath('modul')),
              examiner: exam.xpath('*[starts-with(name(.), "examiner")]').map {|t| build_teacher(t.text)},
              material: exam.xpath('material').text,
              type: exam.xpath('type').text,
              rooms: e.xpath('room').map {|r| build_room(r.text)},
              time: local_time,
            }
          ).save
        end
      end
    end
  end
private
  def get_exams
    get_with_xpath('http://fi.cs.hm.edu/fi/rest/public/exam/date.xml', '/examlist/day')
  end
end
