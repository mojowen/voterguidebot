
require 'net/http'

Location::STATES.each do |state_abv, state_name|

  guide_name = "#{state_name} Voter Guide"
  next if Guide.find(guide_name)

  uri = URI("https://maps.googleapis.com/maps/api/geocode/json?" \
            "key=#{ENV['GOOGLE_MAPS_API']}&address=#{state_name}")
  location_data = JSON.parse(Net::HTTP.get(uri))
  result = location_data['results'].first

  location = Location.new lat: result['geometry']['location']['lat'],
                          lng: result['geometry']['location']['lng'],
                          west: result['geometry']['bounds']['southwest']['lng'],
                          east: result['geometry']['bounds']['northeast']['lng'],
                          north: result['geometry']['bounds']['northeast']['lat'],
                          south: result['geometry']['bounds']['southwest']['lat']

  Guide.create! location: location,
                users: User.where(admin: true),
                name: guide_name,
                template_name: :state

  puts "Created #{guide_name}"
end
