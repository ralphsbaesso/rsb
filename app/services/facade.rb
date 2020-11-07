class Facade < RuleBox::Facade

  def status_green?
    @status == :green
  end

end
