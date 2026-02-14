# Suggested Project Structure

This is a recommended structure for your implementation. You can organize differently if you prefer, but this layout works well:

```
your-solution/
├── .gitignore                          # Provided
├── .rspec                              # Provided
├── Gemfile                             # Provided
├── README.md                           # Your documentation
│
├── lib/                                # Your implementation
│   ├── aquaculture/                    # Module namespace (optional)
│   │   ├── sensor_reading.rb
│   │   ├── species_profiles/
│   │   │   ├── base_profile.rb
│   │   │   ├── salmon_profile.rb
│   │   │   └── tilapia_profile.rb
│   │   └── water_quality_checker.rb
│   └── aquaculture.rb                  # Main entry point
│
├── spec/                               # Your tests
│   ├── spec_helper.rb                  # Provided
│   ├── sensor_reading_spec.rb
│   ├── species_profiles_spec.rb
│   └── water_quality_checker_spec.rb
│
├── acceptance_tests_spec.rb            # Provided (do not modify)
├── sensor_data_generator.rb            # Provided (do not modify)
├── ASSIGNMENT.md                       # Provided (reference)
└── TESTING_INSTRUCTIONS.md             # Provided (reference)
```

## Alternative Simple Structure

If you prefer a simpler flat structure:

```
your-solution/
├── .gitignore
├── .rspec
├── Gemfile
├── README.md
│
├── sensor_reading.rb                   # Your implementation
├── salmon_profile.rb
├── tilapia_profile.rb
├── water_quality_checker.rb
│
├── spec/
│   ├── spec_helper.rb
│   └── water_quality_spec.rb           # Your tests
│
└── acceptance_tests_spec.rb            # Provided tests
```

## Key Points

1. **lib/** or root - Your implementation code
2. **spec/** - Your own tests (not the acceptance tests)
3. **acceptance_tests_spec.rb** - Keep in root for easy running
4. **README.md** - Document your approach and how to run

## What to Commit

✅ **Do commit:**
- All your implementation files
- Your test files
- README with setup instructions
- .gitignore, .rspec, Gemfile

❌ **Don't commit:**
- Generated test data (sensor_test_data.json, sensor_data_*.csv)
- .rspec_status
- Gemfile.lock (optional)

Choose whatever structure makes sense to you, as long as:
- Code is well-organized
- Acceptance tests can find your classes
- Easy to understand and navigate
