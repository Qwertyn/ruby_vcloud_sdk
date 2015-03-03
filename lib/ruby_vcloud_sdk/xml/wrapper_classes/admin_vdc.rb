module VCloudSdk
  module Xml
    class AdminVdc < Wrapper
      def available_networks
        get_nodes("Network", type: ADMIN_MEDIA_TYPE[:ADMIN_NETWORK])
      end

      def to_hash
        {
          href_id: href_id,
          name: name
        }
      end
    end
  end
end
