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

  # Initialize with sensor measurements
  # Raises ArgumentError if any value is invalid
  #
  # @param temperature [Float] Temperature in degrees Celsius
  # @param ph [Float] pH level (0-14 scale)
  # @param dissolved_oxygen [Float] Dissolved oxygen in mg/L
  # @raise ArgumentError if any parameter is outside valid range
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
  #
  # @param value [Numeric] Temperature value to validate
  # @raise ArgumentError if temperature is invalid
  def validate_temperature!(value)
    return if value.is_a?(Numeric) && value >= TEMP_MIN && value <= TEMP_MAX

    raise ArgumentError, "Temperature must be between #{TEMP_MIN} and #{TEMP_MAX}, got #{value}"
  end

  # Validates pH is within acceptable range (0-14)
  #
  # @param value [Numeric] pH value to validate
  # @raise ArgumentError if pH is invalid
  def validate_ph!(value)
    return if value.is_a?(Numeric) && value >= PH_MIN && value <= PH_MAX

    raise ArgumentError, "pH must be between #{PH_MIN} and #{PH_MAX}, got #{value}"
  end

  # Validates dissolved oxygen is non-negative
  #
  # @param value [Numeric] Dissolved oxygen value to validate
  # @raise ArgumentError if dissolved oxygen is invalid
  def validate_dissolved_oxygen!(value)
    return if value.is_a?(Numeric) && value >= DO_MIN

    raise ArgumentError, "Dissolved oxygen must be >= #{DO_MIN}, got #{value}"
  end
end
