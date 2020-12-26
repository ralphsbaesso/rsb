class Strategy::BAMTransactions::Analytic < Strategy

  def process
    puts :'okkk!!'
    pp bucket
    pp bucket.dig(:analytic)

    return unless bucket[:analytic]&.to_s == 'group'

    fields = bucket[:fields]

    puts :Ok

    # binding.pry


    self.data = self.data.group(*fields).sum(:price_cents)
  end

  def self.my_description
    <<~S
      Filtro para BAM::Transacion
    S
  end
end