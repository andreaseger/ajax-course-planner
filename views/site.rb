class CoursePlanner
  module Views
    class Site < Layout
      def api_url
        @api_url
      end
      def image
        ['y_u_no.jpg', 'not_sure.jpg'].sample
      end
    end
  end
end
