class CoursePlanner
  module Views
    class Schedule < Layout
      def data
        @data.to_json
      end
    end
  end
end

