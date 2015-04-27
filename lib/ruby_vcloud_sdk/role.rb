require "forwardable"
require_relative "infrastructure"

module VCloudSdk
  class Role
    include Infrastructure
    extend Forwardable

    def initialize(session, link)
      @session = session
      @link = link
    end

    def right_records
      entity_xml.right_records.map do |right_record_link|
        VCloudSdk::RightRecord.new(@session, right_record_link)
      end
    end

    def name
      @link.name
    end

    def href_id
      @link.href_id
    end

    def to_hash
      {name: name, href_id: href_id }
    end
  end
end
