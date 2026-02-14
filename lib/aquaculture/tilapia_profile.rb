# frozen_string_literal: true

require_relative 'species_profile'

# Tilapia-specific thresholds for water quality parameters
class TilapiaProfile < SpeciesProfile
  # Define safe water quality thresholds for tilapia
  def thresholds
    {
      temperature: { min: 25.0, max: 30.0 },
      ph: { min: 6.5, max: 9.0 },
      dissolved_oxygen: { min: 5.0 }
    }
  end
end
