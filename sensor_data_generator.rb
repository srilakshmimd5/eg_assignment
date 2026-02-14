# Test Data Generator for Aquaculture Assessment
# Generates realistic sensor reading scenarios

require 'json'
require 'csv'

class SensorDataGenerator
  # Generate various test scenarios
  def self.generate_all_scenarios
    scenarios = {
      normal_operations: generate_normal_operations,
      temperature_spike: generate_temperature_spike,
      oxygen_depletion: generate_oxygen_depletion,
      ph_drift: generate_ph_drift,
      multiple_failures: generate_multiple_failures,
      species_comparison: generate_species_comparison,
      edge_cases: generate_edge_cases,
      daily_cycle: generate_daily_cycle
    }
    
    scenarios
  end
  
  # Scenario 1: Normal operations - everything is fine
  def self.generate_normal_operations
    {
      name: "Normal Operations - Salmon Tank",
      description: "24 hours of normal sensor readings. All parameters within safe range.",
      species: "salmon",
      readings: (0..287).map do |i|
        {
          timestamp: timestamp_for_minute(i * 5),
          temperature: 14.0 + rand(-1.0..1.0),
          ph: 7.5 + rand(-0.2..0.2),
          dissolved_oxygen: 8.0 + rand(-0.5..0.5)
        }
      end,
      expected_alerts: 0
    }
  end
  
  # Scenario 2: Heater malfunction causes temperature spike
  def self.generate_temperature_spike
    readings = []
    
    # Normal for 2 hours
    (0..23).each do |i|
      readings << {
        timestamp: timestamp_for_minute(i * 5),
        temperature: 15.0,
        ph: 7.5,
        dissolved_oxygen: 8.0
      }
    end
    
    # Temperature starts rising (heater stuck on)
    (24..35).each do |i|
      temp = 15.0 + ((i - 24) * 0.5)  # Rises 0.5°C every 5 min
      readings << {
        timestamp: timestamp_for_minute(i * 5),
        temperature: temp,
        ph: 7.5,
        dissolved_oxygen: 8.0
      }
    end
    
    # Stays dangerously high
    (36..47).each do |i|
      readings << {
        timestamp: timestamp_for_minute(i * 5),
        temperature: 21.0,
        ph: 7.5,
        dissolved_oxygen: 8.0
      }
    end
    
    {
      name: "Equipment Failure - Temperature Spike",
      description: "Heater malfunction causes dangerous temperature rise over 1 hour",
      species: "salmon",
      readings: readings,
      expected_alerts: 24,  # Should alert starting from reading 30 onward
      alert_starts_at: 30
    }
  end
  
  # Scenario 3: Aerator failure causes oxygen depletion
  def self.generate_oxygen_depletion
    readings = []
    
    # Normal operations
    (0..23).each do |i|
      readings << {
        timestamp: timestamp_for_minute(i * 5),
        temperature: 15.0,
        ph: 7.5,
        dissolved_oxygen: 8.0
      }
    end
    
    # Aerator fails, DO drops rapidly
    (24..47).each do |i|
      do_value = [8.0 - ((i - 24) * 0.2), 4.0].max  # Drops to 4.0
      readings << {
        timestamp: timestamp_for_minute(i * 5),
        temperature: 15.0,
        ph: 7.5,
        dissolved_oxygen: do_value
      }
    end
    
    {
      name: "Aerator Failure - Oxygen Depletion",
      description: "Aerator stops working, dissolved oxygen drops dangerously low",
      species: "salmon",
      readings: readings,
      expected_alerts: 19,  # Starts alerting when DO < 7.0
      critical_threshold: 7.0
    }
  end
  
  # Scenario 4: pH buffer exhausted, pH drifts high
  def self.generate_ph_drift
    readings = []
    
    (0..95).each do |i|
      # pH slowly drifts upward over 8 hours
      ph_value = 7.5 + (i * 0.02)  # Increases by 0.02 per reading
      readings << {
        timestamp: timestamp_for_minute(i * 5),
        temperature: 15.0,
        ph: [ph_value, 10.0].min,
        dissolved_oxygen: 8.0
      }
    end
    
    {
      name: "Buffer Exhaustion - pH Drift",
      description: "pH buffer depleted, pH slowly drifts to dangerous levels",
      species: "salmon",
      readings: readings,
      expected_alerts: 46,  # Alerts when pH > 8.5
      alert_starts_at: 50
    }
  end
  
  # Scenario 5: Catastrophic failure - everything fails at once
  def self.generate_multiple_failures
    readings = []
    
    # Normal for 1 hour
    (0..11).each do |i|
      readings << {
        timestamp: timestamp_for_minute(i * 5),
        temperature: 15.0,
        ph: 7.5,
        dissolved_oxygen: 8.0
      }
    end
    
    # DISASTER: Power failure, all systems down
    (12..23).each do |i|
      readings << {
        timestamp: timestamp_for_minute(i * 5),
        temperature: 10.0 + rand(-1.0..1.0),  # No heater, temp drops
        ph: 9.0 + rand(-0.2..0.2),            # pH spikes
        dissolved_oxygen: 3.0 + rand(-0.5..0.5)  # No aerator, DO crashes
      }
    end
    
    {
      name: "Catastrophic Failure - All Systems Down",
      description: "Power failure causes all life support systems to fail",
      species: "salmon",
      readings: readings,
      expected_alerts: 12,  # Every reading after failure has 3 alerts
      emergency: true
    }
  end
  
  # Scenario 6: Same readings, different species
  def self.generate_species_comparison
    readings = [
      { timestamp: "2026-02-10T10:00:00Z", temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0 },
      { timestamp: "2026-02-10T10:05:00Z", temperature: 28.0, ph: 8.0, dissolved_oxygen: 6.0 },
      { timestamp: "2026-02-10T10:10:00Z", temperature: 10.0, ph: 7.0, dissolved_oxygen: 5.0 },
    ]
    
    {
      name: "Species Comparison",
      description: "Same readings tested against different species thresholds",
      readings: readings,
      species_tests: {
        salmon: {
          reading_0: { alerts: 0, description: "Perfect for salmon" },
          reading_1: { alerts: 2, description: "Too hot and low oxygen for salmon" },
          reading_2: { alerts: 2, description: "Too cold and low oxygen for salmon" }
        },
        tilapia: {
          reading_0: { alerts: 1, description: "Too cold for tilapia" },
          reading_1: { alerts: 0, description: "Perfect for tilapia" },
          reading_2: { alerts: 2, description: "Too cold and low oxygen for tilapia" }
        }
      }
    }
  end
  
  # Scenario 7: Edge cases and boundary testing
  def self.generate_edge_cases
    {
      name: "Edge Cases and Boundaries",
      description: "Testing exact threshold boundaries",
      species: "salmon",
      readings: [
        # Exactly at minimums (should be OK)
        { timestamp: "2026-02-10T10:00:00Z", temperature: 12.0, ph: 6.5, dissolved_oxygen: 7.0 },
        # Exactly at maximums (should be OK)
        { timestamp: "2026-02-10T10:05:00Z", temperature: 18.0, ph: 8.5, dissolved_oxygen: 15.0 },
        # Just below minimum (should alert)
        { timestamp: "2026-02-10T10:10:00Z", temperature: 11.9, ph: 6.4, dissolved_oxygen: 6.9 },
        # Just above maximum (should alert)
        { timestamp: "2026-02-10T10:15:00Z", temperature: 18.1, ph: 8.6, dissolved_oxygen: 8.0 },
      ],
      expected: [
        { alerts: 0, description: "At minimum boundaries" },
        { alerts: 0, description: "At maximum boundaries" },
        { alerts: 3, description: "Just below all minimums" },
        { alerts: 2, description: "Just above temp and pH max" }
      ]
    }
  end
  
  # Scenario 8: Full 24-hour daily cycle with natural variations
  def self.generate_daily_cycle
    readings = []
    
    (0..287).each do |i|
      hour = (i * 5) / 60.0
      
      # Natural daily temperature cycle (cooler at night)
      temp_base = 15.0
      temp_variation = 1.5 * Math.sin((hour - 6) * Math::PI / 12)
      temperature = temp_base + temp_variation
      
      # pH varies slightly with photosynthesis (higher during day)
      ph_base = 7.5
      ph_variation = 0.2 * Math.sin((hour - 6) * Math::PI / 12)
      ph = ph_base + ph_variation
      
      # DO varies with temperature (inverse relationship)
      do_base = 8.0
      do_variation = -0.3 * Math.sin((hour - 6) * Math::PI / 12)
      dissolved_oxygen = do_base + do_variation + rand(-0.1..0.1)
      
      readings << {
        timestamp: timestamp_for_minute(i * 5),
        temperature: temperature.round(2),
        ph: ph.round(2),
        dissolved_oxygen: dissolved_oxygen.round(2)
      }
    end
    
    {
      name: "Daily Cycle - Natural Variations",
      description: "24-hour cycle with natural daily variations (all within safe range)",
      species: "salmon",
      readings: readings,
      expected_alerts: 0
    }
  end
  
  # Export scenarios to various formats
  def self.export_to_json(scenarios, filename = 'sensor_test_data.json')
    File.write(filename, JSON.pretty_generate(scenarios))
    puts "✓ Exported scenarios to #{filename}"
  end
  
  def self.export_to_csv(scenario, filename)
    CSV.open(filename, 'wb') do |csv|
      csv << ['timestamp', 'temperature', 'ph', 'dissolved_oxygen']
      scenario[:readings].each do |reading|
        csv << [
          reading[:timestamp],
          reading[:temperature],
          reading[:ph],
          reading[:dissolved_oxygen]
        ]
      end
    end
    puts "✓ Exported scenario '#{scenario[:name]}' to #{filename}"
  end
  
  private
  
  def self.timestamp_for_minute(minutes)
    base_time = Time.new(2026, 2, 10, 0, 0, 0, '+00:00')
    (base_time + (minutes * 60)).iso8601
  end
end

# Generate and export all test data
if __FILE__ == $0
  puts "Generating sensor test data scenarios..."
  puts "=" * 80
  
  scenarios = SensorDataGenerator.generate_all_scenarios
  
  # Export all scenarios to JSON
  SensorDataGenerator.export_to_json(scenarios, 'sensor_test_data.json')
  
  # Export individual scenarios to CSV
  scenarios.each do |key, scenario|
    next unless scenario[:readings]
    filename = "sensor_data_#{key}.csv"
    SensorDataGenerator.export_to_csv(scenario, filename)
  end
  
  puts "=" * 80
  puts "\nGenerated #{scenarios.keys.length} test scenarios:"
  scenarios.each do |key, scenario|
    puts "  • #{scenario[:name]}"
    puts "    #{scenario[:description]}"
  end
  
  puts "\nTest Data Summary:"
  puts "  JSON file: sensor_test_data.json (all scenarios)"
  puts "  CSV files: sensor_data_*.csv (individual scenarios)"
  puts "\nCandidates can use this data to validate their implementations!"
end
