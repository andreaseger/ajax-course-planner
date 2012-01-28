class CoursePlanner
  module Views
    class Site < Layout
      def api_url
        @api_url
      end
      def group
        @group
      end
      def image
        'not_sure.jpg'
      end
    end
  end
end
