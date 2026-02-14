# frozen_string_literal: true

# Main orchestrator for water quality validation. Uses a species profile strategy to check readings
class WaterQualityChecker
  # @param species_profile [SpeciesProfile] The profile to use for validation
  def initialize(species_profile)
    @species_profile = species_profile
  end

  # Check if a sensor reading is safe for this species
  # Returns array of alert messages (empty if all parameters are safe)
  #
  # @param reading [SensorReading] The sensor reading to check
  # @return [Array<String>] Array of alert messages (empty if safe)
  def check(reading)
    @species_profile.validate(reading)
  end
end
