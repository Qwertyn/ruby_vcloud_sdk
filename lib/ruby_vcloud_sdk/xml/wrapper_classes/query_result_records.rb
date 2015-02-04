module VCloudSdk
  module Xml
    class QueryResultRecords < Wrapper
      # Reference: http://pubs.vmware.com/vcd-55/index.jsp?topic=%2Fcom.vmware.vcloud.api.reference.doc_55%2Fdoc%2Ftypes%2FQueryResultOrgVdcStorageProfileRecordType.html
      def org_vdc_storage_profile_records
        records = get_nodes("OrgVdcStorageProfileRecord")
        records.empty? ? get_nodes("AdminOrgVdcStorageProfileRecord") : records
      end

      def edge_gateway_records
        get_nodes("EdgeGatewayRecord")
      end

      def right_records
        get_nodes("RightRecord")
      end

      def vapps
        vapps = get_nodes(XML_TYPE[:VAPPRECORD])
        vapps.empty? ? get_nodes(XML_TYPE[:ADMINVAPPRECORD]) : vapps
      end

      def roles
        get_nodes(XML_TYPE[:ROLERECORD])
      end

      def networks
        get_nodes(XML_TYPE[:ADMINVAPPNETWORKRECORD])
      end

      def admin_vapp_network_records
        get_nodes(XML_TYPE[:ADMINVAPPNETWORKRECORD])
      end

      def external_networks
        get_nodes(XML_TYPE[:NETWORKRECORD])
      end

      def admin_org_network_records
        get_nodes(XML_TYPE[:ADMINORGNETWORKRECORD])
      end

      def vapp_link(name)
        get_nodes(XML_TYPE[:VAPPRECORD], { name: name }, true).first || get_nodes(XML_TYPE[:ADMINVAPPRECORD], { name: name }, true).first
      end
    end
  end
end
