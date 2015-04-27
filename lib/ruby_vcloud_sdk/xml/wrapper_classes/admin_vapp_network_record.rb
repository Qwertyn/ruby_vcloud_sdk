module VCloudSdk
  module Xml
    class AdminVAppNetworkRecord < VCloudSdk::Xml::Network
      def to_hash
        {
          href_id: href_id,
          type: "VCloudVappNetwork",
          dns1: @root["dns1"],
          dns2: @root["dns2"],
          gateway: @root["gateway"],
          name: @root["name"],
          netmask: @root["netmask"],

          org: @root["org"].split('/')[-1],
          vapp_href_id: @root["vApp"].split('/')[-1],
          vapp_name: @root["vappName"]
        }
      end
    end
  end
end
