var QuestionsTable = React.createClass({
  getDefaultProps: function() {
    return { candidates: [],
             questions: [],
             template_tags: [],
             handleAdd: function() { },
             handleRemove: function() { },
             handleChange: function() { } }
  },
  render: function() {
    if( this.props.questions.length < 1 ) return <table className="questions"></table>

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
                           candidates={this.props.candidates}
                           template_tags={this.props.template_tags}
                           key={question.id}
                           handleChange={this.props.handleChange}
                           handleRemove={this.props.handleRemove} />
        }, this)


    return <div>
      <div className="mui-row">
        <div className="questions--form">
          <h3>Questions</h3>
          <table className="questions">
            <thead><tr><th></th><th></th>{ questions_headers }</tr></thead>
            <tbody>{ questions }</tbody>
          </table>
        </div>
      </div>
      <div className="mui-row">
        <div className="mui--pull-right">
          <a onClick={ this.handleAdd }
              className="mui-btn mui-btn--accent">
            <i className="fa fa-plus-circle" /> Add Question
          </a>
        </div>
      </div>
    </div>
  }
})
