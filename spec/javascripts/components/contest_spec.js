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
    this.dom.querySelector('[name=title]').value = 'New Title'
    Utils.Simulate.change(this.dom.querySelector('[name=title]'))
    expect(this.component.state.title).toEqual('New Title')
    expect(this.component.state.changed).toEqual(true)
  })

  it('description set by props', function() {
    expect(this.dom.querySelector('[name=description]').value).toEqual(this.props.description)
  })
  it('description updates when changed', function() {
    this.dom.querySelector('[name=description]').value = 'New description'
    Utils.Simulate.change(this.dom.querySelector('[name=description]'))
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
        endorsements: ['Cool Dudes Inc'],
      }
      this.other_candidate = { id: 6 }
      this.props = { candidates: [this.candidate, this.other_candidate] }
      this.setUpComponent(Contest, this.props)
    })

    it('updates when changed', function() {
      Utils.Simulate.click(this.dom.querySelector('.candidate--form a'))
      this.dom.querySelector('.candidate--form [name=name]').value = 'Seth Rogan'
      Utils.Simulate.change(this.dom.querySelector('.candidate--form [name=name]'))
      expect(this.component.state.candidates[0].name).toEqual('Seth Rogan')
      expect(this.component.state.changed).toEqual(true)
    })
    it('adds new candidates', function() {
      Utils.Simulate.click(this.dom.querySelector('a i.fa-plus-circle'))

      expect(this.component.state.candidates.length).toEqual(3)
      expect(this.component.state.changed).toEqual(true)
    })
    it('deletes candidates', function() {
      Utils.Simulate.click(this.dom.querySelector('i.remove--candidate'))
      swalSpy.confirmLast(true)
      expect(this.component.state.candidates.length).toEqual(1)
      expect(this.component.state.changed).toEqual(true)
    })
    it('reorders the candidates when dragged', function() {
      expect(this.component.state.candidates).toEqual([this.candidate, this.other_candidate])

      Utils.Simulate.dragStart(this.dom.querySelectorAll('.candidate--form')[1])
      Utils.Simulate.dragOver(this.dom.querySelectorAll('.candidate--form')[0])

      expect(this.component.state.candidates).toEqual([this.other_candidate, this.candidate])
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
      this.other_question = { id: 5 }
      this.props = {
        candidates: [this.candidate],
        questions: [this.question, this.other_question],
      }
      this.setUpComponent(Contest, this.props)
    })

    it('updates when changed', function() {
      this.dom.querySelector('td [name=text]').value = 'LOVE ME?'
      Utils.Simulate.change(this.dom.querySelector('td [name=text]'))

      expect(this.component.state.questions[0].text).toEqual('LOVE ME?')
      expect(this.component.state.changed).toEqual(true)
    })
    it('updates when the questions answerd', function() {
      this.dom.querySelector('td [name=candidate_0]').value = 'Yes?'
      Utils.Simulate.change(this.dom.querySelector('td [name=candidate_0]'))

      expect(this.component.state.questions[0].answers[0].text).toEqual('Yes?')
      expect(this.component.state.changed).toEqual(true)
    })
    it('deletes questions', function() {
      Utils.Simulate.click(this.dom.querySelector('td a.remove'))

      swalSpy.confirmLast(true)
      expect(this.component.state.questions.length).toEqual(1)
      expect(this.component.state.changed).toEqual(true)
    })
    it('adds new candidates to questions', function() {
      expect(this.dom.querySelectorAll('th').length).toEqual(3)
      Utils.Simulate.click(this.dom.querySelector('a i.fa-plus-circle'))
      expect(this.dom.querySelectorAll('th').length).toEqual(4)
    })
    it('removes candidates from questions', function() {
      Utils.Simulate.click(this.dom.querySelector('i.remove--candidate'))
      swalSpy.confirmLast(true)
      swalSpy.confirmLast(true)
      expect(this.component.state.changed).toEqual(true)
    })
    it('reorders the questions when dragged', function() {
      expect(this.component.state.questions).toEqual([this.question, this.other_question])

      Utils.Simulate.dragStart(this.dom.querySelectorAll('.question')[1])
      Utils.Simulate.dragOver(this.dom.querySelectorAll('.question')[0])

      expect(this.component.state.questions).toEqual([this.other_question, this.question])
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
                                   tag: 'Economy' },
                                 { text: 'ANOTHER ONE',
                                   tag: 'DJ Khaled' }]

      this.props = {
        candidates: [this.candidate],
        questions: [],
        template: {
          endorsements: { max: 3 },
          questions: { samples: this.template_questions, max: 7, text: { limit: 140 } }
        }
      }
      this.setUpComponent(Contest, this.props)
      this.add_question = this.component.refs.questions.refs.add_question
      Utils.Simulate.click(this.dom.querySelectorAll('a.mui-btn--accent i.fa-plus-circle')[1])
    })

    it('creates a select for template questions', function() {
      var tags = this.dom.querySelectorAll('.add--question select optgroup')
      expect(tags[0].label).toEqual(this.template_questions[0].tag)
      expect(tags[1].label).toEqual(this.template_questions[1].tag)

      var sample_qs = this.dom.querySelectorAll('.add--question select option')
      expect(sample_qs[1].innerText).toEqual(this.template_questions[0].text)
      expect(sample_qs[2].innerText).toEqual(this.template_questions[1].text)
    })

    it('selects a template question and creaets a new question', function() {
      this.dom.querySelector('.mui-select select').value = this.template_questions[0].text
      Utils.Simulate.change(this.dom.querySelector('.mui-select select'))

      expect(this.component.state.questions[0].text).toEqual(this.template_questions[0].text)
    })
    it('selects blank question adds new blank question', function() {
      Utils.Simulate.click(this.dom.querySelector('a.mui-btn--primary i.fa-plus-circle'))

      expect(this.component.state.questions[0].text).toEqual()
    })
  })
})

