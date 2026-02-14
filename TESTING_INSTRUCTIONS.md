# Testing Your Aquaculture Solution

## Overview

We provide **automated acceptance tests** and **realistic sensor data** to help you validate your implementation. Your code will be evaluated against these tests to ensure it meets all requirements.

---

## 📋 What's Provided

### 1. Acceptance Test Suite (`acceptance_tests_spec.rb`)
- Automated RSpec tests that validate your implementation
- Tests real-world scenarios with actual sensor readings
- Ensures your solution handles all edge cases correctly

### 2. Test Data Generator (`sensor_data_generator.rb`)
- Generates realistic sensor reading scenarios
- Creates JSON and CSV files with test data
- Includes normal operations, equipment failures, and edge cases

---

## 🚀 How to Use

### Step 1: Implement Your Solution

Create your classes following the expected interface:

```ruby
# Your implementation should provide these classes:

class SensorReading
  attr_reader :temperature, :ph, :dissolved_oxygen
  
  def initialize(temperature:, ph:, dissolved_oxygen:)
    # Your code
  end
end

class SalmonProfile
  def thresholds
    # Return hash with min/max values
  end
end

class TilapiaProfile
  def thresholds
    # Return hash with min/max values
  end
end

class WaterQualityChecker
  def initialize(species_profile)
    # Your code
  end
  
  def check(reading)
    # Return array of alert strings (empty if no violations)
  end
end
```

### Step 2: Generate Test Data

```bash
# Run the generator to create test data files
ruby sensor_data_generator.rb
```

This creates:
- `sensor_test_data.json` - All scenarios in one file
- `sensor_data_*.csv` - Individual scenario CSV files

### Step 3: Run the Acceptance Tests

```bash
# Make sure your implementation files are loaded
# Then run the tests:
rspec acceptance_tests_spec.rb
```

---

## 📊 Test Scenarios Explained

### Scenario 1: Normal Operations
✅ **Expected**: No alerts  
📝 **Purpose**: Verify your system doesn't false-alarm on good data

```ruby
# Example reading:
{ temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0 }
# Expected: [] (no alerts)
```

### Scenario 2: Single Parameter Violations
⚠️ **Expected**: 1 alert per violation  
📝 **Purpose**: Detect when one parameter exceeds thresholds

```ruby
# Example reading (salmon):
{ temperature: 22.0, ph: 7.5, dissolved_oxygen: 8.0 }
# Expected: ["Temperature too high: 22.0°C (max: 18.0°C)"]
```

### Scenario 3: Multiple Violations
🚨 **Expected**: Multiple alerts  
📝 **Purpose**: Detect cascading failures

```ruby
# Example reading (salmon):
{ temperature: 22.0, ph: 9.5, dissolved_oxygen: 4.0 }
# Expected: 3 alerts (one for each violated parameter)
```

### Scenario 4: Species-Specific Thresholds
🐟 **Expected**: Different alerts for different species  
📝 **Purpose**: Verify species profiles work correctly

```ruby
# Same reading tested against salmon vs tilapia:
{ temperature: 28.0, ph: 8.0, dissolved_oxygen: 6.0 }

# Salmon: 2 alerts (temp too high, DO too low)
# Tilapia: 0 alerts (all parameters OK)
```

### Scenario 5: Edge Cases
🎯 **Expected**: Precise boundary handling  
📝 **Purpose**: Test exact threshold values

```ruby
# At exact minimum (should be OK):
{ temperature: 12.0, ph: 6.5, dissolved_oxygen: 7.0 }
# Expected: [] (no alerts)

# Just below minimum (should alert):
{ temperature: 11.9, ph: 6.4, dissolved_oxygen: 6.9 }
# Expected: 3 alerts
```

### Scenario 6: Real-World Sensor Streams
🌊 **Expected**: Detect problems as they develop  
📝 **Purpose**: Simulate actual equipment failures over time

```ruby
# Temperature spike scenario:
# Reading 1: 15.0°C → No alert
# Reading 2: 17.0°C → No alert  
# Reading 3: 19.0°C → ALERT! (exceeds 18.0°C)
# Reading 4: 21.0°C → ALERT!
```

---

## ✅ What Makes Tests Pass

