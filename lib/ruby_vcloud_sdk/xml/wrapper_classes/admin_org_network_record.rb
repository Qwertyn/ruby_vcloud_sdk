module VCloudSdk
  module Xml
    class AdminOrgNetworkRecord < VCloudSdk::Xml::Network
      def to_hash
        {
          id: id,
          type: "VCloudOrgNetwork",
          dns1: @root["dns1"],
          dns2: @root["dns2"],
          gateway: @root["gateway"],
          name: @root["name"],
          netmask: @root["netmask"],

          org: @root["org"],
          org_name: @root["orgName"]
        }
      end
    end
  end
end