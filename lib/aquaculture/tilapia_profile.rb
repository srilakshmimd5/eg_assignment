# frozen_string_literal: true

require_relative 'species_profile'

# Tilapia-specific thresholds for water quality parameters
# Tilapia are warm-water fish requiring different conditions than salmon
class TilapiaProfile < SpeciesProfile
  # Define safe water quality thresholds for tilapia
  # 
  # @return [Hash] Thresholds with min/max values for each parameter
  def thresholds
    {
      temperature: { min: 25.0, max: 30.0 },
      ph: { min: 6.5, max: 9.0 },
      dissolved_oxygen: { min: 5.0 }
    }
  end
end
