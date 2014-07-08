module VCloudSdk
  module Xml
    class QueryList < Wrapper
      def vapps_query_list
        get_nodes(XML_TYPE[:LINK],
                  { type: MEDIA_TYPE[:RECORDS],
                    name: 'vApp' }).first
      end
    end
  end
end
