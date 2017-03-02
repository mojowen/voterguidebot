var LookupComponent = React.createClass({
  getDefaultProps: function() {
    return {
      onChange: function() { return true },
      onValidate: function() { return true },
      value: ''
    }
  },
  isValid: function() { return this.state.valid },
  getInitialState: function() {
    return {
      loading: false,
      valid: true,
      value: this.props.value,
      params: 'key'
    }
  },
  debounceDelay: 500,
  request: function(key, value) {
    var url = this.props.url + '?' + this.props.param +'='+ escape(this.state.value)

    return superagent.get(url)
             .set('X-CSRF-Token', CSRF.token())
             .set('Accept', 'application/json')
  },
  lookup: function() {
    if( this.state.loading ) return

    this.setState({ loading: true, valid: false })

    var that = this
    this.request()
        .end(function(err, res) {
          if( err ) return that.handleError(res.body)
          that.handleSuccess()
        })
  },
  handleSuccess: function() {
    this.setState({ valid: true, loading: false })
    this.props.onChange({ target: { value: this.state.value }})
    this.props.onValidate(true)
  },
  handleError: function() {
    this.setState({ valid: false, loading: false })
    this.props.onValidate(false, this.props.error_message)
  },
  handleChange: function(event) {
    this.setState({ value: event.target.value })
    this.debounceRequest = this.debounceRequest || _.debounce(this.lookup, this.debounceDelay)
    this.debounceRequest()
  },
  render: function() {
    return <input onChange={this.handleChange} value={this.state.value} />
  }
})
