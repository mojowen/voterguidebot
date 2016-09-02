var LocationSearch = React.createClass({
  getInitialState: function() {
    return { results: [],
             geocoder: false,
             address: this.props.address,
             state: this.props.state,
             city: this.props.city,
             lat: this.props.lat,
             lng: this.props.lng,
             lat: this.props.lat,
             north: this.props.north,
             south: this.props.south,
             east: this.props.east,
             west: this.props.west,
             typed_address: this.props.address }
  },
  getDefaultProps: function() {
    return { results: [],
             geocoder: false,
             address: null,
             state: null,
             city: null,
             lat: null,
             lng: null,
             north: null,
             south: null,
             east: null,
             west: null,
             typed_address: '' }
  },
  googleMapsReady: function() {
    if( typeof window.google === 'undefined' ) return false
    if( !this.state.geocoder ) {
      this.setState({ geocoder: new google.maps.Geocoder() })
    }

    return this.state.geocoder
  },
  handleChange: function(event) {
    if( this.googleMapsReady() && this.state.address !== event.target.value ) {
      _.debounce(this.geoCode(event.target.value), 500)
    }
    this.setState({ typed_address: event.target.value })
  },
  geoCode: function(address) {
    var that = this

    this.state.geocoder.geocode(
      { 'address': address},
      function(results, status) {
        if( status == google.maps.GeocoderStatus.OK ) {
          that.setState({ results: results })
        }
      }
    )
  },
  attachAddress: function(result) {
    var new_state = {
      city: '',
      state: '',
      lat: result.geometry.location.lat(),
      lng: result.geometry.location.lng(),
      west: result.geometry.bounds.getSouthWest().lng(),
      east: result.geometry.bounds.getNorthEast().lng(),
      north: result.geometry.bounds.getNorthEast().lat(),
      south: result.geometry.bounds.getSouthWest().lat(),
      address: result.formatted_address,
      typed_address: result.formatted_address,
      results: []
    }
    for (var i = result.address_components.length - 1; i >= 0; i--) {
      var component = result.address_components[i]
      if( component.types[0] === 'locality' ) {
        new_state.city = component.long_name
      }
      if( component.types[0] === 'administrative_area_level_1' ) {
        new_state.state = component.short_name
      }
    }
    this.setState(new_state)
  },
  render: function() {
    var after = '',
        location_fields =  ['city', 'state', 'address', 'lat', 'lng',
                            'north', 'south', 'east', 'west']

    if( this.state.results.length > 0 ) {
      after = _.map(this.state.results, function(result) {
        var that = this
        function handleAddressClick(event) {
          that.attachAddress(result)
          event.preventDefault()
        }
        return <li key={ result.place_id }>
          <a href="#" onClick={ handleAddressClick }>
            {result.formatted_address}
          </a>
        </li>
      }, this)
      after = <ul className="mui-panel">{ after }</ul>
    }

    location_fields = _.map(location_fields, function(field) {
      return <input key={field}
                    type="hidden"
                    value={ this.state[field] || '' }
                    name={ 'guide[location_attributes]['+field+']'} />
    }, this)

    return <div className="location--search">
      { location_fields }
      <InputComponent fa={ this.state.lat ? 'check' : null }
                      onChange={ this.handleChange }
                      placeholder="Enter a location for your guide"
                      id="location_box"
                      ref="input"
                      value={ this.state.typed_address }
                      after={ after } />
    </div>
  }
})
