require "simplecov"
require "simplecov-rcov"

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
end

require "yaml"
require "ruby_vcloud_sdk"
require "securerandom"

module VCloudSdk
  module Test
    class << self
      def logger
        log_file = VCloudSdk::Test.properties["log_file"]
        FileUtils.mkdir_p(File.dirname(log_file))
        logger = Logger.new(log_file)
        logger.level = Logger::DEBUG
        logger
      end

      def spec_asset(filename)
        File.expand_path(File.join(File.dirname(__FILE__), "assets", filename))
      end

      def test_configuration
        @test_config ||= YAML.load_file(spec_asset("test-config.yml"))
      end

      def properties
        test_configuration["properties"]
      end

      def get_vcd_settings
        vcds = properties["vcds"]
        fail "Invalid number of VCDs" unless vcds.size == 1
        vcds[0]
      end

      def vcd_settings
        @settings ||= get_vcd_settings
      end

      def verify_settings(obj, settings)
        settings.each do |instance_variable_name, target_value|
          instance_variable = obj.instance_variable_get(instance_variable_name)
          instance_variable.should == target_value
        end
      end

      def mock_connection(logger, url)
        VCloudSdk::Config.configure(logger: logger)

        rest_client = VCloudSdk::Mocks::RestClient.new(url)
        VCloudSdk::Connection::Connection.new(url, nil, nil, rest_client)
      end

      def mock_session(logger, url)
        time_limit_sec = {
          default: 3,
          delete_vapp_template: 120,
          delete_vapp: 3,
          delete_media: 120,
          instantiate_vapp_template: 300,
          power_on: 3,
          power_off: 3,
          undeploy: 3,
          process_descriptor_vapp_template: 300,
          http_request: 240,
          recompose_vapp: 3,
        }

        options = {}
        options[:time_limit_sec] = time_limit_sec
        # Note: need to run "mock_connection" first and then stub method "new"
        conn = VCloudSdk::Test.mock_connection(logger, url)
        VCloudSdk::Connection::Connection.stub(:new) { conn }
        VCloudSdk::Session.new(url, nil, nil, options)
      end

      def new_vapp(
          url,
          username,
          password,
          logger,
          catalog_name,
          vapp_template_name,
          vdc_name)
        return @new_vapp if @new_vapp
        client = VCloudSdk::Client.new(url, username, password, {}, logger)
        catalog = client.find_catalog_by_name(catalog_name)
        @new_vapp = catalog
                      .instantiate_vapp_template(
                         vapp_template_name,
                         vdc_name,
                         SecureRandom.uuid)
      end

      def safe_remove_vapp(vdc, vapp_name)
        if vapp_name
          begin
            vapp = vdc.find_vapp_by_name vapp_name
            vapp.delete
          rescue VCloudSdk::ObjectNotFoundError
          end
        end
      end
    end
  end

  module Xml
    class Wrapper
      def ==(other)
        @root.diff(other.node) do |change, node|
          # " " Means no difference, "+" means addition and "-" means deletion
          return false if change != " " && node.to_s.strip.length != 0
        end
        true
      end
    end
  end
end

module Kernel
  def with_thread_name(name)
    old_name = Thread.current[:name]
    Thread.current[:name] = name
    yield
  ensure
    Thread.current[:name] = old_name
  end
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true  # for RSpec-3

  c.after :all do
    FileUtils.rm_rf(File.dirname(VCloudSdk::Test.properties["log_file"]))
  end
end
