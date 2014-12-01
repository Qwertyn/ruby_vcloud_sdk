module VCloudSdk
  module Xml
    class User < Wrapper
      def email
        get_nodes('EmailAddress').first.content
      end

      def role
        VCloudSdk::Role.new(@session, get_nodes('Role').first)
      end

      def to_hash
        { login: name,
          email: email,
          href_id: href_id }
      end
    end
  end
end
