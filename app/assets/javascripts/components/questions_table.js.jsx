var QuestionsTable = React.createClass({
  getDefaultProps: function() {
    return { candidates: [],
             questions: [],
             template_tags: [],
             template_questions: [],
             handleAdd: function() { },
             handleRemove: function() { },
             handleChange: function() { } }
  },
  render: function() {
    var questions_headers = _.map(this.props.candidates, function(candidate, index) {
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
        questions = _.map(this.props.questions, function(question) {
          return <Question {...question}
                           answers={question.answers}
                           candidates={this.props.candidates}
                           template_tags={this.props.template_tags}
                           key={question.id}
                           handleChange={this.props.handleChange}
                           handleRemove={this.props.handleRemove} />
        }, this)

    var table_display = this.props.questions.length < 1 ? 'none' : 'block'

    return <div>
      <div className="mui-row">
        <div className="questions--form">
          <h3>Questions</h3>
          <table className="questions" style={{ display: table_display }}>
            <thead><tr><th></th><th></th>{ questions_headers }</tr></thead>
            <tbody>{ questions }</tbody>
          </table>
        </div>
      </div>
      <div className="mui-row">
        <div className="mui--pull-right">
          <AddQuestion ref="add_question"
                       handleAdd={ this.props.handleAdd }
                       template_questions={this.props.template_questions} />
        </div>
      </div>
    </div>
  }
})
