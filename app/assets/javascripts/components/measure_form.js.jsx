var MeasureForm = React.createClass({
  mixins: [FormBase, Expropriator],
  getDefaultProps: function() {
    return { measure: { id: false },
             template_tags: [],
             url: document.location.pathname }
  },
  componentDidMount: function() {
    if( !this.props.measure.id ) this.setNewObjectState()
  },
  handleSubmit: function(event) {
    event.preventDefault()
    this.saveGuide()
  },
  anchor: function() {
    if( !this.props.measure.id ) return ''
    return '#measure-'+this.props.measure.id
  },
  saveGuide: function() {
    var that = this,
        measure = this.refs.measure,
        measure_data = {
          title: measure.state.title,
          description: measure.state.description,
          stance: measure.state.stance,
          yes_means: measure.state.yes_means,
          no_means: measure.state.no_means,
          endorsements: measure.state.endorsements,
          tags: measure.state.tags
        }

    this.updateGuide(
      this.state.url,
      { measure: measure_data },
      function(res) {
        measure.setState(res.body.measure)
      }
    )
  },
  render: function() {
    var elem_class = this.props.measure_layout === 'one_page' ? 'Measure' : 'HalfMeasure'
        MeasureElem = to_react_class(elem_class)
    return <div>
      <form autoComplete="off" ref="form_wrapper" onSubmit={this.handleSubmit}>
        <MeasureElem ref="measure"
                 template_tags={this.props.template_tags}
                 changeNotifier={this.changeNotifer}
                 {...this.props.measure} />
      </form>
      { this.menuComponent({ after: this.expropriator(this.props.measure.id) }) }
    </div>
  }
})
