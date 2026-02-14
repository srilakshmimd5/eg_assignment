## 🏗️ Architecture

### Design Pattern: Strategy Pattern

The system uses the **Strategy Pattern** to handle species-specific water quality validation:

```
┌─────────────────────────────────────┐
│   WaterQualityChecker (Context)    │
│   - check_water_quality(reading)   │
└──────────────────┬──────────────────┘
                   │
                   │ uses
                   │
       ┌───────────┴───────────┐
       │                       │
┌──────▼──────────┐   ┌────────▼─────────┐
│ SpeciesProfile  │   │ SensorReading    │
│ (Strategy)      │   │ - temperature    │
│ - min_temp      │   │ - ph             │
│ - max_temp      │   │ - dissolved_oxygen
│ - min_ph        │   └──────────────────┘
│ - max_ph        │
│ - min_do        │
│ - validate()    │
│ - alert_for()   │
└────────┬────────┘
         │
    ┌────┴─────────────────┐
    │                      │
┌───▼──────────┐   ┌──────▼────────┐
│SalmonProfile │   │TilapiaProfile │
│- Salmon      │   │- Tilapia      │
│  thresholds  │   │  thresholds   │
└──────────────┘   └───────────────┘
```

**Why Strategy Pattern?**
- ✅ Each species has different water quality requirements
- ✅ Easy to add new species without modifying existing code
- ✅ Separates species-specific logic from checking logic
- ✅ Follows Open/Closed Principle (Open for extension, closed for modification)

---
## Project Structure

```
eg_assignment/
├── lib/
│   └── aquaculture/
│       ├── sensor_reading.rb          # Sensor data object with validation
│       ├── species_profile.rb         # Abstract base class (Strategy pattern)
│       ├── salmon_profile.rb          # Salmon-specific thresholds
│       ├── tilapia_profile.rb         # Tilapia-specific thresholds
│       └── water_quality_checker.rb   # Main orchestrator class
├── spec/
│   └── water_quality_spec.rb          # Comprehensive unit tests
├── acceptance_tests_spec.rb           # Original acceptance tests (unchanged)
├── sensor_data_generator.rb           # Test data generator
├── README.md                          # This file
├── SOFTWARE_DESIGN_SPECIFICATION.md   # Detailed design documentation
├── Gemfile                            # Ruby dependencies
└── Gemfile.lock                       # Locked dependency versions
```
---

## 📊 Species Configuration

### Salmon Profile (Cold Water Fish)
```ruby
Aquaculture::SalmonProfile.new

# Thresholds:
# Temperature: 12-18°C (narrow range for cold water)
# pH: 6.5-8.5
# Dissolved Oxygen: > 7.0 mg/L (requires high oxygen)
```

### Tilapia Profile (Warm Water Fish)
```ruby
Aquaculture::TilapiaProfile.new

# Thresholds:
# Temperature: 25-30°C (warm water preference)
# pH: 6.5-9.0 (more tolerance)
# Dissolved Oxygen: > 5.0 mg/L (tolerates lower oxygen)
```

---

## 🔧 Guidelines for Adding New Species

### Step-by-Step Process

#### 1. **Identify Species Requirements**
Determine the optimal water quality ranges:
- Minimum and maximum temperature (°C)
- Minimum and maximum pH (0-14 scale)
- Minimum dissolved oxygen (mg/L)

**Example: Catfish**
```
Temperature: 20-28°C
pH: 6.0-8.5
Dissolved Oxygen: > 4.0 mg/L
```

#### 2. **Create New Profile Class**
Create a new file in `lib/aquaculture/` following the naming convention:

```ruby
# filepath: lib/aquaculture/catfish_profile.rb

module Aquaculture
  class CatfishProfile < SpeciesProfile
    def initialize
      @species_name = 'Catfish'
      @min_temperature = 20
      @max_temperature = 28
      @min_ph = 6.0
      @max_ph = 8.5
      @min_dissolved_oxygen = 4.0
    end
  end
end
```

#### 3. **Update Main Module** (if needed for easy access)
Optional: Add a convenience method in `lib/aquaculture.rb`:

