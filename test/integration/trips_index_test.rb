require 'test_helper'

class TripsIndexTest < ActionDispatch::IntegrationTest
  def setup
    DbImporter.new.call(source: 'test/fixtures/files/trip_import.json')
  end

  test 'responds with success status' do
    make_request

    assert_response :success
  end

  test 'displays all relevant records' do
    make_request

    assert response.body.include?('В расписании 5 рейсов')

    Trip.where(from: 'Самара', to: 'Москва').find_each do |trip|
      assert response.body.include?("Отправление: #{trip.start_time}")
      assert response.body.include?("Автобус: #{trip.bus.model} №#{trip.bus.number}")
    end
  end

  def make_request
    get URI.encode('/автобусы/Самара/Москва')
  end
end
