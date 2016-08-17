var QuestionsTable = React.createClass({
  mixins: [Template],
  getDefaultProps: function() {
    return { candidates: [],
             questions: [],
             handleChange: function() { } }
  },
  handleAdd: function(question) {
    var questions = this.props.questions
    questions.push(question)
    this.props.handleChange({ questions: questions })
  },
  render: function() {
    var questions_headers = _.map(this.props.candidates, function(candidate, index) {
          return <th key={'candidate_'+index} ><SmallCandidate {...candidate} /></th>
        }, this)
        questions = _.map(this.props.questions, function(question, index) {
          return <Question {...question}
                           answers={question.answers}
                           candidates={this.props.candidates}
                           questions={this.props.questions}
                           key={question.id}
                           index={index}
                           template={this.props.template}
                           handleChange={this.props.handleChange} />
        }, this),
      table_display = this.props.questions.length < 1 ? 'none' : 'table'
      add_display = this.props.questions.length >= this.props.template.questions.max ? 'none' : 'block'

    return <div>
      <div className="mui-row">
        <div className="questions--form">
          <h3>Questions</h3>
          <div className="questions--wrap" >
            <table className="questions" style={{ display: table_display }}>
              <thead><tr><th></th><th></th>{ questions_headers }</tr></thead>
              <tbody>{ questions }</tbody>
            </table>
          </div>
        </div>
      </div>
      <div className="mui-row" >
        <div className="mui--pull-right" style={{ display: add_display }}>
          <AddQuestion ref="add_question"
                       handleAdd={ this.handleAdd }
                       template={this.props.template} />
        </div>
      </div>
    </div>
  }
})