```ruby
# lib/aquaculture.rb
require 'aquaculture/catfish_profile'

module Aquaculture
  def self.for_catfish
    CatfishProfile.new
  end
end
```

#### 4. **Test the New Species**
Add tests to `spec/water_quality_spec.rb`:

```ruby
describe 'Catfish Profile' do
  let(:profile) { Aquaculture::CatfishProfile.new }
  let(:checker) { Aquaculture::WaterQualityChecker.new(profile) }

  context 'with optimal conditions' do
    it 'returns OK for readings within range' do
      reading = Aquaculture::SensorReading.new(
        temperature: 24.0,
        ph: 7.0,
        dissolved_oxygen: 5.5
      )
      expect(checker.check_water_quality(reading)).to eq('OK')
    end
  end

  context 'with temperature violations' do
    it 'alerts when temperature is too low' do
      reading = Aquaculture::SensorReading.new(
        temperature: 19.0,  # Below minimum 20°C
        ph: 7.0,
        dissolved_oxygen: 5.5
      )
      alert = checker.check_water_quality(reading)
      expect(alert).to include('Temperature is 19.0°C')
      expect(alert).to include('expected between 20°C and 28°C')
    end
  end
end
```

#### 5. **Run Tests**
```bash
bundle exec rspec spec/water_quality_spec.rb -v
```

#### 6. **Update Documentation**
Add the new species to this README in the "Currently Supported Species" section.

---

## 📝 Implementation Checklist for New Species

```
□ Determine species thresholds (temperature, pH, DO)
□ Create new profile class in lib/aquaculture/
□ Follow naming convention: {species_name}_profile.rb
□ Inherit from SpeciesProfile
□ Set @species_name, @min_temp, @max_temp, etc.
□ Add require statement in lib/aquaculture.rb (optional)
□ Write unit tests in spec/water_quality_spec.rb
□ Test normal conditions (OK message)
□ Test temperature violations
□ Test pH violations
□ Test dissolved oxygen violations
□ Test multiple simultaneous violations
□ Run full test suite: bundle exec rspec
□ Update README.md with species details
□ Verify all tests pass (0 failures)
```

---

## 🐛 Common Issues and Solutions

### Issue 1: Tests Not Running
```bash
# Solution: Install dependencies
bundle install

# Or update gems
bundle update
```

### Issue 2: Require Errors
```bash
# Make sure lib/ is in load path
bundle exec rspec
```

### Issue 3: Invalid Species Parameters
```ruby
# ❌ Wrong: Missing required parameters
profile = Aquaculture::SalmonProfile.new(temperature: 15)

# ✅ Correct: All parameters set automatically
profile = Aquaculture::SalmonProfile.new
```

---

## 📚 File Reference

| File | Purpose |
|------|---------|
| `lib/aquaculture.rb` | Main module entry point |
| `lib/aquaculture/sensor_reading.rb` | Sensor data validation |
| `lib/aquaculture/species_profile.rb` | Abstract base class |
| `lib/aquaculture/salmon_profile.rb` | Salmon thresholds |
| `lib/aquaculture/tilapia_profile.rb` | Tilapia thresholds |
| `lib/aquaculture/water_quality_checker.rb` | Quality checker logic |
| `spec/water_quality_spec.rb` | Unit tests |
| `acceptance_tests_spec.rb` | Acceptance tests |
| `sensor_data_generator.rb` | Test data generator |
| `ARCHITECTURE.md` | Detailed design docs |

---

## 📋 Summary

- **Language**: Ruby
- **Test Framework**: RSpec
- **Design Pattern**: Strategy Pattern
- **Current Tests**: 64 examples, 100% pass rate
- **Status**: ✅ Production Ready

---

## 📞 Support

For detailed technical specifications, design decisions, and implementation guidelines, see `SOFTWARE_DESIGN_SPECIFICATION.md`.

For test data generation instructions, see comments in `sensor_data_generator.rb`.

---

**Version**: 1.0  
**Last Updated**: February 14, 2026  
**Status**: ✅ Complete and Tested