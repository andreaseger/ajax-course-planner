class CoursePlanner
  module Views
    class Layout < Mustache
      def title
        @title || "Coures Planner"
      end
    end
  end
end