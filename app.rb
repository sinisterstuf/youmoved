# Set up Sinatra for web
require 'sinatra'
require 'net/http'
set :server, 'thin'
base_url = ''

# Set up Redis for slight persistence
require 'redis'
redis = Redis.new(:url => ENV['REDISTOGO_URL'])

# Set up Geokit for distance calculation
require 'openssl'
require 'geokit'

# Constants
yoapi_url  = 'https://api.justyo.co/yo'
yotext_url = 'http://yotext.co/show/?text='
postdata = { api_token: ENV['YO_KEY'] }

get '/' do

    logger.info "got request"
    logger.info "#{ENV['RUN_MODE']} mode"
    logger.info "only Yo to #{ENV['TEST_USER']}" if ENV['RUN_MODE'] == 'TEST'

    if params.key?('username')
        user = params['username']
    else
        logger.error "missing username"
        return 'failure: bad request'
    end

    if params.key?('location')
        current = params['location']

        # get location from redis by name
        last = redis.get(user)

        if last.nil?
            # location in redis expired
            text = "you haven't Yo'd in the last 24 hours"
        else
            text = calculate_distance current last
        end
    else
        # person sent a regular Yo
        text = 'send a location @Yo to see how far you moved'
    end

    logger.info text
    postdata[:username] = user
    postdata[:link] = yotext_url + text

    # send the Yo
    status = Net::HTTP.post_form(URI.parse(yoapi_url + '/'), postdata)

    # terse status response
    if status
        logger.info 'success'
        'success'
    else
        logger.info 'failed to YoAll'
        'failed to YoAll'
    end

end

def calculate_distance current, last

    # actual calculate distance
    a = Geokit::LatLng.normalize(last.split(';'))
    b = Geokit::LatLng.normalize(current.split(';'))
    distance = a.distance_to(b)

    # save current location
    redis.set(user, current)

    # clear users inactive for 24 hours
    redis.expire(user, 60*60*24)

    # determine scale of movement
    text =
        if distance < 0.005
            "you've barely moved!"
        elsif distance < 1
            "#{distance*1000} m"
        else
            "#{distance} km"
        end
end
