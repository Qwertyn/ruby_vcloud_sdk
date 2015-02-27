require_relative "infrastructure"
require_relative "ip_ranges"
require_relative "vdc"

module VCloudSdk
  class Network
    include Infrastructure
    extend Forwardable
    def_delegator :entity_xml, :name

    def initialize(session, link)
      @session = session
      @link = link
    end

    def to_hash
      {
        dns1: entity_xml.dns1.try(:content),
        dns2: entity_xml.dns2.try(:content),
        gateway: entity_xml.gateway.try(:content),
        netmask: entity_xml.netmask.try(:content),
        ranges: ip_ranges.try(:ranges).to_a,
        name: name,
        href_id: entity_xml.href_id,
        type: type,
        vdc_id: vdc_id
      }
    end

    def type
      entity_xml.type
    end

    def vdc_id
      entity_xml.vdc_link.href_id if type == 'OrgNetwork'
    end

    def href
      @link
    end

    def ip_ranges
      entity_xml
        .ip_scope
        .ip_ranges
        .ranges
        .reduce(IpRanges.new) do |result, i|
          result + IpRanges.new("#{i.start_address}-#{i.end_address}")
        end
    rescue
      nil
    end

    def href_id
      entity_xml.href_id
    end

    def allocated_ips
      allocated_addresses = connection.get(entity_xml.allocated_addresses_link)
      allocated_addresses.ip_addresses.map do |i|
        i.ip_address
      end
    end
  end
end
