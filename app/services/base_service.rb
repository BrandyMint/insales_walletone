class BaseService
  def call
    self.action()
    self
  end
end
