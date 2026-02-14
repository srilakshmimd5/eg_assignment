# frozen_string_literal: true

require 'rspec'
require_relative '../lib/aquaculture'

RSpec.describe 'Aquaculture Water Quality System - Unit Tests' do
  describe SensorReading do
    describe '#initialize' do
      context 'with valid parameters' do
        it 'creates a reading with all valid values' do
          reading = SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0)
          expect(reading.temperature).to eq(15.0)
          expect(reading.ph).to eq(7.5)
          expect(reading.dissolved_oxygen).to eq(8.0)
        end

        it 'accepts minimum valid temperature' do
          reading = SensorReading.new(temperature: -50.0, ph: 7.5, dissolved_oxygen: 8.0)
          expect(reading.temperature).to eq(-50.0)
        end

        it 'accepts maximum valid temperature' do
          reading = SensorReading.new(temperature: 60.0, ph: 7.5, dissolved_oxygen: 8.0)
          expect(reading.temperature).to eq(60.0)
        end

        it 'accepts minimum valid pH' do
          reading = SensorReading.new(temperature: 15.0, ph: 0.0, dissolved_oxygen: 8.0)
          expect(reading.ph).to eq(0.0)
        end

        it 'accepts maximum valid pH' do
          reading = SensorReading.new(temperature: 15.0, ph: 14.0, dissolved_oxygen: 8.0)
          expect(reading.ph).to eq(14.0)
        end

        it 'accepts zero dissolved oxygen' do
          reading = SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 0.0)
          expect(reading.dissolved_oxygen).to eq(0.0)
        end

        it 'accepts high dissolved oxygen' do
          reading = SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 100.0)
          expect(reading.dissolved_oxygen).to eq(100.0)
        end
      end

      context 'with invalid temperature' do
        it 'raises ArgumentError for temperature below -50' do
          expect {
            SensorReading.new(temperature: -51.0, ph: 7.5, dissolved_oxygen: 8.0)
          }.to raise_error(ArgumentError, /Temperature must be between/)
        end

        it 'raises ArgumentError for temperature above 60' do
          expect {
            SensorReading.new(temperature: 61.0, ph: 7.5, dissolved_oxygen: 8.0)
          }.to raise_error(ArgumentError, /Temperature must be between/)
        end

        it 'raises ArgumentError for non-numeric temperature' do
          expect {
            SensorReading.new(temperature: 'hot', ph: 7.5, dissolved_oxygen: 8.0)
          }.to raise_error(ArgumentError, /Temperature must be between/)
        end

        it 'raises ArgumentError for nil temperature' do
          expect {
            SensorReading.new(temperature: nil, ph: 7.5, dissolved_oxygen: 8.0)
          }.to raise_error(ArgumentError, /Temperature must be between/)
        end
      end

      context 'with invalid pH' do
        it 'raises ArgumentError for pH below 0' do
          expect {
            SensorReading.new(temperature: 15.0, ph: -0.1, dissolved_oxygen: 8.0)
          }.to raise_error(ArgumentError, /pH must be between/)
        end

        it 'raises ArgumentError for pH above 14' do
          expect {
            SensorReading.new(temperature: 15.0, ph: 14.1, dissolved_oxygen: 8.0)
          }.to raise_error(ArgumentError, /pH must be between/)
        end

        it 'raises ArgumentError for non-numeric pH' do
          expect {
            SensorReading.new(temperature: 15.0, ph: 'neutral', dissolved_oxygen: 8.0)
          }.to raise_error(ArgumentError, /pH must be between/)
        end

        it 'raises ArgumentError for nil pH' do
          expect {
            SensorReading.new(temperature: 15.0, ph: nil, dissolved_oxygen: 8.0)
          }.to raise_error(ArgumentError, /pH must be between/)
        end
      end

      context 'with invalid dissolved oxygen' do
        it 'raises ArgumentError for negative dissolved oxygen' do
          expect {
            SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: -1.0)
          }.to raise_error(ArgumentError, /Dissolved oxygen must be/)
        end

        it 'raises ArgumentError for non-numeric dissolved oxygen' do
          expect {
            SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 'high')
          }.to raise_error(ArgumentError, /Dissolved oxygen must be/)
        end

        it 'raises ArgumentError for nil dissolved oxygen' do
          expect {
            SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: nil)
          }.to raise_error(ArgumentError, /Dissolved oxygen must be/)
        end
      end
    end

    describe 'attr_reader' do
      let(:reading) { SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0) }

      it 'provides read-only access to temperature' do
        expect(reading).to respond_to(:temperature)
        expect { reading.temperature = 20.0 }.to raise_error(NoMethodError)
      end

      it 'provides read-only access to pH' do
        expect(reading).to respond_to(:ph)
        expect { reading.ph = 8.0 }.to raise_error(NoMethodError)
      end

      it 'provides read-only access to dissolved_oxygen' do
        expect(reading).to respond_to(:dissolved_oxygen)
        expect { reading.dissolved_oxygen = 9.0 }.to raise_error(NoMethodError)
      end
    end
  end

  describe SalmonProfile do
    describe '#thresholds' do
      it 'returns a hash with all three parameters' do
        profile = SalmonProfile.new
        thresholds = profile.thresholds
        expect(thresholds).to have_key(:temperature)
        expect(thresholds).to have_key(:ph)
        expect(thresholds).to have_key(:dissolved_oxygen)
      end

      it 'has correct temperature thresholds for salmon' do
        profile = SalmonProfile.new
        temp_thresholds = profile.thresholds[:temperature]
        expect(temp_thresholds[:min]).to eq(12.0)
        expect(temp_thresholds[:max]).to eq(18.0)
      end

      it 'has correct pH thresholds for salmon' do
        profile = SalmonProfile.new
        ph_thresholds = profile.thresholds[:ph]
        expect(ph_thresholds[:min]).to eq(6.5)
        expect(ph_thresholds[:max]).to eq(8.5)
      end

      it 'has correct dissolved oxygen threshold for salmon' do
        profile = SalmonProfile.new
        do_thresholds = profile.thresholds[:dissolved_oxygen]
        expect(do_thresholds[:min]).to eq(7.0)
        expect(do_thresholds).not_to have_key(:max)
      end
    end

    describe '#validate' do
      let(:profile) { SalmonProfile.new }

      context 'when all parameters are safe' do
        it 'returns empty array' do
          reading = SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end
      end

      context 'when temperature is too high' do
        it 'returns temperature alert' do
          reading = SensorReading.new(temperature: 22.0, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).not_to be_empty
          expect(alerts.first).to include('Temperature')
          expect(alerts.first).to include('too high')
        end
      end

      context 'when temperature is too low' do
        it 'returns temperature alert' do
          reading = SensorReading.new(temperature: 10.0, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).not_to be_empty
          expect(alerts.first).to include('Temperature')
          expect(alerts.first).to include('too low')
        end
      end

      context 'when pH is too high' do
        it 'returns pH alert' do
          reading = SensorReading.new(temperature: 15.0, ph: 9.0, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).to include(an_object_satisfying { |a| a.include?('pH') && a.include?('too high') })
        end
      end

      context 'when pH is too low' do
        it 'returns pH alert' do
          reading = SensorReading.new(temperature: 15.0, ph: 6.0, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).to include(an_object_satisfying { |a| a.include?('pH') && a.include?('too low') })
        end
      end

      context 'when dissolved oxygen is too low' do
        it 'returns dissolved oxygen alert' do
          reading = SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 5.0)
          alerts = profile.validate(reading)
          expect(alerts).to include(an_object_satisfying { |a| a.include?('Dissolved oxygen') && a.include?('too low') })
        end
      end

      context 'when multiple parameters are violated' do
        it 'returns multiple alerts' do
          reading = SensorReading.new(temperature: 25.0, ph: 9.0, dissolved_oxygen: 5.0)
          alerts = profile.validate(reading)
          expect(alerts.size).to eq(3)
        end
      end

      context 'boundary values (at exact thresholds)' do
        it 'allows exactly minimum temperature' do
          reading = SensorReading.new(temperature: 12.0, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end

        it 'allows exactly maximum temperature' do
          reading = SensorReading.new(temperature: 18.0, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end

        it 'alerts just below minimum temperature' do
          reading = SensorReading.new(temperature: 11.9, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).not_to be_empty
          expect(alerts.first).to include('too low')
        end

        it 'alerts just above maximum temperature' do
          reading = SensorReading.new(temperature: 18.1, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).not_to be_empty
          expect(alerts.first).to include('too high')
        end

        it 'allows exactly minimum pH' do
          reading = SensorReading.new(temperature: 15.0, ph: 6.5, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end

        it 'allows exactly maximum pH' do
          reading = SensorReading.new(temperature: 15.0, ph: 8.5, dissolved_oxygen: 8.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end

        it 'allows exactly minimum dissolved oxygen' do
          reading = SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 7.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end

        it 'alerts just below minimum dissolved oxygen' do
          reading = SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 6.9)
          alerts = profile.validate(reading)
          expect(alerts).not_to be_empty
          expect(alerts.first).to include('Dissolved oxygen')
          expect(alerts.first).to include('too low')
        end
      end
    end
  end

  describe TilapiaProfile do
    describe '#thresholds' do
      it 'returns a hash with all three parameters' do
        profile = TilapiaProfile.new
        thresholds = profile.thresholds
        expect(thresholds).to have_key(:temperature)
        expect(thresholds).to have_key(:ph)
        expect(thresholds).to have_key(:dissolved_oxygen)
      end

      it 'has correct temperature thresholds for tilapia' do
        profile = TilapiaProfile.new
        temp_thresholds = profile.thresholds[:temperature]
        expect(temp_thresholds[:min]).to eq(25.0)
        expect(temp_thresholds[:max]).to eq(30.0)
      end

      it 'has correct pH thresholds for tilapia' do
        profile = TilapiaProfile.new
        ph_thresholds = profile.thresholds[:ph]
        expect(ph_thresholds[:min]).to eq(6.5)
        expect(ph_thresholds[:max]).to eq(9.0)
      end

      it 'has correct dissolved oxygen threshold for tilapia' do
        profile = TilapiaProfile.new
        do_thresholds = profile.thresholds[:dissolved_oxygen]
        expect(do_thresholds[:min]).to eq(5.0)
        expect(do_thresholds).not_to have_key(:max)
      end
    end

    describe '#validate' do
      let(:profile) { TilapiaProfile.new }

      context 'when all parameters are safe' do
        it 'returns empty array' do
          reading = SensorReading.new(temperature: 27.0, ph: 7.8, dissolved_oxygen: 6.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end
      end

      context 'when temperature is too high' do
        it 'returns temperature alert' do
          reading = SensorReading.new(temperature: 31.0, ph: 7.8, dissolved_oxygen: 6.0)
          alerts = profile.validate(reading)
          expect(alerts).not_to be_empty
          expect(alerts.first).to include('Temperature')
          expect(alerts.first).to include('too high')
        end
      end

      context 'when temperature is too low' do
        it 'returns temperature alert' do
          reading = SensorReading.new(temperature: 24.0, ph: 7.8, dissolved_oxygen: 6.0)
          alerts = profile.validate(reading)
          expect(alerts).not_to be_empty
          expect(alerts.first).to include('Temperature')
          expect(alerts.first).to include('too low')
        end
      end

      context 'boundary values (at exact thresholds)' do
        it 'allows exactly minimum temperature' do
          reading = SensorReading.new(temperature: 25.0, ph: 7.8, dissolved_oxygen: 6.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end

        it 'allows exactly maximum temperature' do
          reading = SensorReading.new(temperature: 30.0, ph: 7.8, dissolved_oxygen: 6.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end

        it 'allows exactly minimum dissolved oxygen' do
          reading = SensorReading.new(temperature: 27.0, ph: 7.8, dissolved_oxygen: 5.0)
          alerts = profile.validate(reading)
          expect(alerts).to be_empty
        end

        it 'alerts just below minimum dissolved oxygen' do
          reading = SensorReading.new(temperature: 27.0, ph: 7.8, dissolved_oxygen: 4.9)
          alerts = profile.validate(reading)
          expect(alerts).not_to be_empty
          expect(alerts.first).to include('Dissolved oxygen')
          expect(alerts.first).to include('too low')
        end
      end
    end
  end

  describe WaterQualityChecker do
    describe '#initialize' do
      it 'accepts a species profile' do
        profile = SalmonProfile.new
        checker = WaterQualityChecker.new(profile)
        expect(checker).to be_a(WaterQualityChecker)
      end

      it 'works with SalmonProfile' do
        profile = SalmonProfile.new
        expect { WaterQualityChecker.new(profile) }.not_to raise_error
      end

      it 'works with TilapiaProfile' do
        profile = TilapiaProfile.new
        expect { WaterQualityChecker.new(profile) }.not_to raise_error
      end
    end

    describe '#check' do
      let(:salmon_checker) { WaterQualityChecker.new(SalmonProfile.new) }
      let(:tilapia_checker) { WaterQualityChecker.new(TilapiaProfile.new) }

      context 'with safe reading' do
        it 'returns empty array for salmon' do
          reading = SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = salmon_checker.check(reading)
          expect(alerts).to be_empty
        end

        it 'returns empty array for tilapia' do
          reading = SensorReading.new(temperature: 27.0, ph: 7.8, dissolved_oxygen: 6.0)
          alerts = tilapia_checker.check(reading)
          expect(alerts).to be_empty
        end
      end

      context 'with unsafe reading' do
        it 'returns alerts array for salmon' do
          reading = SensorReading.new(temperature: 22.0, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = salmon_checker.check(reading)
          expect(alerts).not_to be_empty
          expect(alerts).to be_a(Array)
          expect(alerts.first).to be_a(String)
        end

        it 'returns alerts array for tilapia' do
          reading = SensorReading.new(temperature: 22.0, ph: 7.8, dissolved_oxygen: 6.0)
          alerts = tilapia_checker.check(reading)
          expect(alerts).not_to be_empty
          expect(alerts).to be_a(Array)
        end
      end

      context 'species-specific thresholds' do
        let(:reading) { SensorReading.new(temperature: 28.0, ph: 8.0, dissolved_oxygen: 6.0) }

        it 'safe for tilapia but alerts for salmon' do
          salmon_alerts = salmon_checker.check(reading)
          tilapia_alerts = tilapia_checker.check(reading)

          expect(salmon_alerts).not_to be_empty
          expect(tilapia_alerts).to be_empty
        end
      end

      context 'alert message quality' do
        it 'returns descriptive strings with values and thresholds' do
          reading = SensorReading.new(temperature: 22.0, ph: 7.5, dissolved_oxygen: 8.0)
          alerts = salmon_checker.check(reading)
          alert_message = alerts.first

          expect(alert_message.length).to be > 10
          expect(alert_message).to include('Temperature')
          expect(alert_message).to include('22.0')
          expect(alert_message).to include('18.0')
          expect(alert_message).to include('°C')
        end
      end

      context 'multiple violations' do
        it 'returns multiple alert messages' do
          reading = SensorReading.new(temperature: 22.0, ph: 9.5, dissolved_oxygen: 4.0)
          alerts = salmon_checker.check(reading)
          expect(alerts.length).to eq(3)
          expect(alerts.map(&:class)).to eq([String, String, String])
        end
      end
    end
  end

  describe 'Integration Tests' do
    it 'complete salmon monitoring scenario' do
      # Create readings for salmon tank
      normal_reading = SensorReading.new(temperature: 15.0, ph: 7.5, dissolved_oxygen: 8.0)
      problem_reading = SensorReading.new(temperature: 22.0, ph: 7.5, dissolved_oxygen: 8.0)
      critical_reading = SensorReading.new(temperature: 22.0, ph: 9.5, dissolved_oxygen: 4.0)

      checker = WaterQualityChecker.new(SalmonProfile.new)

      # Normal conditions should have no alerts
      expect(checker.check(normal_reading)).to be_empty

      # One parameter violation
      problem_alerts = checker.check(problem_reading)
      expect(problem_alerts.length).to eq(1)

      # Multiple violations
      critical_alerts = checker.check(critical_reading)
      expect(critical_alerts.length).to eq(3)
    end

    it 'complete tilapia monitoring scenario' do
      # Create readings for tilapia tank
      normal_reading = SensorReading.new(temperature: 27.0, ph: 7.8, dissolved_oxygen: 6.0)
      problem_reading = SensorReading.new(temperature: 31.0, ph: 7.8, dissolved_oxygen: 6.0)

      checker = WaterQualityChecker.new(TilapiaProfile.new)

      # Normal conditions should have no alerts
      expect(checker.check(normal_reading)).to be_empty

      # Violation
      problem_alerts = checker.check(problem_reading)
      expect(problem_alerts.length).to eq(1)
    end

    it 'species-specific monitoring with same reading' do
      # A reading that is safe for tilapia but dangerous for salmon
      reading = SensorReading.new(temperature: 28.0, ph: 8.0, dissolved_oxygen: 6.0)

      salmon_checker = WaterQualityChecker.new(SalmonProfile.new)
      tilapia_checker = WaterQualityChecker.new(TilapiaProfile.new)

      # Should alert for salmon (too warm, DO too low)
      salmon_alerts = salmon_checker.check(reading)
      expect(salmon_alerts.length).to eq(2)

      # Should be safe for tilapia
      tilapia_alerts = tilapia_checker.check(reading)
      expect(tilapia_alerts).to be_empty
    end
  end
end
