module VCloudSdk
  class Snapshot
    attr_reader :created, :powered_on, :size

    def initialize(snapshot_xml_obj)
      @snapshot_xml_obj = snapshot_xml_obj
      @created = @snapshot_xml_obj[:created]
      @powered_on = @snapshot_xml_obj[:poweredOn]
      @size = @snapshot_xml_obj[:size]
    end

    def to_hash
      {
        created_at: created,
        powered_on: powered_on,
        size:       size
      }
    end
  end
end
