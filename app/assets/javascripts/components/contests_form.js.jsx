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
    var contest = this.refs.contest,
        contests_request = {
          title: contest.state.title,
          description: contest.state.description,
          candidates: _.map(contest.state.candidates, function(candidate) {
                        return _.omit(candidate, ['endorsements']) })
                      .concat(contest.state._candidates),
          endorsements: _.chain(contest.state.candidates)
                         .map(function(candidate) {
                            return _.chain(candidate.endorsements)
                                    .map(function(endorser) {
                                      return [ { endorsing_id: candidate.id,
                                                 endorsing_type: 'candidate',
                                                 endorser: endorser }] })
                                    .value() })
                         .flatten()
                         .value(),
          questions: _.map(contest.state.questions, function(question){
                        return _.pick(question, ['text','id']) })
                      .concat(contest.state._questions),
          answers: _.chain(contest.state.questions)
                    .map(function(question) {
                        return _.chain(question)
                                .pick(_.map(contest.state.candidates, 'id'))
                                .map(function(value, key) {
                                  return [ { candidate_id: key,
                                             text: value,
                                             question_id: question.id } ] })
                                .value() })
                    .flatten()
                    .value()
        }

    this.updateGuide(
      this.props.url,
      { contest: contests_request },
      function(res) {
        contest.setState(_.extend({ _candidates: [], _questions: [] },
                                  res.body.state.contest))
      }
    )
    event.preventDefault()
  },
  render: function() {
    return <form autoComplete="off" ref="form_wrapper" onSubmit={this.handleSubmit}>
            <Contest ref='contest'  {...this.props.contest} />
            { this.menuComponent() }
          </form>
  }
})
