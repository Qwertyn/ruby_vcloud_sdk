require_relative "query_list"
require_relative "organization"
require_relative "vdc"
require_relative "role"
require_relative "catalog"
require_relative "session"
require_relative "infrastructure"
require_relative "right_record"

module VCloudSdk

  class Client
    include Infrastructure

    VCLOUD_VERSION_NUMBER = "5.6"

    public :vdcs, :list_vdcs, :find_vdc_by_name, :catalogs,
           :list_catalogs, :catalog_exists?, :find_catalog_by_name,
           :vdc_exists?, :vapps, :list_vapps, :find_vapp_by_name,
           :vapp_exists?, :organizations, :roles, :entity

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
        VCloudSdk::RightRecord.new(@session, right_record)
      end
    end

    def query(type, page = 1, page_size = 25)
      connection.get("/api/query?type=#{type}&page=#{page}&pageSize=#{page_size}&format=records")
    end

    def hosts
      connection.get("/api/admin/extension/hostReferences")
    end

    def find_host_by_identifier(identifier)
      connection.get("/api/admin/extension/host/#{identifier}")
    end

    def general_settings
      settings = connection.get('/api/admin/extension/settings/general')
    end

    def vm_stats(id, start_time, end_time)
      stats = Xml::WrapperFactory.create_instance("HistoricUsageSpec")

      stats.add_child("AbsoluteStartTime")
      stats.get_nodes("AbsoluteStartTime")[0][:time] = start_time

      stats.add_child("AbsoluteEndTime")
      stats.get_nodes("AbsoluteEndTime")[0][:time] = end_time

      stats.add_child("MetricPattern")
      stats.get_nodes("MetricPattern").last.content = "cpu.*"
      stats.add_child("MetricPattern")
      stats.get_nodes("MetricPattern").last.content = "disk.*"
      stats.add_child("MetricPattern")
      stats.get_nodes("MetricPattern").last.content = "mem.*"

      connection.post("/api/vApp/#{id}/metrics/historic", stats)
    end

    def vm(id)
      vm = connection.get("/api/vApp/#{id}")
      VCloudSdk::VM.new(@session, vm.href)
    end

    def vapp(id)
      vapp = connection.get("/api/vApp/#{id}")
      VCloudSdk::VApp.new(@session, vapp)
    end
  end
end
