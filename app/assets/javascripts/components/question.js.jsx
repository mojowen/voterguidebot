var Question = React.createClass({
  mixins: [Template, Draggable],
  getDefaultProps: function() {
    return { candidates: [],
             answers: null,
             tags: null,
             text: '',
             id: null,
             handleChange: function() {  } }
  },
  handleAnswerChange: function(event) {
    var answers = this.props.answers || [],
        text = event.target.value,
        index = parseInt(event.target.name.match(/\d+/)[0]),
        questions = this.props.questions,
        candidate = this.props.candidates[index],
        answer = _.find(this.props.answers, function(answer) {
          return answer.candidate_id === candidate.id
        })

    if( answer ) {
      answers[_.indexOf(this.props.answers, answer)].text = text
    } else {
      answer = { candidate_id: candidate.id, question_id: this.props.id, text: text }
      answers.push(answer)
    }

    questions[this.props.index].answers = answers

    this.props.handleChange({ questions: questions })
  },
  handleChange: function(event) {
    var questions = this.props.questions
    questions[this.props.index][event.target.name] = event.target.value

    this.props.handleChange({ questions: questions })
  },
  handleRemove: function(event) {
    var questions = this.props.questions,
        question = questions[this.props.index]

    vgConfirm('Are you sure you want to remove this question?', function(conf) {
      if( !conf ) return
      this.props.handleChange({ questions: _.without(questions, question) })
    }, this)
  },
  removeTag: function(tag) {
    var tags = this.props.tags || [],
        questions = this.props.questions

    questions[this.props.index].tags = _.without(tags, _.find(tags, { name: tag }))
    this.props.handleChange({ questions: questions })
  },
  addTag: function(tag) {
    var tags = this.props.tags || [],
        questions = this.props.questions

    tags.push({ name: tag, tagged_id: this.props.id, tagged_type: 'question' })

    questions[this.props.index].tags = tags
    this.props.handleChange({ questions: questions })
  },
  handleDragOver: function(current_id, replaced_id) {
    var questions = this.props.questions,
        current = questions[current_id],
        replaced = questions[replaced_id]

    questions[replaced_id] = current
    questions[current_id] = replaced

    this.props.handleChange('questions', questions)
  },
  render: function() {
    var candidates = _.map(this.props.candidates, function(candidate, index) {
                      var answer = _.find(this.props.answers || [], function(answer) {
                                    return answer.candidate_id === candidate.id
                                  })

                      return <td key={candidate.id}>
                              <InputComponent name={'candidate_'+index}
                                              value={answer ? answer.text : ''}
                                              onChange={this.handleAnswerChange}
                                              placeholder="..." />
                            </td>
                    }, this)

    return <tr {...this.draggable_props()}>
      <td className="remover">
        { this.draggable() }
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
