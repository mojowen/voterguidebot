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
    it('adds new questions', function() {
      this.component.handleClickToAddQuestion({ preventDefault: function() {}})
      expect(this.component.state.questions.length).toEqual(2)
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
})

