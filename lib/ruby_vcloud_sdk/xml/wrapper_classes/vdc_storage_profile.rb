module VCloudSdk
  module Xml

    class VdcStorageProfile < Wrapper
      def name
        @root["name"]
      end

      def name=(value)
        @root["name"] = value
      end

      def href
        @root["href"]
      end
    end

  end
end
