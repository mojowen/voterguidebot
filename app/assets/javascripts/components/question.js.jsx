var Question = React.createClass({
  getDefaultProps: function() {
    return { candidates: [],
             answers: [],
             tags: [],
             template_tags: [],
             text: '',
             id: null,
             handleRemove: function() {  },
             handleChange: function() {  } }
  },
  answers: function() {
    var answers = {}
    for (var i = this.props.candidates.length - 1; i >= 0; i--) {
      var answer = _.find(this.props.answers, function(answer) {
        return answer.candidate_id == this.props.candidates[i].id
      }, this)
      answers[this.props.candidates[i].id] = answer
    }
    return answers
  },
  handleAnswerChange: function(event) {
    var answers = this.props.answers,
        text = event.target.value,
        candidate_id = event.target.name,
        answer = this.answers()[candidate_id]

    if( !answer ) {
      answer = { candidate_id: candidate_id, question_id: this.props.id, text: text }
      answers.push(answer)
    } else {
      answers[_.indexOf(answers, answer)].text = text
    }

    this.props.handleChange(this.props.id, 'answers', answers)
  },
  handleChange: function(event) {
    this.props.handleChange(this.props.id, event.target.name, event.target.value)
  },
  handleRemove: function(event) {
    this.props.handleRemove(this.props.id)
  },
  removeTag: function(tag) {
    var tags = _.without(this.props.tags, _.find(this.props.tags, { name: tag }))
    this.props.handleChange(this.props.id, 'tags', tags)
  },
  addTag: function(tag) {
    var tags = this.props.tags
    tags.push({ name: tag, question_id: this.props.id })
    this.props.handleChange(this.props.id, 'tags', tags)
  },
  render: function() {
    var candidates = _.map(this.props.candidates, function(candidate) {
                      var answer = this.answers()[candidate.id],
                          answer_text = answer ? answer.text : ''

                      return <td key={candidate.id}>
                              <InputComponent name={'candidate_'+candidate.id}
                                              value={answer_text}
                                              onChange={this.handleAnswerChange}
                                              placeholder="..." />
                            </td>
                    }, this)


    return <tr>
      <td className="remover">
        <a className="remove" onClick={this.handleRemove} >
          <i className="fa fa-times" />
        </a>
      </td>
      <td className="question">
        <InputComponent value={this.props.text}
                        name="text"
                        placeholder="Add Your Question"
                        handleChange={this.handleChange} />
        <Taggable tags={this.props.tags}
                  id={this.props.id}
                  template_tags={this.props.template_tags}
                  removeTag={this.removeTag}
                  addTag={this.addTag} />
        </td>
      { candidates }
    </tr>
  }
})
