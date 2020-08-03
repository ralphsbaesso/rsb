class Facade < RFacade

  def status_green?
    @status == :green
  end
end