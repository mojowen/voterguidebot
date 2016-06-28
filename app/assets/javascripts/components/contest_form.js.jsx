var ContestForm = React.createClass({
  mixins: [FormBase],
  getDefaultProps: function() {
    return { contest: { id: false },
             template_tags: [],
             template_questions: [],
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
          candidates: contest.state.candidates.concat(contest.state._candidates),
          questions: contest.state.questions.concat(contest.state._questions)
      }},
      function(res) {
        contest.setState(_.extend({ _candidates: [], _questions: [] },
                                  res.body.state.contest))
      }
    )
    event.preventDefault()
  },
  render: function() {
    return <form autoComplete="off" ref="form_wrapper" onSubmit={this.handleSubmit}>
            <Contest ref='contest'
                     template_tags={this.props.template_tags}
                     template_questions={this.props.template_questions}
                     {...this.props.contest} />
            { this.menuComponent() }
          </form>
  }
})
