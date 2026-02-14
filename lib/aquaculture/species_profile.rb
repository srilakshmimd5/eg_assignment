# frozen_string_literal: true

# Abstract base class for species-specific validation strategies
# Implements common validation logic, subclasses define thresholds
# Uses Strategy pattern to allow different species to have different validation rules
class SpeciesProfile
  # Subclasses must override this method to define species-specific thresholds
  #
  # @return [Hash] Hash with parameter names as keys and {min:, max:} values
  # @raise NotImplementedError if not overridden by subclass
  def thresholds
    raise NotImplementedError, "#{self.class} must implement thresholds method"
  end

  # Validate a sensor reading against this species' thresholds
  # Returns array of alert strings (empty if all parameters are safe)
  #
  # @param reading [SensorReading] The sensor reading to validate
  # @return [Array<String>] Array of alert messages (empty if all parameters safe)
  def validate(reading)
    alerts = []

    thresholds.each do |parameter, limits|
      value = reading.send(parameter)
      alerts.concat(check_parameter(parameter, value, limits))
    end

    alerts
  end

  private

  # Check a single parameter against its limits
  #
  # @param parameter [Symbol] The parameter name (e.g., :temperature, :ph)
  # @param value [Numeric] The actual value from the sensor reading
  # @param limits [Hash] Hash with :min and/or :max keys
  # @return [Array<String>] Array of alert messages for this parameter
  def check_parameter(parameter, value, limits)
    alerts = []

    if limits[:min] && value < limits[:min]
      alerts << format_alert(parameter, value, limits, :min)
    end

    if limits[:max] && value > limits[:max]
      alerts << format_alert(parameter, value, limits, :max)
    end

    alerts
  end

  # Format alert message with parameter details
  #
  # @param parameter [Symbol] The parameter name
  # @param value [Numeric] The actual value that violated threshold
  # @param limits [Hash] Hash with threshold values
  # @param threshold_type [Symbol] :min or :max
  # @return [String] Formatted alert message
  def format_alert(parameter, value, limits, threshold_type)
    param_name = humanize_parameter(parameter)
    unit = unit_for_parameter(parameter)
    limit_value = limits[threshold_type]
    threshold_name = threshold_type == :min ? "min" : "max"

    if threshold_type == :min
      "#{param_name} too low: #{value}#{unit} (#{threshold_name}: #{limit_value}#{unit})"
    else
      "#{param_name} too high: #{value}#{unit} (#{threshold_name}: #{limit_value}#{unit})"
    end
  end

  # Convert parameter name to human-readable format
  #
  # @param parameter [Symbol] The parameter name
  # @return [String] Human-readable parameter name
  def humanize_parameter(parameter)
    case parameter
    when :temperature
      "Temperature"
    when :ph
      "pH"
    when :dissolved_oxygen
      "Dissolved oxygen"
    else
      parameter.to_s.capitalize
    end
  end

  # Get appropriate unit for parameter
  #
  # @param parameter [Symbol] The parameter name
  # @return [String] Unit string for the parameter
  def unit_for_parameter(parameter)
    case parameter
    when :temperature
      "°C"
    when :ph
      ""
    when :dissolved_oxygen
      "mg/L"
    else
      ""
    end
  end
end
