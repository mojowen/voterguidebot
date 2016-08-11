var MeasureForm = React.createClass({
  mixins: [FormBase],
  getDefaultProps: function() {
    return { measure: { id: false },
             template_tags: [],
             url: document.location.pathname }
  },
  componentDidMount: function() {
    if( !this.props.measure.id ) this.setState({ method: 'post' })
  },
  handleSubmit: function(event) {
    var that = this,
        measure = this.refs.measure,
        measure_data = {
          title: measure.state.title,
          description: measure.state.description,
          yes_means: measure.state.yes_means,
          no_means: measure.state.no_means,
          endorsements: measure.state.endorsements,
          tags: measure.state.tags
        }

    this.updateGuide(
      this.props.url,
      { measure: measure_data },
      function(res) {
        if( that.state.method !== 'patch' ) that.setState({ method: 'patch' })
        measure.setState(res.body.measure)
      }
    )
    event.preventDefault()
  },
  render: function() {
    return <form autoComplete="off" ref="form_wrapper" onSubmit={this.handleSubmit}>
            <Measure ref="measure"
              template_tags={this.props.template_tags}
              {...this.props.measure} />
            { this.menuComponent() }
          </form>
  }
})
