module VCloudSdk
  module Xml
    class NetworkRecord < VCloudSdk::Xml::Network
      def to_hash
        {
          id: id,
          type: "VCloudExternalNetwork",
          dns1: @root["dns1"],
          dns2: @root["dns2"],
          gateway: @root["gateway"],
          name: @root["name"],
          netmask: @root["netmask"]
        }
      end
    end
  end
end