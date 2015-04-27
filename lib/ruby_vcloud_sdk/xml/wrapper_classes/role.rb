module VCloudSdk
  module Xml
    class Role < Wrapper
      def right_records
        get_nodes(XML_TYPE[:RIGHTREFERENCE],
                  { type: ADMIN_MEDIA_TYPE[:RIGHT] })
      end
    end
  end
end
