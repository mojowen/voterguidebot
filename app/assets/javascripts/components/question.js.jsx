var Question = React.createClass({
  mixins: [Template],
  getDefaultProps: function() {
    return { candidates: [],
             answers: null,
             tags: null,
             text: '',
             id: null,
             handleRemove: function() {  },
             handleChange: function() {  } }
  },
  handleAnswerChange: function(event) {
    var answers = this.props.answers || [],
        text = event.target.value,
        index = event.target.name.split('_').reverse()[0],
        candidate = this.props.candidates[index],
        answer = _.find(this.props.answers, function(answer) {
          return answer.candidate_id === candidate.id
        })

    if( !answer ) {
      answer = { candidate_id: candidate.id, question_id: this.props.id, text: text }
      answers.push(answer)
    } else {
      answers[_.indexOf(this.props.answers, answer)].text = text
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
    var tags = _.without(this.props.tags || [], _.find(this.props.tags || [], { name: tag }))
    this.props.handleChange(this.props.id, 'tags', tags)
  },
  addTag: function(tag) {
    var tags = this.props.tags || []
    tags.push({ name: tag, tagged_id: this.props.id, tagged_type: 'question' })
    this.props.handleChange(this.props.id, 'tags', tags)
  },
  render: function() {
    var candidates = _.map(this.props.candidates, function(candidate, index) {
                      var answer = _.find(this.props.answers || [], function(answer) {
                                    return answer.candidate_id == candidate.id
                                  })

                      return <td key={candidate.id}>
                              <InputComponent name={'candidate_'+index}
                                              value={answer ? answer.text : ''}
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
                        element="textarea"
                        limit={this.props.template.questions.text.limit}
                        placeholder="Add Your Question"
                        onChange={this.handleChange} />
        <Taggable tags={this.props.tags}
                  id={this.props.id}
                  available_tags={this.props.template.tags}
                  tagged_type='Question'
                  removeTag={this.removeTag}
                  addTag={this.addTag} />
        </td>
      { candidates }
    </tr>
  }
})
