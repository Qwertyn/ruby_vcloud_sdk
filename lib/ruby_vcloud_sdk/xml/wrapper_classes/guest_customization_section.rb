# guest_customization_section
module VCloudSdk
  module Xml
    class GuestCustomizationSection < Wrapper
      def computer_name
        computer_name_node = get_nodes("ComputerName").first
        return if computer_name_node.nil?
        computer_name_node.content
      end
    end
  end
end
