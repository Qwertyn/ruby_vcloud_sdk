module VCloudSdk
  module Xml
    class AdminVAppNetworkRecord < VCloudSdk::Xml::Network
      def to_hash
        {
          id: id,
          type: "VCloudVappNetwork",
          dns1: @root["dns1"],
          dns2: @root["dns2"],
          gateway: @root["gateway"],
          name: @root["name"],
          netmask: @root["netmask"],

          org: @root["org"],
          vapp: @root["vApp"],
          vapp_name: @root["vappName"]
        }
      end
    end
  end
end
