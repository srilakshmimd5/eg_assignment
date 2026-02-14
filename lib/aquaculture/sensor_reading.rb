# frozen_string_literal: true

# Represents a single sensor reading from an aquaculture tank
# Stores temperature, pH, and dissolved oxygen measurements
class SensorReading
  # Valid ranges for sensor inputs
  TEMP_MIN = -50.0
  TEMP_MAX = 60.0
  PH_MIN = 0.0
  PH_MAX = 14.0
  DO_MIN = 0.0

  attr_reader :temperature, :ph, :dissolved_oxygen

  # Raises ArgumentError if any value is invalid
  def initialize(temperature:, ph:, dissolved_oxygen:)
    validate_temperature!(temperature)
    validate_ph!(ph)
    validate_dissolved_oxygen!(dissolved_oxygen)

    @temperature = temperature
    @ph = ph
    @dissolved_oxygen = dissolved_oxygen
  end

  private

  # Validates temperature is within acceptable sensor range
  def validate_temperature!(value)
    return if value.is_a?(Numeric) && value >= TEMP_MIN && value <= TEMP_MAX

    raise ArgumentError, "Temperature must be between #{TEMP_MIN} and #{TEMP_MAX}, got #{value}"
  end

  # Validates pH is within acceptable range (0-14)
  def validate_ph!(value)
    return if value.is_a?(Numeric) && value >= PH_MIN && value <= PH_MAX

    raise ArgumentError, "pH must be between #{PH_MIN} and #{PH_MAX}, got #{value}"
  end

  # Validates dissolved oxygen is non-negative
  def validate_dissolved_oxygen!(value)
    return if value.is_a?(Numeric) && value >= DO_MIN

    raise ArgumentError, "Dissolved oxygen must be >= #{DO_MIN}, got #{value}"
  end
end
