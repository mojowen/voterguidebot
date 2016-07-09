var Contest = React.createClass({
  mixins: [NewObject, HandleChange, Template],
  getDefaultProps: function() {
    return { id: false,
             candidates: [],
             questions: [],
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
             questions: this.props.questions,
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
  handleAddQuestion: function(question) {
    var questions = this.state.questions
    questions.push(question)
    this.setChangedState({ questions: questions })
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

    vgConfirm('Are you sure you want to remove this question?', function(conf) {
      if( !conf ) return

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
      <ContestDetails ref="details"
                      title={this.state.title}
                      description={this.state.description}
                      handleChange={this.handleChange} />
      <Candidates ref="candidates"
                  candidates={this.state.candidates}
                  template={this.props.template}
                  handleChange={this.handleCandidateChange}
                  handleRemove={this.handleCandidateRemove}
                  handleAdd={this.handleClickToAddCandidate} />
      <QuestionsTable ref="questions"
                      candidates={this.state.candidates}
                      questions={this.state.questions}
                      template={this.props.template}
                      handleChange={this.handleQuestionChange}
                      handleAdd={this.handleAddQuestion}
                      handleRemove={this.handleQuestionRemove} />

    </div>
  }
})
