var ContestForm = React.createClass({
  mixins: [FormBase, Expropriator],
  getDefaultProps: function() {
    return { contest: { id: false } }
  },
  componentDidMount: function() {
    if( !this.props.contest.id ) this.setNewObjectState()
  },
  handleSubmit: function(event) {
    event.preventDefault()
    this.saveGuide()
  },
  anchor: function() {
    if( !this.props.contest.id ) return ''
    return '#contest-'+this.props.contest.id
  },
  saveGuide: function() {
    var that = this,
        contest = this.refs.contest

    this.updateGuide(
      this.state.url,
      { contest: {
          title: contest.state.title,
          description: contest.state.description,
          candidates: contest.state.candidates,
          questions: contest.state.questions
      }},
      function(res) {
        contest.setState(res.body.contest)
      }
    )
  },
  render: function() {
    return <div>
      <form autoComplete="off" ref="form_wrapper" onSubmit={this.handleSubmit}>
        <Contest ref='contest'
                 changeNotifier={this.changeNotifer}
                 {...this.props.contest} />
      </form>
      { this.menuComponent({ after: this.expropriator(this.props.contest.id) }) }
    </div>
  }
})
