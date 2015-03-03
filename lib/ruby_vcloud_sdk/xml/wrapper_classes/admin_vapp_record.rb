module VCloudSdk
  module Xml
    class AdminVAppRecord < Wrapper
      def to_hash
        { :href_id               => href_id,
          :org_id                => org_id,
          :name                  => name,
          :status                => status,
          :owner_name            => owner_name,
          :number_of_vms         => number_of_vms,
          :cpu_allocation_mhz    => cpu_allocation_mhz,
          :cpu_allocation_in_mhz => cpu_allocation_in_mhz,
          :number_of_cpus        => number_of_cpus,
          :memory_allocation_mb  => memory_allocation_mb }
      end
    end
  end
end
