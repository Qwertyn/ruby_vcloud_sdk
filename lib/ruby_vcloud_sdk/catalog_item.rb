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

    def catalog
      VCloudSdk::Catalog.new(@session, entity_xml.catalog_link)
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
        disks = vm.hardware_section.hard_disks.map { |disk| Hash[:label, disk.element_name, :capacity, disk.vcloud_capacity_mb] }
        {
          identifier: vm.href_id,
          name: vm.name,
          disks: disks,
          cpus: vm.hardware_section.cpu.get_rasd("VirtualQuantity").content,
          cores_per_socket: vm.hardware_section.cpu.get_vmw("CoresPerSocket").content,
          memory: vm.hardware_section.memory.get_rasd("VirtualQuantity").content
        }
      end
    end
  end
end
