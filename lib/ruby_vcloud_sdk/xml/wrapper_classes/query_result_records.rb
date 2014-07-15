module VCloudSdk
  module Xml
    class QueryResultRecords < Wrapper
      # Reference: http://pubs.vmware.com/vcd-55/index.jsp?topic=%2Fcom.vmware.vcloud.api.reference.doc_55%2Fdoc%2Ftypes%2FQueryResultOrgVdcStorageProfileRecordType.html
      def org_vdc_storage_profile_records
        get_nodes("OrgVdcStorageProfileRecord")
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

      def vapp_link(name)
        get_nodes(XML_TYPE[:VAPPRECORD], { name: name }, true).first || get_nodes(XML_TYPE[:ADMINVAPPRECORD], { name: name }, true).first
      end
    end
  end
end
