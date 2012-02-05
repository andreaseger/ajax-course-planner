class CoursePlanner
  module Views
    class Layout < Mustache
      def title
        "Coures Planner"
      end
      def pagename
        @pagename || "bookingslist"
      end
    end
  end
end
