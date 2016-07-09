var QuestionsTable = React.createClass({
  mixins: [Template],
  getDefaultProps: function() {
    return { candidates: [],
             questions: [],
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
                           key={question.id}
                           template={this.props.template}
                           handleChange={this.props.handleChange}
                           handleRemove={this.props.handleRemove} />
        }, this),
      table_display = this.props.questions.length < 1 ? 'none' : 'block'
      add_display = this.props.questions.length >= this.props.template.questions.max ? 'none' : 'block'

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
      <div className="mui-row" >
        <div className="mui--pull-right" style={{ display: add_display }}>
          <AddQuestion ref="add_question"
                       handleAdd={ this.props.handleAdd }
                       template={this.props.template} />
        </div>
      </div>
    </div>
  }
})
