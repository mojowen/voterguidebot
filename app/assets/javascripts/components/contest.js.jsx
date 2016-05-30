var Contest = React.createClass({
  mixins: [NewObject],
  getDefaultProps: function() {
    return { candidates: [],
             questions: [],
             name: '',
             description: '',
             print: false }
  },
  componentDidMount: function() {
    var candidates = this.state.candidates,
        questions = this.state.questions

    if( candidates.length === 0 ) candidates.push(this.newObject('candidate'))
    if( questions.length === 0 ) questions.push(this.newObject('question'))

    this.setState({ candidates: candidates, questions: questions })
  },
  getInitialState: function() {
    return { candidates: this.props.candidates,
             questions: this.props.questions,
             name: this.props.name,
             description: this.props.description,
             print: this.props.print }
  },
  handleClickToAddCandidate: function(event) {
    var candidates = this.state.candidates
    candidates.push(this.newObject('candidate', { endorsements: [] }))
    this.setState({ candidates: candidates })
    event.preventDefault()
  },
  handleCandidateChange: function(id, key, value) {
    var index = _.map(this.state.candidates,'id').indexOf(id),
        candidates = this.state.candidates

    candidates[index][key] = value
    this.setState({ candidates: candidates })
  },
  handleCandidateRemove: function(id) {
    var index = _.map(this.state.candidates,'id').indexOf(id),
        candidates = this.state.candidates,
        candidate = candidates[index],
        name = candidate.name || 'this candidate'

    if( confirm('Are you sure you want to remove '+ name +'?') ) {
      this.setState({ candidates: _.without(candidates, candidate) })
    }
  },
  handleClickToAddQuestion: function(event) {
    var questions = this.state.questions
    questions.push(this.newObject('question'))
    this.setState({ questions: questions })
    event.preventDefault()
  },
  handleQuestionChange: function(id, value) {
    var index = _.map(this.state.questions,'id').indexOf(id),
        questions = this.state.questions

    questions[index].question = value
    this.setState({ questions: questions })
  },
  handleQuestionRemove: function(id) {
    var index = _.map(this.state.questions,'id').indexOf(id),
        questions = this.state.questions,
        question = questions[index],
        name = question.question || 'this question'

    if( confirm('Are you sure you want to remove '+ name +'?') ) {
      this.setState({ questions: _.without(questions, question) })
    }
  },
  render: function() {
    var candidates = _.map(this.state.candidates, function(candidate) {
          return <Candidate {...candidate}
                            key={candidate.id}
                            handleChange={this.handleCandidateChange}
                            handleRemove={this.handleCandidateRemove}  />
        }, this),
        questions_headers = _.map(this.state.candidates, function(candidate, index) {
          if( !_.isEmpty(candidate.name) || !_.isEmpty(candidate.photo) ) {
            return <th key={'candidate_'+index} >
              <div className="profile" ></div>
              <span>{ candidate.name }</span>
            </th>
          } else {
            return <th key={'candidate_'+index} >
              <div className="profile unknown" ></div>
              <em>Candidate Name</em>
            </th>
          }
        }, this)
        questions = _.map(this.state.questions, function(question) {
          return <Question {...question}
                           candidates={this.state.candidates}
                           key={question.id}
                           handleChange={this.handleQuestionChange}
                           handleRemove={this.handleQuestionRemove} />
        }, this),
        questions_table = this.state.questions.length > 0 ? <table className="questions">
            <thead><tr><th></th>{ questions_headers }</tr></thead>
            <tbody>{ questions }</tbody>
          </table> : ''


    return <div className="mui-col-md-12">
      <div className="contest mui-row">
          <h2>Details</h2>
          <InputComponent name="name"
                          ref="name"
                          label="Name"
                          placeholder="Mayor of Gotham City" />
          <InputComponent name="description"
                          element="textarea"
                          ref='description'
                          label="Description"
                          placeholder="Responsible for running the city of Gotham - avoiding capture, etc." />
      </div>
      <div className="mui-row"><h2>Candidates</h2></div>
      <div className="mui-row">{ candidates }</div>
      <div className="mui-row">
        <a onClick={ this.handleClickToAddCandidate }
            className="mui-btn mui-btn--accent">
          <i className="fa fa-plus-circle" /> Add Candidate
        </a>
      </div>
      <div className="questions--form">
        <div className="mui-row"><h2>Questions</h2></div>
        <div className="mui-row">{ questions_table }</div>
        <div className="mui-row">
          <a onClick={ this.handleClickToAddQuestion }
              className="mui-btn mui-btn--accent">
            <i className="fa fa-plus-circle" /> Add Question
          </a>
        </div>
      </div>
    </div>
  }
})
