var AddQuestion = React.createClass({
  mixins: [NewObject, Template],
  getDefaultProps: function() {
    return { template_questions: [],
             handleAdd: function() { } }
  },
  getInitialState: function() {
    return { picking: false }
  },
  handleEndAddQuestion: function(event) {
    this.setState({ picking: false })
    event.preventDefault()
  },
  handleAddQuestionStart: function(event) {
    this.setState({ picking: true })
    event.preventDefault()
  },
  handleAddBlank: function(event) {
    this.props.handleAdd(this.newObject('question'))
    this.setState({ picking: false })
    event.preventDefault()
  },
  handleAddSelected: function(event) {
    var selected_question = _.find(this.props.template.questions.samples,
                                   { text: event.target.value })
    selected_question.tags = [{ name: selected_question.tag }]
    this.props.handleAdd(this.newObject('question', selected_question))
    this.setState({ picking: false })
  },
  render: function() {
    if( this.state.picking ) {
      var template_questions = _.chain(this.props.template.questions.samples)
                                .groupBy('tag')
                                .map(function(tag, name) {
                                  var tags = _.map(tag, function(question) {
                                    return <option value={question.text} key={question.text}>
                                      Do you support {question.text}
                                    </option> })
                                  return <optgroup key={name} label={name}>{ tags }</optgroup> })
                                .value()

      return <div className="add--question mui-panel mui-col-md-offset-3 mui-col-md-6">
        <a href="#" onClick={this.handleEndAddQuestion} className="remove">
          <i className="fa fa-times" />
        </a>
        <h4>Add Question</h4>
        <div className="tags--select mui-select">
          <select onChange={this.handleAddSelected} className="">
            <option>{['Select Question ',String.fromCharCode(187)].join(' ')}</option>
            { template_questions }
          </select>
        </div>
        <div className="mui--text-center">
          <em style={{ marginRight: '10px' }}>or</em>
          <a onClick={ this.handleAddBlank }
             className="mui-btn mui-btn--small mui-btn--primary">
              <i className="fa fa-plus-circle" /> Add Blank Question</a>
          <br />
        </div>
      </div>
    }

    return <a onClick={ this.handleAddQuestionStart }
              className="mui-btn mui-btn--accent">
                <i className="fa fa-plus-circle" /> Add Question
            </a>
  }
})
