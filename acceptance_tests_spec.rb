# Acceptance Test Suite for Aquaculture Assessment
# This file tests ANY candidate implementation that follows the interface

require 'rspec'

# Load candidate's implementation
# Candidates should create a main file that requires all their classes
# For example: require_relative './lib/aquaculture'
# Or individually: require_relative './sensor_reading'
# 
# If your implementation is in lib/aquaculture, uncomment:
# require_relative './lib/aquaculture'
#
# If your implementation is in root directory, uncomment:
require_relative './sensor_reading'
require_relative './salmon_profile'
require_relative './tilapia_profile'
require_relative './water_quality_checker'

RSpec.describe 'Aquaculture Water Quality System - Acceptance Tests' do
  # These tests will work with any implementation that follows the interface
  
  before(:all) do
    # In real usage, you'd require the candidate's solution here
    # require './lib/candidate_solution'
    
    # For this example, we'll define the expected interface
    puts "\n" + "="*80
    puts "AQUACULTURE ASSESSMENT - AUTOMATED ACCEPTANCE TESTS"
    puts "="*80
    puts "\nThese tests validate that your implementation:"
    puts "  ✓ Accepts sensor readings"
    puts "  ✓ Validates against species thresholds"
    puts "  ✓ Returns appropriate alerts"
    puts "  ✓ Supports multiple species"
    puts "\n" + "="*80 + "\n\n"
  end
  
  # Helper method to create readings from sensor data
  def create_reading(data)
    # Candidates should have a SensorReading class or similar
    # This will need to match their implementation
    SensorReading.new(
      temperature: data[:temperature],
      ph: data[:ph],
      dissolved_oxygen: data[:dissolved_oxygen]
    )
  end
  
  def create_checker(species)
    # Candidates should have a way to create checkers for different species
    # This will need to match their implementation
    case species
    when :salmon
      WaterQualityChecker.new(SalmonProfile.new)
    when :tilapia
      WaterQualityChecker.new(TilapiaProfile.new)
    else
      raise "Unknown species: #{species}"
    end
  end
  
  describe 'Scenario 1: Normal Operations' do
    context 'Salmon tank with optimal conditions' do
      let(:sensor_data) do
        {
          temperature: 15.0,
          ph: 7.5,
          dissolved_oxygen: 8.0
        }
      end
      
      it 'returns no alerts when all parameters are within safe range' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts).to be_empty, 
          "Expected no alerts for optimal conditions, got: #{alerts.inspect}"
      end
    end
    
    context 'Tilapia tank with optimal conditions' do
      let(:sensor_data) do
        {
          temperature: 27.0,
          ph: 7.8,
          dissolved_oxygen: 6.5
        }
      end
      
      it 'returns no alerts when all parameters are within safe range' do
        reading = create_reading(sensor_data)
        checker = create_checker(:tilapia)
        alerts = checker.check(reading)
        
        expect(alerts).to be_empty,
          "Expected no alerts for optimal conditions, got: #{alerts.inspect}"
      end
    end
  end
  
  describe 'Scenario 2: Single Parameter Violations' do
    context 'Salmon: Temperature too high' do
      let(:sensor_data) do
        {
          temperature: 22.0,  # Max is 18.0
          ph: 7.5,
          dissolved_oxygen: 8.0
        }
      end
      
      it 'generates temperature alert' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts).not_to be_empty, "Expected alerts but got none"
        expect(alerts.length).to eq(1), "Expected 1 alert, got #{alerts.length}"
        
        alert_text = alerts.first.downcase
        expect(alert_text).to include('temperature'),
          "Alert should mention 'temperature', got: #{alerts.first}"
        expect(alert_text).to match(/high|above|exceed/),
          "Alert should indicate temperature is too high, got: #{alerts.first}"
      end
    end
    
    context 'Salmon: Temperature too low' do
      let(:sensor_data) do
        {
          temperature: 10.0,  # Min is 12.0
          ph: 7.5,
          dissolved_oxygen: 8.0
        }
      end
      
      it 'generates temperature alert' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts).not_to be_empty
        expect(alerts.length).to eq(1)
        
        alert_text = alerts.first.downcase
        expect(alert_text).to include('temperature')
        expect(alert_text).to match(/low|below/),
          "Alert should indicate temperature is too low, got: #{alerts.first}"
      end
    end
    
    context 'Salmon: pH too high' do
      let(:sensor_data) do
        {
          temperature: 15.0,
          ph: 9.5,  # Max is 8.5
          dissolved_oxygen: 8.0
        }
      end
      
      it 'generates pH alert' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts).not_to be_empty
        expect(alerts.length).to eq(1)
        expect(alerts.first.downcase).to include('ph')
      end
    end
    
    context 'Salmon: pH too low' do
      let(:sensor_data) do
        {
          temperature: 15.0,
          ph: 6.0,  # Min is 6.5
          dissolved_oxygen: 8.0
        }
      end
      
      it 'generates pH alert' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts).not_to be_empty
        expect(alerts.length).to eq(1)
        expect(alerts.first.downcase).to include('ph')
      end
    end
    
    context 'Salmon: Dissolved oxygen too low' do
      let(:sensor_data) do
        {
          temperature: 15.0,
          ph: 7.5,
          dissolved_oxygen: 5.0  # Min is 7.0
        }
      end
      
      it 'generates dissolved oxygen alert' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts).not_to be_empty
        expect(alerts.length).to eq(1)
        expect(alerts.first.downcase).to match(/dissolved.?oxygen|do|oxygen/)
      end
    end
  end
  
  describe 'Scenario 3: Multiple Violations' do
    context 'Salmon: Everything is wrong' do
      let(:sensor_data) do
        {
          temperature: 22.0,  # Too high
          ph: 9.5,            # Too high
          dissolved_oxygen: 4.0  # Too low
        }
      end
      
      it 'generates alerts for all violated parameters' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts.length).to eq(3),
          "Expected 3 alerts (temp, pH, DO), got #{alerts.length}: #{alerts.inspect}"
        
        all_alerts_text = alerts.join(' ').downcase
        expect(all_alerts_text).to include('temperature')
        expect(all_alerts_text).to include('ph')
        expect(all_alerts_text).to match(/dissolved.?oxygen|oxygen/)
      end
    end
    
    context 'Salmon: Two parameters violated' do
      let(:sensor_data) do
        {
          temperature: 22.0,  # Too high
          ph: 7.5,            # OK
          dissolved_oxygen: 5.0  # Too low
        }
      end
      
      it 'generates alerts for both violated parameters' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts.length).to eq(2),
          "Expected 2 alerts, got #{alerts.length}"
      end
    end
  end
  
  describe 'Scenario 4: Species-Specific Thresholds' do
    context 'Reading that is safe for Tilapia but dangerous for Salmon' do
      let(:sensor_data) do
        {
          temperature: 28.0,  # Good for Tilapia (25-30), bad for Salmon (12-18)
          ph: 8.0,
          dissolved_oxygen: 6.0  # Good for Tilapia (>5), bad for Salmon (>7)
        }
      end
      
      it 'generates alerts for salmon' do
        reading = create_reading(sensor_data)
        salmon_checker = create_checker(:salmon)
        salmon_alerts = salmon_checker.check(reading)
        
        expect(salmon_alerts.length).to eq(2),
          "Expected alerts for temperature and DO for salmon, got: #{salmon_alerts.inspect}"
      end
      
      it 'generates no alerts for tilapia' do
        reading = create_reading(sensor_data)
        tilapia_checker = create_checker(:tilapia)
        tilapia_alerts = tilapia_checker.check(reading)
        
        expect(tilapia_alerts).to be_empty,
          "Expected no alerts for tilapia, got: #{tilapia_alerts.inspect}"
      end
    end
    
    context 'Reading that is safe for Salmon but dangerous for Tilapia' do
      let(:sensor_data) do
        {
          temperature: 15.0,  # Good for Salmon (12-18), bad for Tilapia (25-30)
          ph: 7.5,
          dissolved_oxygen: 8.0
        }
      end
      
      it 'generates no alerts for salmon' do
        reading = create_reading(sensor_data)
        salmon_checker = create_checker(:salmon)
        salmon_alerts = salmon_checker.check(reading)
        
        expect(salmon_alerts).to be_empty
      end
      
      it 'generates temperature alert for tilapia' do
        reading = create_reading(sensor_data)
        tilapia_checker = create_checker(:tilapia)
        tilapia_alerts = tilapia_checker.check(reading)
        
        expect(tilapia_alerts).not_to be_empty
        expect(tilapia_alerts.first.downcase).to include('temperature')
      end
    end
  end
  
  describe 'Scenario 5: Edge Cases' do
    context 'Salmon: Exactly at minimum threshold' do
      let(:sensor_data) do
        {
          temperature: 12.0,  # Exactly at min
          ph: 6.5,            # Exactly at min
          dissolved_oxygen: 7.0  # Exactly at min
        }
      end
      
      it 'should not generate alerts (boundary is inclusive)' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts).to be_empty,
          "Expected no alerts at minimum thresholds, got: #{alerts.inspect}"
      end
    end
    
    context 'Salmon: Exactly at maximum threshold' do
      let(:sensor_data) do
        {
          temperature: 18.0,  # Exactly at max
          ph: 8.5,            # Exactly at max
          dissolved_oxygen: 8.0
        }
      end
      
      it 'should not generate alerts (boundary is inclusive)' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts).to be_empty,
          "Expected no alerts at maximum thresholds, got: #{alerts.inspect}"
      end
    end
    
    context 'Salmon: Just beyond threshold' do
      let(:sensor_data) do
        {
          temperature: 18.1,  # Just over max
          ph: 7.5,
          dissolved_oxygen: 8.0
        }
      end
      
      it 'should generate alert' do
        reading = create_reading(sensor_data)
        checker = create_checker(:salmon)
        alerts = checker.check(reading)
        
        expect(alerts).not_to be_empty,
          "Expected alert when exceeding threshold by 0.1"
      end
    end
  end
  
  describe 'Scenario 6: Real-World Sensor Data Stream' do
    let(:salmon_checker) { create_checker(:salmon) }
    
    # Simulating a day of sensor readings (every 5 minutes = 288 readings/day)
    # We'll test a few critical moments
    
    context 'Morning: Normal operations' do
      it 'processes multiple normal readings without alerts' do
        readings_data = [
          { temperature: 14.5, ph: 7.3, dissolved_oxygen: 8.2 },
          { temperature: 14.8, ph: 7.4, dissolved_oxygen: 8.1 },
          { temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0 },
        ]
        
        readings_data.each do |data|
          reading = create_reading(data)
          alerts = salmon_checker.check(reading)
          expect(alerts).to be_empty
        end
      end
    end
    
    context 'Afternoon: Equipment malfunction causing temperature spike' do
      it 'detects the problem as it develops' do
        readings_data = [
          { temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0 },  # Normal
          { temperature: 17.0, ph: 7.5, dissolved_oxygen: 8.0 },  # Rising but OK
          { temperature: 19.0, ph: 7.5, dissolved_oxygen: 7.8 },  # ALERT!
          { temperature: 21.0, ph: 7.5, dissolved_oxygen: 7.5 },  # ALERT!
        ]
        
        alerts_by_reading = readings_data.map do |data|
          reading = create_reading(data)
          salmon_checker.check(reading)
        end
        
        # First two should be fine
        expect(alerts_by_reading[0]).to be_empty
        expect(alerts_by_reading[1]).to be_empty
        
        # Last two should have alerts
        expect(alerts_by_reading[2]).not_to be_empty
        expect(alerts_by_reading[3]).not_to be_empty
      end
    end
    
    context 'Night: Multiple systems failing' do
      it 'detects cascading failures' do
        reading_data = {
          temperature: 22.0,     # Heater stuck on
          ph: 9.2,               # Alkalinity problem
          dissolved_oxygen: 4.5  # Aerator failed
        }
        
        reading = create_reading(reading_data)
        alerts = salmon_checker.check(reading)
        
        expect(alerts.length).to eq(3),
          "Expected alerts for all 3 parameters in critical situation"
        
        # This is an emergency - all three life support systems failing
        puts "\n⚠️  EMERGENCY SCENARIO DETECTED:"
        alerts.each { |alert| puts "   #{alert}" }
      end
    end
  end
  
  describe 'Implementation Quality Checks' do
    it 'returns alerts as an array' do
      reading = create_reading(temperature: 22.0, ph: 7.5, dissolved_oxygen: 8.0)
      checker = create_checker(:salmon)
      alerts = checker.check(reading)
      
      expect(alerts).to be_a(Array),
        "check() method should return an Array, got #{alerts.class}"
    end
    
    it 'returns empty array (not nil) when no violations' do
      reading = create_reading(temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0)
      checker = create_checker(:salmon)
      alerts = checker.check(reading)
      
      expect(alerts).to eq([]),
        "check() should return empty array, not nil, when no violations"
    end
    
    it 'returns string messages in alerts' do
      reading = create_reading(temperature: 22.0, ph: 7.5, dissolved_oxygen: 8.0)
      checker = create_checker(:salmon)
      alerts = checker.check(reading)
      
      expect(alerts.first).to be_a(String),
        "Alert messages should be strings, got #{alerts.first.class}"
      expect(alerts.first.length).to be > 10,
        "Alert messages should be descriptive (>10 chars), got: '#{alerts.first}'"
    end
  end
end

# Summary Report Generator
RSpec.configure do |config|
  config.after(:suite) do
    puts "\n" + "="*80
    puts "ACCEPTANCE TEST SUMMARY"
    puts "="*80
    puts "\nThese tests validate that your implementation correctly:"
    puts "  ✓ Handles normal sensor readings"
    puts "  ✓ Detects single parameter violations"
    puts "  ✓ Detects multiple simultaneous violations"
    puts "  ✓ Applies species-specific thresholds"
    puts "  ✓ Handles edge cases (boundary values)"
    puts "  ✓ Processes realistic sensor data streams"
    puts "\nIf all tests pass, your solution meets the requirements!"
    puts "="*80 + "\n"
  end
end
