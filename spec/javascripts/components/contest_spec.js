describe('Contest', function() {
  beforeEach(function() {
    this.props = {
      title: 'This Contest',
      description: 'Mike Well Made It'
    }
    this.setUpComponent(Contest, this.props)
  })

  it('initializes a new contest if empty props if null', function() {
    expect(this.component.state.candidates.length).toEqual(1)
  })

  it('title set by props', function() {
    expect(this.dom.querySelector('[name=title]').value).toEqual(this.props.title)
    expect(this.component.state.changed).toEqual(false)
  })
  it('title updates when changed', function() {
    this.component.handleChange({ target: { name: 'title', value: 'New Title'}})
    expect(this.component.state.title).toEqual('New Title')
    expect(this.component.state.changed).toEqual(true)
  })

  it('description set by props', function() {
    expect(this.dom.querySelector('[name=description]').value).toEqual(this.props.description)
  })
  it('description updates when changed', function() {
    this.component.handleChange({ target: { name: 'description', value: 'New description'}})
    expect(this.component.state.description).toEqual('New description')
    expect(this.component.state.changed).toEqual(true)
  })

  describe('tracks candidates', function(){
    beforeEach(function() {
      this.candidate = {
        name: 'Katherine Hegel',
        bio: 'The greatest',
        photo: '/my/photo',
        id: 5,
        endorsements: ['Cool Dudes Inc']
      }
      this.props = { candidates: [this.candidate] }
      this.setUpComponent(Contest, this.props)
    })

    it('updates when changed', function() {
      this.component.handleCandidateChange(this.candidate.id, 'name', 'Seth Rogan')
      expect(this.component.state.candidates[0].name).toEqual('Seth Rogan')
      expect(this.component.state.changed).toEqual(true)
    })
    it('adds new candidates', function() {
      this.component.handleClickToAddCandidate({ preventDefault: function() {}})
      expect(this.component.state.candidates.length).toEqual(2)
      expect(this.component.state.changed).toEqual(true)
    })
    it('deletes candidates', function() {
      this.component.handleCandidateRemove(this.candidate.id)
      swalSpy.confirmLast(true)
      expect(this.component.state.candidates.length).toEqual(0)
      expect(this.component.state._candidates).toEqual([this.candidate.id])
      expect(this.component.state.changed).toEqual(true)
    })
  })

  describe('tracks questions', function(){
    beforeEach(function() {
      this.candidate = {
        name: 'Katherine Hegel',
        bio: 'The greatest',
        photo: '/my/photo',
        id: 5,
        endorsements: ['Cool Dudes Inc']
      }
      this.question = {
        text: 'WHAT ARE THOSE',
        id: 8
      }
      this.props = {
        candidates: [this.candidate],
        questions: [this.question]
      }
      this.setUpComponent(Contest, this.props)
    })

    it('updates when changed', function() {
      this.component.handleQuestionChange(this.question.id, 'text', 'LOVE ME?')
      expect(this.component.state.questions[0].text).toEqual('LOVE ME?')
      expect(this.component.state.changed).toEqual(true)
    })
    it('deletes questions', function() {
      this.component.handleQuestionRemove(this.question.id)
      swalSpy.confirmLast(true)
      expect(this.component.state.questions.length).toEqual(0)
      expect(this.component.state._questions).toEqual([this.question.id])
      expect(this.component.state.changed).toEqual(true)
    })
    it('adds new candidates to questions', function() {
      expect(this.dom.querySelectorAll('th').length).toEqual(3)
      this.component.handleClickToAddCandidate({ preventDefault: function() {}})
      expect(this.dom.querySelectorAll('th').length).toEqual(4)
    })
    it('removes candidates from questions', function() {
      this.component.handleCandidateRemove(this.candidate.id)
      swalSpy.confirmLast(true)
      expect(this.component.state.changed).toEqual(true)
    })
  })

  describe('template questions', function() {
    beforeEach(function() {
      this.candidate = {
        name: 'Katherine Hegel',
        bio: 'The greatest',
        photo: '/my/photo',
        id: 5,
        endorsements: ['Cool Dudes Inc']
      }
      this.template_questions = [{ text: 'WHAT ARE THOSE',
                                   tags: [{ name: 'Economy' }],
                                   id: 8 },
                                { text: 'ANOTHER ONE',
                                  tags: [{ name: 'DJ Khaled' }],
                                  id: 8 }]

      this.props = {
        candidates: [this.candidate],
        template_questions: this.template_questions
      }
      this.setUpComponent(Contest, this.props)
      this.add_question = this.component.refs.questions.refs.add_question
      this.add_question.handleAddQuestionStart({ preventDefault: function() {} })
    })

    it('creates a select for template questions', function() {
      var tags = this.dom.querySelectorAll('.add--question select optgroup')
      expect(tags[0].label).toEqual(this.template_questions[0].tags[0].name)
      expect(tags[1].label).toEqual(this.template_questions[1].tags[0].name)

      var sample_qs = this.dom.querySelectorAll('.add--question select option')
      expect(sample_qs[1].innerText).toEqual(this.template_questions[0].text)
      expect(sample_qs[2].innerText).toEqual(this.template_questions[1].text)
    })

    it('selects a template question and creaets a new question', function() {
      this.add_question.handleAddSelected({
        target: this.dom.querySelector('.add--question select option') })
      expect(this.component.state.questions[0].text).toEqual(this.template_questions.text)
    })
    it('selects blank question adds new blank question', function() {
      this.add_question.handleAddBlank({ preventDefault: function() {} })
      expect(this.component.state.questions[0].text).toEqual(undefined)
    })
  })
})

