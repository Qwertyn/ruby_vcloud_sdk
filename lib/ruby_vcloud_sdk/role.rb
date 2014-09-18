require "forwardable"
require_relative "infrastructure"

module VCloudSdk
  class Role
    include Infrastructure
    extend Forwardable

    def_delegator :entity_xml, :right_records

    def initialize(session, link)
      @session = session
      @link = link
    end

    def name
      @link.name
    end
  end
end
