require "forwardable"
require_relative "infrastructure"

module VCloudSdk
  class QueryList
    include Infrastructure

    extend Forwardable
    def_delegators :entity_xml,
                   :name, :upload_link, :upload_media_link,
                   :instantiate_vapp_template_link

    def initialize(session, link)
      @session = session
      @link = link
    end


    def vapps
      entity_xml.vapps
    end
  end
end
