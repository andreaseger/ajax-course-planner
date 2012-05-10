class CoursePlanner
  module Views
    class Site < Mustache
      include Assets::Helper
      def title
        "Coures Planner"
      end
      def pagename
        @pagename || "bookingslist"
      end
      def ga_site_id
        ENV['PLANNER_GA_ID']
      end
      def show_ga
        ENV[:RACK_ENV] == 'production'
      end
      def stylesheets_tag
        %{<link href="#{asset_path 'application.css'}" media="screen, projection" rel="stylesheet" type="text/css" />}
      end

      def javascripts_tag
        %{<script src="#{asset_path 'application.js'}"></script>}
      end
    end
  end
end
