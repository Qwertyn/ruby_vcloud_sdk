module VCloudSdk

  class RightRecord
    attr_reader :name, :category

    def initialize(session, link)
      @session = session
      @link = link
    end

    def name
      @link.name
    end

    def href_id
      @link.href_id
    end

    def to_hash
      { name: name, href_id: href_id }
    end
  end
end
