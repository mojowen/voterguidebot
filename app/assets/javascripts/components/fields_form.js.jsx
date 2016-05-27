var FieldsForm = React.createClass({
  mixins: [UpdateGuide],
  getDefaultProps: function() {
    return { fields: [] }
  },
  getInitialState: function() {
    return { icon: 'fa-save' }
  },
  handleError: function(message) {
    this.setState({ icon: 'fa-exclamation-triangle' })
    this.notify(message)
  },
  handleSuccess: function(message) {
    this.setState({ icon: 'fa-check-square' })
    this.notify(message)
  },
  notify: function(message) { alert(message) },
  handleSubmit: function(event) {
    var fields_request = {}

    for (var i = 0; i < this.props.fields.length; i++) {
      var name = this.props.fields[i].name,
          elem = this.refs[name]

      if( !elem.isValid() ) return this.handleError('not all fields are valid')

      fields_request[name] =  elem.state.value
    }

    this.sendFields(fields_request)
    event.preventDefault()
  },
  sendFields: function(fields_request) {
    var that = this
    this.setState({ icon: 'fa-circle-o-notch fa-spin' })
    this.updateGuide(
      this.props.url,
      { fields: fields_request },
      function(err, res) {
        if( err ) that.handleError('Something went wrong saving')
        else that.handleSuccess('success')
      })
  },
  render: function() {
    var fields = _.map(this.props.fields, function(field) {
      return <FieldFormRow ref={field.name}
                           key={field.name+'_form_row'}
                           {...field} />
    })
    return <form ref="form_wrapper" onSubmit={this.handleSubmit}>
            { fields }
            <div className="fixed--menu">
              <button type="submit" className="mui-btn mui-btn--accent">
                <i className={'fa ' + this.state.icon} /> Save
              </button>
            </div>
          </form>
  }
})
