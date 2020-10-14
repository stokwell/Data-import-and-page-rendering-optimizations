require 'oj'

class DbImporter
  def initialize
    @cities = {}
    @services = {}
    @buses = {}
  end

  def call(source:)
    json = Oj.load_file(source)

    ActiveRecord::Base.transaction do
      clear_db!
      create_from_json!(json)
    end
  end

  private

  attr_reader :cities, :services, :buses

  def clear_db!
    City.delete_all
    Bus.delete_all
    Service.delete_all
    Trip.delete_all
    ActiveRecord::Base.connection.execute('delete from buses_services;')
  end

  def create_from_json!(json)
    import_cities_and_services(json)
    import_buses(json)
    import_trips(json)
  end

  def import_cities_and_services(json)
    json.each do |trip|
      cities[trip['from']] ||= City.new(name: trip['from'])
      cities[trip['to']] ||= City.new(name: trip['to'])

      trip['bus']['services'].each do |service|
       services[service] ||= Service.new(name: service)
      end
    end
      City.import %i[name], cities.values, syncronize: true, raise_error: true
      Service.import %i[name], services.values, syncronize: true, raise_error: true
  end

  def import_buses(json)
    json.each do |trip|
      bus = buses[trip['bus']['number']] || Bus.new(number: trip['bus']['number'])
      bus.model = trip['bus']['model']
      bus.services = services.values_at(*trip['bus']['services'])
      buses[trip['bus']['number']] = bus
    end

    Bus.import buses.values, recursive: true, syncronize: true, raise_error: true
  end

  def import_trips(json)
    trips = []
  
    json.each do |trip|
      from = cities[trip['from']]
      to = cities[trip['to']]

      trips << Trip.new(
        from: from,
        to: to,
        bus: buses[trip['bus']['number']],
        start_time: trip['start_time'],
        duration_minutes: trip['duration_minutes'],
        price_cents: trip['price_cents']
      )
    end

    Trip.import trips, raise_error: true
  end

end