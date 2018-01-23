var Contest = React.createClass({
  mixins: [NewObject, HandleChange, Template],
  getDefaultProps: function() {
    return { id: false,
             candidates: [],
             questions: [],
             answers: [],
             title: '',
             description: '' }
  },
  componentDidMount: function() {
    var candidates = this.state.candidates,
        questions = this.state.questions

    if( candidates.length === 0 ) {
      candidates.push(this.newObject('candidate', { start_open: true }))
    }

    this.setState({ candidates: candidates, questions: questions })
  },
  getInitialState: function() {
    return { candidates: this.props.candidates,
             questions: this.props.questions,
             answers: this.props.answers,
             title: this.props.title,
             description: this.props.description }
  },
  render: function() {
    return <div>
      <ContestDetails ref="details"
                      title={this.state.title}
                      description={this.state.description}
                      template={this.props.template}
                      handleChange={this.handleChange}
                      contest_layout={this.props.contest_layout} />
      <Candidates ref="candidates"
                  candidates={this.state.candidates}
                  template={this.props.template}
                  handleChange={this.handleChange}
                  contest_layout={this.props.contest_layout} />
      <QuestionsTable ref="questions"
                      candidates={this.state.candidates}
                      questions={this.state.questions}
                      template={this.props.template}
                      handleChange={this.handleChange}
                      contest_layout={this.props.contest_layout} />

    </div>
  }
})
