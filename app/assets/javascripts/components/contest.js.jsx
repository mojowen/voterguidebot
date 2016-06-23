var Contest = React.createClass({
  mixins: [NewObject, HandleChange],
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

    return { candidates: this.props.candidates,
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
    var candidates = _.map(this.state.candidates, function(candidate) {
          return <Candidate {...candidate}
                            key={candidate.id}
                            handleChange={this.handleCandidateChange}
                            handleRemove={this.handleCandidateRemove}  />
        }, this),
        questions_headers = _.map(this.state.candidates, function(candidate, index) {
          var has_photo = candidate.photo && !_.isEmpty(candidate.photo),
              bgImg = has_photo ? 'url('+candidate.photo+')' : '',
              className = 'profile'
          if( !has_photo ) className += ' unknown'
          return <th key={'candidate_'+index} >
                  <div className={className}
                       style={{ backgroundImage: bgImg }} ></div>
              <span>{ candidate.name || 'Candidate Name' }</span>
            </th>
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
            <thead><tr><th></th><th></th>{ questions_headers }</tr></thead>
            <tbody>{ questions }</tbody>
          </table> : ''


    return <div className="mui-col-md-11">
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
      <div className="mui-row">
        <div className="questions--form">
          <h3>Questions</h3>
          { questions_table }
        </div>
      </div>
      <div className="mui-row">
        <div className="mui--pull-right">
          <a onClick={ this.handleClickToAddQuestion }
              className="mui-btn mui-btn--accent">
            <i className="fa fa-plus-circle" /> Add Question
          </a>
        </div>
      </div>
    </div>
  }
})
