module VCloudSdk
  module Xml
    class RightRecord < Wrapper
      def to_hash
        { name: name,
          href_id: href_id }
      end
    end
  end
end
