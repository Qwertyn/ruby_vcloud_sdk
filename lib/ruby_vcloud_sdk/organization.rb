require "forwardable"
require_relative "infrastructure"

module VCloudSdk
  class Organization
    include Infrastructure

    extend Forwardable
    def_delegators :entity_xml, :name

    def initialize(session, link)
      @session = session
      @link = link
    end

    def id
      @link.href_id
    end

    def users
      admin_xml.users.map do |user_link|
        connection.get(user_link)
      end
    end

    def vdcs
      admin_xml.vdcs.map do |vdc_link|
        VCloudSdk::VDC.new(@session, vdc_link)
      end
    end


    def to_hash
      { :identifier => id,
        :label      => @link.name }
    end

    private

    def admin_xml
      admin_org_link = "/api/admin/org/#{id}"
      admin_org = connection.get(admin_org_link)

      unless admin_org
        fail ObjectNotFoundError,
             "Organization link #{admin_org_link} not available."
      end

      admin_org
    end
  end
end
