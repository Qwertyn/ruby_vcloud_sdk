module VCloudSdk
  module Xml

    class GeneralSettings < Wrapper
      def console_proxy_external_address
        get_nodes("ConsoleProxyExternalAddress", nil, false, VMEXT_NAMESPACE).first.content
      end
    end

  end
end
