class CoursePlanner
  module Views
    class Site < Mustache
      def title
        "Coures Planner"
      end
      def pagename
        @pagename || "bookingslist"
      end
    end
  end
end
