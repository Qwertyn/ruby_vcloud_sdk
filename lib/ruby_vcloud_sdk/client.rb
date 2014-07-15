require_relative "query_list"
require_relative "organization"
require_relative "vdc"
require_relative "catalog"
require_relative "session"
require_relative "infrastructure"
require_relative "right_record"

module VCloudSdk

  class Client
    include Infrastructure

    VCLOUD_VERSION_NUMBER = "5.1"

    public :vdcs, :list_vdcs, :find_vdc_by_name, :catalogs,
           :list_catalogs, :catalog_exists?, :find_catalog_by_name,
           :vdc_exists?, :vapps, :list_vapps, :find_vapp_by_name,
           :vapp_exists?, :organizations

    def initialize(url, username, password, options = {}, logger = nil)
      @url = url
      Config.configure(logger: logger || Logger.new(STDOUT))

      @session = Session.new(url, username, password, options)
      Config.logger.info("Successfully connected.")
    end

    def create_catalog(name, description = "")
      catalog = Xml::WrapperFactory.create_instance("AdminCatalog")
      catalog.name = name
      catalog.description = description
      connection.post("/api/admin/org/#{@session.org.href_id}/catalogs",
                      catalog,
                      Xml::ADMIN_MEDIA_TYPE[:CATALOG])
      find_catalog_by_name name
    end

    def delete_catalog_by_name(name)
      catalog = find_catalog_by_name(name)
      catalog.delete_all_items
      connection.delete("/api/admin/catalog/#{catalog.id}")
      self
    end

    def right_records
      right_records = connection.get("/api/admin/rights/query").right_records

      right_records.map do |right_record|
        VCloudSdk::RightRecord.new(right_record)
      end
    end
  end

end
