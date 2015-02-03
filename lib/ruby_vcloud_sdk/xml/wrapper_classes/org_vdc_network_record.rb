module VCloudSdk
  module Xml
    class OrgVdcNetworkRecord < VCloudSdk::Xml::Network
      def to_hash
        {
            href_id: href_id,
            type: "VCloudOrgNetwork",
            dns1: @root["dns1"],
            dns2: @root["dns2"],
            gateway: @root["defauldGateway"],
            name: @root["name"],
            netmask: @root["netmask"],
            vdc_id: @root["vdc"].split('/')[-1]
        }
      end
    end
  end
end