### 1. Interface Compliance
```ruby
# Your check() method must:
✓ Accept a SensorReading object
✓ Return an Array (not nil)
✓ Return empty array when no violations
✓ Return array of strings when violations occur
```

### 2. Alert Message Quality
```ruby
# Alert strings should:
✓ Be descriptive (>10 characters)
✓ Mention the parameter name
✓ Indicate direction (too high/low)
✓ Include the actual value
✓ Include the threshold

# Good examples:
"Temperature too high: 22.0°C (max: 18.0°C)"
"Dissolved oxygen too low: 5.0mg/L (min: 7.0mg/L)"

# Bad examples:
"Error"  # Too vague
"22.0"   # Missing context
nil      # Wrong type
```

### 3. Correct Thresholds

**Salmon:**
- Temperature: 12.0 - 18.0°C
- pH: 6.5 - 8.5
- Dissolved Oxygen: > 7.0 mg/L

**Tilapia:**
- Temperature: 25.0 - 30.0°C
- pH: 6.5 - 9.0
- Dissolved Oxygen: > 5.0 mg/L

### 4. Boundary Handling
```ruby
# Values AT the threshold are acceptable:
temperature: 18.0  # Max is 18.0 → OK ✓
temperature: 18.1  # Max is 18.0 → Alert! ⚠️
```

---

## 🐛 Common Issues and Fixes

### Issue 1: Tests can't find your classes
```ruby
# Fix: Make sure your files are loaded before tests run
# Add to top of acceptance_tests_spec.rb:
require_relative './lib/your_implementation'
```

### Issue 2: `nil` instead of empty array
```ruby
# Bad:
def check(reading)
  return nil if all_ok?  # ❌ Don't return nil
end

# Good:
def check(reading)
  return [] if all_ok?  # ✓ Return empty array
end
```

### Issue 3: Inconsistent alert format
```ruby
# Bad:
["temp high", "ph low"]  # ❌ Not descriptive enough

# Good:
[
  "Temperature too high: 22.0°C (max: 18.0°C)",
  "pH too low: 6.0 (min: 6.5)"
]
```

### Issue 4: Off-by-one boundary errors
```ruby
# Make sure boundaries are INCLUSIVE:
if value < min || value > max  # ✓ Correct
if value <= min || value >= max  # ❌ Wrong 
```

---

## 📈 Understanding Test Results

### All Tests Pass ✅
```
Finished in 0.5 seconds
48 examples, 0 failures
```
**Great!** Your implementation meets all requirements.

### Some Tests Fail ⚠️
```
Finished in 0.5 seconds
48 examples, 5 failures
```
**Check the failure messages** - they tell you exactly what's wrong:

```
Failure/Error: expect(alerts).to be_empty
  Expected no alerts for optimal conditions, got: ["Temperature too high: 15.0°C (max: 18.0°C)"]
```
This tells you: Your threshold logic is wrong (15.0 is fine for salmon).

---

## 💡 Testing Tips

### 1. Test Incrementally
```bash
# Run one test at a time:
rspec acceptance_tests_spec.rb:10  # Run test at line 10

# Run one describe block:
rspec acceptance_tests_spec.rb -e "Normal Operations"
```

### 2. Use the Generated Data
```ruby
# Load test data in your own tests:
require 'json'
data = JSON.parse(File.read('sensor_test_data.json'))

# Test against real scenarios:
scenario = data['temperature_spike']
scenario['readings'].each do |reading_data|
  reading = SensorReading.new(reading_data)
  alerts = checker.check(reading)
  # Verify alerts
end
```

### 3. Add Your Own Tests
```ruby
# Beyond the acceptance tests, add your own:
RSpec.describe 'My additional tests' do
  it 'handles my specific edge case' do
    # Your test
  end
end
```

---

## 🎯 Success Criteria

Your solution passes when:

✅ All 48 acceptance tests pass  
✅ Normal readings generate no false alarms  
✅ Violations are detected correctly  
✅ Species-specific thresholds work  
✅ Boundary values are handled properly  
✅ Alert messages are clear and informative  

---

## 📞 Questions?

If something is unclear:
1. Check the test failure message - it's descriptive
2. Look at the test scenario data
3. Review your threshold values
4. Verify your alert format

The automated tests are your guide - make them pass, and you've successfully completed the assessment!

---

**Good luck!** 🐟🦐
