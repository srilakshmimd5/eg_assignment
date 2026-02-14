# frozen_string_literal: true

require_relative 'species_profile'

# Salmon-specific thresholds for water quality parameters
class SalmonProfile < SpeciesProfile
  # Define safe water quality thresholds for salmon
  def thresholds
    {
      temperature: { min: 12.0, max: 18.0 },
      ph: { min: 6.5, max: 8.5 },
      dissolved_oxygen: { min: 7.0 }
    }
  end
end
