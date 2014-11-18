module VCloudSdk

  class InternalDisk
    attr_reader :name, :capacity, :bus_type, :bus_sub_type, :storage_profile_link

    def initialize(entity_xml)
      @name = entity_xml.element_name
      @capacity = entity_xml.host_resource.attribute("capacity").to_s.to_i
      @bus_type = entity_xml.host_resource.attribute("busType").to_s
      @bus_sub_type = entity_xml.host_resource.attribute("busSubType").to_s
      @storage_profile_link = entity_xml.host_resource.attribute("storageProfileHref").value
    end

    def to_hash
      {
        name: name,
        capacity: capacity,
        bus_sub_type: bus_sub_type
      }
    end

    def storage_profile_id
      URI.parse(storage_profile_link).path.split('/')[-1]
    end
  end
end
