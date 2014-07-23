module VCloudSdk
  module Xml

    class AdminOrg < Wrapper
      def vdc(name)
        get_nodes("Vdc", {"name"=>name}).first
      end

      def catalog(name)
        get_nodes("CatalogReference", {"name"=>name}).first
      end

      def users
        get_nodes("UserReference")
      end

      def vdcs
        get_nodes("Vdc")
      end

      def catalogs
        get_nodes("CatalogReference")
      end
    end
  end
end
