module VCloudSdk
  class NIC
    extend Forwardable

    def_delegators :@entity_xml,
                   :ip_address, :is_connected, :mac_address,
                   :ip_address_allocation_mode, :network, :element_name

    attr_reader :is_primary

    def initialize(entity_xml, is_primary, vm)
      @entity_xml = entity_xml
      @is_primary = is_primary
      @vm = vm
    end

    def network_connection_index
      @entity_xml.nic_index.to_i
    end

    def network_name
      @entity_xml.network
    end

    def network
      @vm.vapp.find_network_by_name(@entity_xml.network)
    end

    def to_hash
      {
        name: element_name,
        mac_address: mac_address,
        ip_address: ip_address,
        network_identifier: network.try(:href_id),
        is_primary: is_primary,
        is_connected: is_connected
      }
    end

    alias_method :nic_index, :network_connection_index
  end
end
