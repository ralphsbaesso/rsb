class Strategy::Labels::CheckAppToResources < Strategy

  def process
    apps = %w[bam book moment]
    app = bucket[:app].to_s

    unless apps.include? app.to_s
      add_error 'Precisa passar o "App" do recursos.'
      set_status :red
    end

  end
end