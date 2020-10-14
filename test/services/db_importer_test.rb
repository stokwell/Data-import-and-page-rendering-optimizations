require 'test_helper'

class DbImporterTest < ActiveSupport::TestCase
  test 'imports all presented records' do
    assert_difference 'Trip.count', 10 do
      import!
    end
  end

  test 'correctly populates records attributes' do
    import!

    actual_trip = Trip.first.to_h
    expected_trip = {
      from: 'Москва',
      to: 'Самара',
      start_time: '11:00',
      duration_minutes: 168,
      price_cents: 474,
      bus: { number: '123', model: 'Икарус', services: %w[Туалет WiFi] }
    }

    assert_equal expected_trip, actual_trip
  end

  private

  def import!
    DbImporter.new.call(source: 'test/fixtures/files/trip_import.json')
  end
end