var Contest = React.createClass({
  mixins: [NewObject],
  getDefaultProps: function() {
    return { candidates: [],
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
    var questions = _.map(this.props.questions, function(question) {
      var answer_obj = _.reduce(question.answers, function(obj, answer){
        obj[answer.candidate_id] = answer.text
        return obj }, {})
      return _.extend(question, answer_obj)
    })

    var candidates = _.map(this.props.candidates, function(candidate) {
        candidate.endorsements = _.pluck(candidate.endorsements, 'endorser')
        return candidate
      })

    return { candidates: candidates,
             _candidates: [],
             questions: questions,
             _questions: [],
             answers: this.props.answers,
             title: this.props.title,
             description: this.props.description }
  },
  handleClickToAddCandidate: function(event) {
    var candidates = this.state.candidates
    candidates.push(this.newObject('candidate', { endorsements: [] }))
    this.setState({ candidates: candidates })
    event.preventDefault()
  },
  handleChange: function(event) {
    var new_state = {}
    new_state[event.currentTarget.name] = event.currentTarget.value
    this.setState(new_state)
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
      var destroyed = this.state._candidates

      if( !candidate.new ) destroyed.push({ id: candidate.id, _destroy: true })

      this.setState({
        candidates: _.without(candidates, candidate),
        _candidates: destroyed
      })
    }
  },
  handleClickToAddQuestion: function(event) {
    var questions = this.state.questions
    questions.push(this.newObject('question'))
    this.setState({ questions: questions })
    event.preventDefault()
  },
  handleQuestionChange: function(id, key, value) {
    var index = _.map(this.state.questions,'id').indexOf(id),
        questions = this.state.questions

    questions[index][key] = value
    this.setState({ questions: questions })
  },
  handleQuestionRemove: function(id) {
    var index = _.map(this.state.questions,'id').indexOf(id),
        questions = this.state.questions,
        question = questions[index],
        name = question.question || 'this question'

    if( confirm('Are you sure you want to remove '+ name +'?') ) {
      var destroyed = this.state._questions

      if( !question.new ) destroyed.push({ id: question.id, _destroy: true })

      this.setState({
        questions: _.without(questions, question),
        _questions: destroyed
      })
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
                           answers={this.state.answers}
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
          <h3>Details</h3>
          <InputComponent name="title"
                          label="title"
                          placeholder="Mayor of Gotham City"
                          ref='title'
                          value={ this.state.title }
                          onChange={ this.handleChange } />
          <InputComponent name="description"
                          element="textarea"
                          ref='description'
                          label="Description"
                          placeholder="Responsible for running the city of Gotham - avoiding capture, etc."
                          value={ this.state.description }
                          onChange={ this.handleChange } />
      </div>
      <div className="mui-row"><h3>Candidates</h3></div>
      <div className="mui-row">{ candidates }</div>
      <div className="mui-row">
        <div className="mui--pull-right">
          <a onClick={ this.handleClickToAddCandidate }
              className="mui-btn mui-btn--accent">
            <i className="fa fa-plus-circle" /> Add Candidate
          </a>
        </div>
      </div>
      <div className="questions--form">
        <div className="mui-row"><h3>Questions</h3></div>
        <div className="mui-row">{ questions_table }</div>
        <div className="mui-row">
          <div className="mui--pull-right">
            <a onClick={ this.handleClickToAddQuestion }
                className="mui-btn mui-btn--accent">
              <i className="fa fa-plus-circle" /> Add Question
            </a>
          </div>
        </div>
      </div>
    </div>
  }
})
