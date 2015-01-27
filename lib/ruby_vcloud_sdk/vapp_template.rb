require "forwardable"
require_relative "session"
require_relative "infrastructure"

module VCloudSdk
  class VappTemplate
    include Infrastructure

    extend Forwardable
    def_delegators :entity_xml, :catalog_item_link

    def initialize(session, link)
      @session = session
      @link = link
    end

    def catalog_item
      VCloudSdk::CatalogItem.new(@session, catalog_item_link)
    end
  end
end
