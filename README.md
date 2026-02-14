# Aquaculture Water Quality Monitoring System

## 📋 Overview

The **Aquaculture Water Quality Monitoring System** is a robust Ruby application that monitors and validates water quality parameters for different fish species in aquaculture farms. It accepts sensor readings (temperature, pH, dissolved oxygen) and generates species-specific alerts based on optimal thresholds.

---

## 🎯 Features

### Core Features
- ✅ **Multi-Species Support**: Monitor different fish species with species-specific thresholds
- ✅ **Real-time Validation**: Validate sensor readings against optimal water quality parameters
- ✅ **Descriptive Alerts**: Generate clear, actionable alert messages for out-of-range readings
- ✅ **Extensible Architecture**: Strategy pattern design allows easy addition of new species
- ✅ **Comprehensive Error Handling**: Detailed validation and error messages for invalid inputs
- ✅ **Test Data Generation**: Realistic sensor data generator for testing scenarios

### Currently Supported Species
1. **Salmon** 
   - Temperature: 12-18°C
   - pH: 6.5-8.5
   - Dissolved Oxygen: > 7.0 mg/L

2. **Tilapia**
   - Temperature: 25-30°C
   - pH: 6.5-9.0
   - Dissolved Oxygen: > 5.0 mg/L

---

## 🚀 Getting Started

### Prerequisites
- Ruby 2.7+
- RSpec (for testing)
- bundler

### 1. Install Dependencies

```bash
# Navigate to project directory
cd eg_assignment

# Install dependencies
bundle install

# Run acceptance tests
bundle exec rspec acceptance_tests_spec.rb

# Run all tests (acceptance + unit)
bundle exec rspec

# Generate test data
ruby sensor_data_generator.rb
```

---

## 📖 How to Use

### 1. Basic Usage

```ruby
require_relative 'lib/aquaculture'

# Create a sensor reading
reading = Aquaculture::SensorReading.new(
  temperature: 15.5,
  ph: 7.2,
  dissolved_oxygen: 8.0
)

# Check water quality for Salmon
salmon_checker = Aquaculture::WaterQualityChecker.new(
  Aquaculture::SalmonProfile.new
)
alert = salmon_checker.check_water_quality(reading)
puts alert  # "OK"

# Check for Tilapia (same reading, different profile)
tilapia_checker = Aquaculture::WaterQualityChecker.new(
  Aquaculture::TilapiaProfile.new
)
alert = tilapia_checker.check_water_quality(reading)
# "ALERT: Temperature is 15.5°C (expected between 25°C and 30°C)"
```

### 2. Handling Multiple Violations

```ruby
reading = Aquaculture::SensorReading.new(
  temperature: 35.0,  # Too high for salmon
  ph: 9.5,            # Too high for salmon
  dissolved_oxygen: 3.0  # Too low for salmon
)

salmon_checker = Aquaculture::WaterQualityChecker.new(
  Aquaculture::SalmonProfile.new
)
alert = salmon_checker.check_water_quality(reading)
puts alert
# ALERT: Temperature is 35.0°C (expected between 12°C and 18°C)
# ALERT: pH is 9.5 (expected between 6.5 and 8.5)
# ALERT: Dissolved oxygen is 3.0 mg/L (expected > 7.0 mg/L)
```

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests (64 examples total)
bundle exec rspec

# Run only acceptance tests (22 examples)
bundle exec rspec acceptance_tests_spec.rb

# Run only unit tests (42 examples)
bundle exec rspec spec/water_quality_spec.rb

# Run with verbose output
bundle exec rspec -v

# Run specific test file with detailed output
bundle exec rspec spec/water_quality_spec.rb -fd
```

### Test Coverage

- **22 Acceptance Tests**: Real-world scenarios with actual sensor readings
- **42 Unit Tests**: Comprehensive edge cases and boundary testing

```bash
# Generate realistic test data
ruby sensor_data_generator.rb

# Generated files:
# - test_data/sensor_readings.json
# - test_data/sensor_readings.csv
# - test_data/normal_operations.csv
# - test_data/equipment_failures.csv
# - test_data/edge_cases.csv
```
For Project Architecture refer ARCHITECTURE.md
For Project Software Development Specification refer SDS_V1.md
---
