class Strategy::Labels::UpdateResources < Strategy

  desc 'Atualiza dos recursos com os Labels passados'
  def process
    bucket[:resources].each do |resource|
      bucket[:labels].each do |label|
        label_ids = resource.labels.pluck(:id)

        if label.selected && !label_ids.include?(label.id)
          resource.labels << label
          resource.save!
        elsif !label.selected && label_ids.include?(label.id)
          resource.labels.delete(label)
        end

      end
    end
  end
end