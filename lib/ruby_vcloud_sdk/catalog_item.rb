require_relative "session"
require_relative "infrastructure"

module VCloudSdk
  # Represents the calalog item in calalog.
  class CatalogItem
    include Infrastructure

    def initialize(session, link)
      @session = session
      @link = link
    end

    def to_hash
      { name: name,
        href_id: href_id,
        virtual_machines: virtual_machines }
    end

    def href_id
      @link.href_id
    end

    def name
      entity_xml.entity[:name]
    end

    def type
      entity_xml.entity[:type]
    end

    def href
      entity_xml.entity[:href]
    end

    def virtual_machines
      xml_vms = connection.get(href).get_nodes("Vm")
      xml_vms.map do |vm|
        disks = vm.hardware_section.hard_disks.map { |disk| disk.element_name }
        {identifier: vm.href_id, name: vm.name, disks: disks}
      end
    end
  end
end
