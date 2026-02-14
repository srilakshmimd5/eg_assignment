# Aquaculture Water Quality Monitoring System
## Senior Ruby/Rails Developer Assessment

**Time approximation:** 1 hour  
**Focus:** Design patterns, code quality, testing, domain modeling

---

## 📦 What's in This Package

1. **ASSIGNMENT.md** - The task description and requirements
2. **acceptance_tests_spec.rb** - Automated tests to validate your solution
3. **sensor_data_generator.rb** - Generates realistic test data
4. **TESTING_INSTRUCTIONS.md** - How to use the tests and validate your work

---

## 🚀 Quick Start

### 1. Install Dependencies
```bash
# Install RSpec and other gems
bundle install
```

### 2. Read the Assignment
```bash
# Start here to understand what you're building
open ASSIGNMENT.md
```

### 3. Generate Test Data
```bash
# Create realistic sensor reading scenarios
ruby sensor_data_generator.rb
```

This creates:
- `sensor_test_data.json` - All test scenarios
- `sensor_data_*.csv` - Individual scenario files

### 4. Implement Your Solution

Create your implementation following this interface:

```ruby
# Required classes:
class SensorReading
  attr_reader :temperature, :ph, :dissolved_oxygen
  def initialize(temperature:, ph:, dissolved_oxygen:)
end

class SalmonProfile
  def thresholds  # Returns hash with min/max values
end

class TilapiaProfile
  def thresholds  # Returns hash with min/max values
end

class WaterQualityChecker
  def initialize(species_profile)
  def check(reading)  # Returns array of alert strings
end
```

### 5. Validate Your Solution
```bash
# Run the acceptance tests
bundle exec rspec acceptance_tests_spec.rb
```

**Goal:** All 48 tests should pass ✅

---

## 📋 Deliverables

Please submit:

1. **Your Implementation** (Ruby files)
   - Main classes (SensorReading, Profiles, Checker)
   - Well-organized, readable code
   - Use appropriate design patterns

2. **Your Tests** (RSpec files)
   - Unit tests for your classes
   - Test coverage for main scenarios
   - Include edge cases

3. **Documentation** (README or comments)
   - How to run your code
   - Design decisions and patterns used
   - How to add new species

4. **Proof of Passing** (optional but recommended)
   - Screenshot or output of passing acceptance tests
   - Shows all 48 examples passing

---

## ✅ Success Criteria

Your solution should:

- ✅ Pass all 48 automated acceptance tests
- ✅ Use appropriate design patterns (Strategy recommended)
- ✅ Be easy to extend (add new species, parameters)
- ✅ Have clean, readable Ruby code
- ✅ Include your own comprehensive tests
- ✅ Be well-documented

---

## 🎯 What We're Evaluating

1. **Design Patterns** (30%) - Appropriate use of Strategy, Factory, etc.
2. **Code Quality** (25%) - Readability, Ruby idioms, maintainability
3. **Testing** (20%) - Your tests + passing acceptance tests
4. **Domain Modeling** (15%) - Understanding aquaculture concepts
5. **Documentation** (10%) - Clear explanations of decisions

---

## ⏱️ Time Management Tips

- **10 min** - Design and planning (sketch classes)
- **30 min** - Core implementation
- **15 min** - Write your tests
- **5 min** - Documentation and final validation

**Pro tip:** Make sure acceptance tests pass BEFORE writing documentation!

---

## 💡 Hints

- Start simple - get basic validation working first
- Use the Strategy pattern for species profiles
- Make sure `check()` returns an array (not nil)
- Alert messages should be descriptive
- Run tests frequently to catch issues early

---

## 📞 Questions?

If you have questions about:
- **Requirements:** Check ASSIGNMENT.md
- **Testing:** Check TESTING_INSTRUCTIONS.md
- **Interface:** Look at acceptance_tests_spec.rb examples

---

## 📤 Submission via GitHub

**Share the repository link**
  - If private repo: Add us as collaborator
  - If public repo: Just send us the link

### Repository Checklist

- [ ] All implementation files committed
- [ ] Your own tests included
- [ ] README with setup instructions
- [ ] Proof that acceptance tests pass (screenshot or CI)
- [ ] Clean git history (meaningful commits)
- [ ] Repository link shared with us

**Submit by sharing:** Your GitHub repository URL

---

**Good luck!** 🐟🦐

We're excited to see your solution!
