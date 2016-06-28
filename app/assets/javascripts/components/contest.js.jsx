var Contest = React.createClass({
  mixins: [NewObject, HandleChange],
  getDefaultProps: function() {
    return { candidates: [],
             questions: [],
             template_tags: [],
             template_questions: [],
             answers: [],
             title: '',
             description: '' }
  },
  componentDidMount: function() {
    var candidates = this.state.candidates,
        questions = this.state.questions

    if( candidates.length === 0 ) {
      candidates.push(this.newObject('candidate'))
    }

    this.setState({ candidates: candidates, questions: questions })
  },
  getInitialState: function() {
    return { candidates: this.props.candidates,
             _candidates: [],
             questions: this.props.questions.concat(this.props.template_questions),
             _questions: [],
             answers: this.props.answers,
             title: this.props.title,
             description: this.props.description }
  },
  handleClickToAddCandidate: function(event) {
    var candidates = this.state.candidates
    candidates.push(this.newObject('candidate', { endorsements: [] }))
    this.setChangedState({ candidates: candidates })
    event.preventDefault()
  },
  handleCandidateChange: function(id, key, value) {
    var index = _.map(this.state.candidates,'id').indexOf(id),
        candidates = this.state.candidates

    candidates[index][key] = value
    this.setChangedState({ candidates: candidates })
  },
  handleCandidateRemove: function(id) {
    var index = _.map(this.state.candidates,'id').indexOf(id),
        candidates = this.state.candidates,
        candidate = candidates[index]

    vgConfirm('Are you sure you want to remove this candidate?', function(confirmed) {
      if( !confirmed ) return

      var destroyed = this.state._candidates

      if( !candidate.new ) destroyed.push(candidate.id)

      this.setChangedState({
        candidates: _.without(candidates, candidate),
        _candidates: destroyed
      })
    }, this)
  },
  handleClickToAddQuestion: function(event) {
    var questions = this.state.questions
    questions.push(this.newObject('question'))
    this.setChangedState({ questions: questions })
    event.preventDefault()
  },
  handleQuestionChange: function(id, key, value) {
    var index = _.map(this.state.questions,'id').indexOf(id),
        questions = this.state.questions

    questions[index][key] = value
    this.setChangedState({ questions: questions })
  },
  handleQuestionRemove: function(id) {
    var index = _.map(this.state.questions,'id').indexOf(id),
        questions = this.state.questions,
        question = questions[index]

    vgConfirm('Are you sure you want to remove this question?', function(confirmed) {
      if( !confirmed ) return

      var destroyed = this.state._questions

      if( !question.new ) destroyed.push(question.id)

      this.setChangedState({
        questions: _.without(questions, question),
        _questions: destroyed
      })
    }, this)
  },
  render: function() {
    return <div className="mui-col-md-11">
      <ContestDetails title={this.state.title}
                      description={this.state.description}
                      handleChange={this.handleChange} />
      <Candidates candidates={this.state.candidates}
                  handleChange={this.handleCandidateChange}
                  handleRemove={this.handleCandidateRemove}
                  handleAdd={this.handleClickToAddCandidate} />
      <QuestionsTable candidates={this.state.candidates}
                      questions={this.state.questions}
                      template_tags={this.props.template_tags}
                      handleChange={this.handleQuestionChange}
                      handleAdd={this.handleClickToAddQuestion}
                      handleRemove={this.handleQuestionRemove} />

    </div>
  }
})
