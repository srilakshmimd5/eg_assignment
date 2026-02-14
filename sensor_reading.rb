# sensor_reading.rb
# Simple implementation for aquaculture water quality monitoring

class SensorReading
  attr_reader :temperature, :ph, :dissolved_oxygen
  
  def initialize(temperature:, ph:, dissolved_oxygen:)
    @temperature = temperature
    @ph = ph
    @dissolved_oxygen = dissolved_oxygen
  end
end
