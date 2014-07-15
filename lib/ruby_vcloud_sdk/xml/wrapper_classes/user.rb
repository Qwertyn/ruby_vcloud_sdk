module VCloudSdk
  module Xml
    class User < Wrapper
      def email
        get_nodes('EmailAddress').first.content
      end
    end
  end
end