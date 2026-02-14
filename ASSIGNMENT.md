# Senior Ruby/Rails Developer Assessment (1 Hour)
## Aquaculture Domain - Simplified

## Task: Design a Water Quality Alert System

### Context
You're building a system for an aquaculture farm that monitors water quality. The system receives sensor readings and needs to alert farm operators when water parameters go outside safe ranges for their fish.

### Background
Different fish species have different safe water parameter ranges:
- **Salmon**: Temperature 12-18°C, pH 6.5-8.5, Dissolved Oxygen > 7 mg/L
- **Tilapia**: Temperature 25-30°C, pH 6.5-9.0, Dissolved Oxygen > 5 mg/L

### Requirements

**Core Functionality:**
1. Accept sensor readings for a tank (temperature, pH, dissolved oxygen)
2. Check if readings are within safe ranges for that tank's species
3. Generate alerts when parameters are outside safe ranges
4. Support adding new species with different thresholds

**Technical Requirements:**
1. Use at least one design pattern appropriately (Strategy, Factory, or similar)
2. Write clean, testable Ruby code
3. Include RSpec tests for the main scenarios
4. Make it easy to add new species or parameters

### Deliverables

Please provide:

1. **Core Implementation** (~40 lines)
   - A way to check if readings are safe for a species
   - Alert generation when thresholds are violated
   - Support for multiple species

2. **Tests** (RSpec)
   - Test that safe readings don't generate alerts
   - Test that unsafe readings do generate alerts
   - Test with different species

3. **Brief Documentation** (comments or short README)
   - How to add a new species
   - Design pattern(s) used and why

**Out of Scope** (don't worry about these):
- Actual alert delivery (email/SMS)
- Database persistence
- Trend detection over time
- API endpoints
- Sensor malfunction detection

### What We're Evaluating

1. **Design Pattern Usage**: Appropriate abstraction for species-specific rules
2. **Code Quality**: Readable, maintainable Ruby
3. **Testing**: Good test coverage of main scenarios
4. **Extensibility**: Easy to add new species
5. **Documentation**: Clear explanation of your approach

### Time Management Suggestion

- 10 min: Design & sketch out classes
- 30 min: Implementation
- 15 min: Tests
- 5 min: Documentation

---

## Example Starting Point

```ruby
# You can start from scratch or use this as inspiration

class SensorReading
  attr_reader :temperature, :ph, :dissolved_oxygen
  
  def initialize(temperature:, ph:, dissolved_oxygen:)
    @temperature = temperature
    @ph = ph
    @dissolved_oxygen = dissolved_oxygen
  end
end

class WaterQualityChecker
  def initialize(species_profile)
    @species_profile = species_profile
  end
  
  def check(reading)
    # Return array of alert messages (empty if all good)
    # e.g., ["Temperature too high: 22.0°C (max: 18.0°C)"]
  end
end

# Usage:
# checker = WaterQualityChecker.new(SalmonProfile.new)
# reading = SensorReading.new(temperature: 22.0, ph: 7.5, dissolved_oxygen: 8.0)
# alerts = checker.check(reading)
# 
# if alerts.any?
#   puts "ALERT: #{alerts.join(', ')}"
# end
```

---

## Test Data Examples

```ruby
# Safe reading for salmon
SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0)

# Temperature too high for salmon (should alert)
SensorReading.new(temperature: 22.0, ph: 7.5, dissolved_oxygen: 8.0)

# Multiple violations (should alert for each)
SensorReading.new(temperature: 22.0, ph: 9.5, dissolved_oxygen: 4.0)

# Safe for tilapia but not for salmon
SensorReading.new(temperature: 28.0, ph: 8.0, dissolved_oxygen: 6.0)
```

---

## Key Scenarios to Test

1. ✅ All parameters within safe range → No alerts
2. ⚠️ Temperature too high → Temperature alert
3. ⚠️ Temperature too low → Temperature alert
4. ⚠️ pH outside range → pH alert
5. ⚠️ Dissolved oxygen too low → DO alert
6. ⚠️ Multiple violations → Multiple alerts
7. 🐟 Different species have different thresholds

---

## Tips

- Focus on the core logic, not the peripherals
- A simple, well-designed solution is better than complex code
- Document your design choices
- Feel free to use Vibe coding tools

---

## Evaluation Criteria

**Excellent Solution:**
- Clear use of design pattern (e.g., Strategy for species)
- Clean, readable code
- Good test coverage
- Easy to extend with new species
- Brief but clear documentation

**Good Solution:**
- Working implementation
- Some design pattern usage
- Basic tests
- Reasonable code structure

**What We're NOT Looking For:**
- Over-engineering
- Complex frameworks
- Premature optimization
- Features beyond the requirements

Good luck! 🐟
