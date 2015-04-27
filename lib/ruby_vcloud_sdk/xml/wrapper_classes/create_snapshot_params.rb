module VCloudSdk
  module Xml
    class CreateSnapshotParams < Wrapper
      def memory=(flag)
        @root["memory"] = flag
      end

      def quiesce=(flag)
        @root["quiesce"] = flag
      end
    end
  end
end
