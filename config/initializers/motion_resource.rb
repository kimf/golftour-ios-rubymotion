module MotionResource
  class Base
    self.root_url = "http://api.golftour.dev/"
    self.logger = MotionSupport::NetworkLogger.new
  end
end
