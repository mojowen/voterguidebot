var MeasureForm = React.createClass({
  mixins: [FormBase],
  getDefaultProps: function() {
    return { measure: { id: false },
             url: document.location.pathname }
  },
  componentDidMount: function() {
    if( !this.props.measure.id ) this.setState({ method: 'post' })
  },
  handleSubmit: function(event) {
    var measure = this.refs.measure,
        measure_data = {
          title: measure.state.title,
          description: measure.state.description,
          yes_means: measure.state.yes_means,
          no_means: measure.state.no_means,
          endorsements: measure.state.endorsements
        }

    this.updateGuide(
      this.props.url,
      { measure: measure_data },
      function(res) {
        measure.setState(res.body.state.measure)
      }
    )
    event.preventDefault()
  },
  render: function() {
    return <form autoComplete="off" ref="form_wrapper" onSubmit={this.handleSubmit}>
            <Measure ref="measure" {...this.props.measure} />
            { this.menuComponent() }
          </form>
  }
})
