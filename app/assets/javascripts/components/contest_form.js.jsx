var ContestForm = React.createClass({
  mixins: [FormBase],
  getDefaultProps: function() {
    return { contest: { id: false } }
  },
  componentDidMount: function() {
    if( !this.props.contest.id ) this.setState({ method: 'post' })
  },
  handleSubmit: function(event) {
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
        if( that.state.method !== 'patch' ) that.setState({ method: 'patch' })
        contest.setState(res.body.contest)
      }
    )
    event.preventDefault()
  },
  render: function() {
    return <form autoComplete="off" ref="form_wrapper" onSubmit={this.handleSubmit}>
            <Contest ref='contest'
                     {...this.props.contest} />
            { this.menuComponent() }
          </form>
  }
})
