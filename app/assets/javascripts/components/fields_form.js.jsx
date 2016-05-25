var FieldsForm = React.createClass({
  mixins: [UpdateGuide],
  getDefaultProps: function() {
    return { fields: [] }
  },
  handleSubmit: function(event) {
    event.preventDefault()
  },
  render: function() {
    var fields = _.map(this.props.fields, function(field) {
      return <FieldFormRow key={field.name+'_form_row'} {...field} />
    })
    return <form>{ fields }</form>
  }
})
