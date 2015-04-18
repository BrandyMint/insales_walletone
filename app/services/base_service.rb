class BaseService
  attr_reader :success

  def call
    status = action()
    @success = !!status
    self
  end

  def success?
    @success
  end
end
