var ContestForm = React.createClass({
  mixins: [FormBase],
  getDefaultProps: function() {
    return { contest: { id: false },
             url: document.location.pathname }
  },
  componentDidMount: function() {
    if( !this.props.contest.id ) this.setState({ method: 'post' })
  },
  handleSubmit: function(event) {
    var contest = this.refs.contest

    this.updateGuide(
      this.props.url,
      { contest: {
          title: contest.state.title,
          description: contest.state.description,
          candidates: contest.state.candidates,
          questions: contest.state.questions
      }},
      function(res) {
        Turbolinks.visit(res.body.path)
        contest.setState(_.extend({ method: res.body.state.contest.id ? 'put' : 'post' },
                                  res.body.state.contest))
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