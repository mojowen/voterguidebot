describe('Question', function() {

  var DummyTable = React.createClass({
    render: function() {
      return  React.createElement('table', { ref: 'table' },
        React.createElement('tbody', { ref: 'tbody' },
          React.createElement(Question, _.defaults({ ref: 'question' }, this.props))))
    }
  })

  beforeEach(function() {
    this.question = {
      id: 5,
      text: 'The Best Question',
      answers: [{ candidate_id: 1, text: 'Noop' }],
      tags: [{ name: 'LGBTQ' }, { name: 'Climate Change' }]
    }
    this.props = _.defaults(this.question, {
      candidates: [{ id: 1, name: 'Frank' }],
      index: 0,
      questions: [this.question],
      handleChange: function() { }
    })

    spyOn(this.props, 'handleChange')
    this.setUpComponent(DummyTable, this.props)
    this.component = this.component.refs.question
  })

  it('text set by props', function() {
    expect(this.dom.querySelector('[name=text]').value).toEqual(this.props.text)
  })
  it('text updates when changed', function() {
    this.component.handleChange({ target: { name: 'text', value: 'New Name'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      { questions: [_.defaults(this.question, { text: 'New Name' })] })
  })

  it('displays answers', function() {
    expect(this.dom.querySelector('[name=candidate_0]').value).toEqual(
      this.props.answers[0].text)
  })
  it('updates answers', function() {
    var event = { target: { name: 'candidate_0', value: 'different' } }
    this.component.handleAnswerChange(event)
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      { questions: [_.defaults(this.question, { answers: [{ candidate_id: 1, text: 'different' }] })] })
  })

  describe('with no answers', function() {
    beforeEach(function() {
      this.question = {
        id: 5,
        text: 'The Best Question',
        answers: [{ candidate_id: 1, text: 'Noop' }],
        tags: [{ name: 'LGBTQ' }, { name: 'Climate Change' }]
      }
      this.props = _.defaults(this.question, {
        candidates: [{ id: 1, name: 'Frank' }],
        index: 0,
        questions: [this.question],
        handleChange: function() { }
      })

      spyOn(this.props, 'handleChange')

      this.setUpComponent(DummyTable, this.props)
      this.component = this.component.refs.question
    })

    it('updates answers', function() {
      var event = { target: { name: 'candidate_0', value: 'different' } }
      this.component.handleAnswerChange(event)
      expect(this.component.props.handleChange).toHaveBeenCalledWith(
        { questions: [_.defaults(this.question, { answers: [{ candidate_id: 1, text: 'different' }] })] })
    })
  })

  xit('displays tags', function() {
    expect(this.dom.querySelectorAll('.tag').length).toEqual(2)
    expect(this.dom.querySelector('.tag span').innerText).toEqual('LGBTQ')
  })
  xit('adds tags', function() {
    this.component.addTag('Diff')
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      { questions: [_.defaults(this.question, { tags: [
        { name: 'LGBTQ' }, { name: 'Climate Change'},
        { tagged_id: 5, name: 'Diff', tagged_type: 'question' } ] })] })
  })
  xit('removes tags', function() {
    this.component.removeTag('LGBTQ')
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      { questions: [_.defaults(this.question, { tags: [{ name: 'Climate Change'}] })] })
  })

  describe('with no tags', function() {
    beforeEach(function() {
      this.question = {
        id: 5,
        text: 'The Best Question',
        answers: [{ candidate_id: 1, text: 'Noop' }],
        tags: [{ name: 'LGBTQ' }, { name: 'Climate Change' }]
      }
      this.props = _.defaults(this.question, {
        candidates: [{ id: 1, name: 'Frank' }],
        index: 0,
        questions: [this.question],
        handleChange: function() { }
      })

      spyOn(this.props, 'handleChange')

      this.setUpComponent(DummyTable, this.props)
      this.component = this.component.refs.question
    })

    it('adds tags', function() {
    this.component.addTag('Diff')
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      { questions: [_.defaults(this.question, { tags: [
        { tagged_id: 5, name: 'Diff', tagged_type: 'question' }] })] })
    })
  })
  it('handles removal', function() {
    this.component.handleRemove({ preventDefault: function() { } })
    swalSpy.confirmLast(true)
    expect(this.component.props.handleChange).toHaveBeenCalledWith({
      questions: [] })
  })

  describe('with two questions', function() {
    beforeEach(function() {
      this.question = {}
      this.other_question = {}

      this.props = {
        index: 0,
        questions: [this.question, this.other_question],
        handleChange: function() { },
      }

      spyOn(this.props, 'handleChange')
      this.setUpComponent(DummyTable, this.props)
      this.component = this.component.refs.question
    })
    it('handleDragOver reorders the questions', function() {
      this.component.handleDragOver(0, 1)
      expect(this.component.props.handleChange).toHaveBeenCalledWith(
        'questions', [this.other_question, this.question])
    })
  })
})
