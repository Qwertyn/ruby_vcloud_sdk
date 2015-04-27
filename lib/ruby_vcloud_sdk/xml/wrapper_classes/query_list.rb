module VCloudSdk
  module Xml
    class QueryList < Wrapper
      def vapps_query_list
        get_nodes(XML_TYPE[:LINK],
                  { type: MEDIA_TYPE[:RECORDS],
                    name: 'vApp' }).first || get_nodes(XML_TYPE[:LINK],
                                                       { type: MEDIA_TYPE[:RECORDS],
                                                         name: 'adminVApp' }).first
      end

      def roles_query_list
        get_nodes(XML_TYPE[:LINK], { type: MEDIA_TYPE[:RECORDS], name: 'role' }).first
      end

      def networks_query_list
        get_nodes(XML_TYPE[:LINK], { type: MEDIA_TYPE[:RECORDS], name: 'adminVAppNetwork' }).first
      end
    end
  end
end
