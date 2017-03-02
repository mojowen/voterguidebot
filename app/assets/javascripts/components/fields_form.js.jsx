var FieldsForm = React.createClass({
  mixins: [FormBase],
  getDefaultProps: function() {
    return { fields: [] }
  },
  handleSubmit: function(event) {
    event.preventDefault()
    this.saveGuide()
  },
  saveGuide: function() {
    var fields_request = {}

    for (var i = 0; i < this.props.fields.length; i++) {
      var name = this.props.fields[i].name,
          elem = this.refs[name]

      if( !elem.isValid() ) {
        return this.handleError({ error: 'Not All Fields Are Valid' })
      }

      fields_request[name] =  elem.state.value
    }

    this.updateGuide(this.props.url, { guide: { fields: fields_request }})
  },
  render: function() {
    var fields = _.map(this.props.fields, function(field) {
      return <FieldFormRow ref={field.name}
                           key={field.name+'_form_row'}
                           changeNotifier={this.changeNotifer}
                           {...field} />
    }, this)
    return <div>
            <form ref="form_wrapper" onSubmit={this.handleSubmit}>
              { fields }
            </form>
            { this.menuComponent() }
          </div>

  }
})
