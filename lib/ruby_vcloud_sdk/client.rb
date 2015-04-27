require_relative "query_list"
require_relative "organization"
require_relative "vdc"
require_relative "role"
require_relative "catalog"
require_relative "session"
require_relative "infrastructure"
require_relative "right_record"
require_relative "vapp_template"

module VCloudSdk

  class Client
    include Infrastructure

    VCLOUD_VERSION_NUMBER = '5.1' # '5.6' TODO transfer when initializing the client

    public :vdcs, :list_vdcs, :find_vdc_by_name, :catalogs,
           :list_catalogs, :catalog_exists?, :find_catalog_by_name,
           :vdc_exists?, :vapps, :list_vapps, :find_vapp_by_name,
           :vapp_exists?, :organizations, :roles, :networks

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

    def user(id)
      connection.get("/api/admin/user/#{id}")
    end

    def org(id)
      org = connection.get("/api/org/#{id}")
      VCloudSdk::Organization.new(@session, org)
    end

    def vm(id)
      vm = connection.get("/api/vApp/#{id}")
      VCloudSdk::VM.new(@session, vm.href)
    end

    def vapp(id)
      vapp = connection.get("/api/vApp/#{id}")
      VCloudSdk::VApp.new(@session, vapp)
    end

    def find_vapps_by_vdc_name(vdc_name)
      vapps = connection.get("/api/admin/extension/vapps/query?format=records&filter=vdcName==#{vdc_name}").vapps
      vapps.map { |vapp| VCloudSdk::VApp.new(@session, vapp) }
    end

    def catalog(id)
      catalog = connection.get("/api/admin/catalog/#{id}")
      VCloudSdk::Catalog.new(@session, catalog)
    end

    def vapp_template(id)
      vapp_template = connection.get("/api/vAppTemplate/#{id}")
      VCloudSdk::VappTemplate.new(@session, vapp_template)
    end

    def network(id)
      network = connection.get("/api/network/#{id}")
      VCloudSdk::Network.new(@session, network.href)
    end

    def edge_gateway(id)
      edge_gateway = connection.get("/api/admin/edgeGateway/#{id}")
      VCloudSdk::EdgeGateway.new(@session, edge_gateway)
    end

    def entity(urn)
      connection.get("/api/entity/#{urn}")
    end

    def storage_policy(id)
      connection.get("/api/vdcStorageProfile/#{id}")
    end

    def get_vsphere_credentials
      servers_list = Hash.from_xml(connection.get('/api/admin/extension/vimServerReferences').to_s)
      links = Array.wrap(servers_list['VMWVimServerReferences']['VimServerReference']).map do |server|
        server['href']
      end

      links.map do |href|
        vcenter = Hash.from_xml(connection.get(href).to_s)['VimServer']

        {
          name: vcenter['name'],
          url: vcenter['Url'],
          login: vcenter['Username'],
          password: ''
        }
      end
    end

    def generate_network_config(network_name)
      VCloudSdk::NetworkConfig.new(network_name)
    end
  end
end
