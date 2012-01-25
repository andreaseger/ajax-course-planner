class CoursePlanner
  module Views
    class Site < Layout
      def content
        "Welcome! Mustache lives."
      end
      def api_urls
        @api_urls
      end
    end
  end
end
