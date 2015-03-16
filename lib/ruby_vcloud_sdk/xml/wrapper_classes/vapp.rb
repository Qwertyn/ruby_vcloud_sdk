module VCloudSdk
  module Xml
    class VApp < Wrapper
      def description
        get_nodes("Description").first.content
      end

      def networks
        get_nodes(XML_TYPE[:LINK], type: MEDIA_TYPE[:VAPP_NETWORK])
      end

      def network_config_section
        get_nodes("NetworkConfigSection").first
      end

      def reboot_link
        get_nodes("Link", {"rel" => "power:reboot"}, true).first
      end

      def tasks
        get_nodes(XML_TYPE[:TASK])
      end

      def discard_state
        get_nodes("Link", {"rel" => "discardState"}, true).first
      end

      def recompose_vapp_link
        link = get_nodes(XML_TYPE[:LINK],
                         { rel: "recompose" },
                         true).first
      end

      def vdc_link
        get_nodes(XML_TYPE[:LINK],
                  { type: MEDIA_TYPE[:VDC] },
                  true).first
      end

      def vms
        get_nodes("Vm")
      end

      def vm(name)
        get_nodes("Vm", name: name).first
      end

      def owner_identifier
        get_nodes('User').first.try(:href_id)
      end

      def to_hash
        { :href_id          => href_id,
          :vdc_href_id      => vdc_link.href_id,
          :name             => name,
          :owner_identifier => owner_identifier }
      end
    end
  end
end
