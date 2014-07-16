module VCloudSdk
  module Xml
    class User < Wrapper
      def email
        get_nodes('EmailAddress').first.content
      end

      def role
        get_nodes('Role').first.name
      end

      def to_hash
        { login: name,
          email: email }
      end
    end
  end
end
